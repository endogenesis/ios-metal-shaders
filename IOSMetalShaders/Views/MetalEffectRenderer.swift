//
//  MetalEffectRenderer.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 21.09.2026.
//

import MetalKit

@MainActor
final class MetalEffectRenderer {
    private let device: MTLDevice
    private let queue: MTLCommandQueue
    private let library: MTLLibrary
    private var computePipelines: [String: MTLComputePipelineState] = [:]
    private var fieldTexture: MTLTexture?
    private var historyTextures: [MTLTexture] = []
    private var historyIndex = 0
    private var frameIndex: UInt32 = 0
    private var chemistryTextures: [MTLTexture] = []
    private var chemistryIndex = 0
    private var particlePipeline: MTLRenderPipelineState?

    init?(device: MTLDevice) {
        guard let queue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary() else { return nil }
        self.device = device
        self.queue = queue
        self.library = library
    }

    func resetState() {
        fieldTexture = nil
        historyTextures = []
        historyIndex = 0
        frameIndex = 0
        chemistryTextures = []
        chemistryIndex = 0
    }

    func makeTexture(
        width: Int,
        height: Int,
        format: MTLPixelFormat,
        usage: MTLTextureUsage = [.shaderRead, .shaderWrite]
    ) -> MTLTexture? {
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: format,
            width: width,
            height: height,
            mipmapped: false
        )
        descriptor.usage = usage
        descriptor.storageMode = .private
        return device.makeTexture(descriptor: descriptor)
    }

    func pipeline(_ name: String) -> MTLComputePipelineState? {
        if let existing = computePipelines[name] { return existing }
        guard let function = library.makeFunction(name: name),
              let pipeline = try? device.makeComputePipelineState(function: function) else {
            return nil
        }
        computePipelines[name] = pipeline
        return pipeline
    }

    func dispatch<Uniforms>(
        _ name: String,
        into commandBuffer: MTLCommandBuffer,
        textures: [MTLTexture?],
        uniforms: inout Uniforms,
        width: Int,
        height: Int
    ) {
        guard let pipeline = pipeline(name),
              let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
        encoder.setComputePipelineState(pipeline)
        for (index, texture) in textures.enumerated() {
            encoder.setTexture(texture, index: index)
        }
        withUnsafeBytes(of: &uniforms) { bytes in
            guard let baseAddress = bytes.baseAddress else { return }
            encoder.setBytes(baseAddress, length: bytes.count, index: 0)
        }
        let groupWidth = min(8, pipeline.threadExecutionWidth)
        encoder.dispatchThreads(
            MTLSize(width: width, height: height, depth: 1),
            threadsPerThreadgroup: MTLSize(width: groupWidth, height: 8, depth: 1)
        )
        encoder.endEncoding()
    }

    func render(
        _ parameters: MetalEffectParameters,
        source: MTLTexture,
        target: MTLTexture?,
        drawable: CAMetalDrawable
    ) {
        guard let commandBuffer = queue.makeCommandBuffer() else { return }
        switch parameters.kind {
        case .morph:
            guard let target else { return }
            renderMorph(
                parameters,
                source: source,
                target: target,
                output: drawable.texture,
                commandBuffer: commandBuffer
            )
        case .feedback:
            renderFeedback(
                parameters,
                source: source,
                output: drawable.texture,
                commandBuffer: commandBuffer
            )
        case .reactionDiffusion:
            renderReactionDiffusion(
                parameters,
                source: source,
                output: drawable.texture,
                commandBuffer: commandBuffer
            )
        case .particles:
            renderParticles(
                parameters,
                source: source,
                output: drawable.texture,
                commandBuffer: commandBuffer
            )
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    private func renderMorph(
        _ parameters: MetalEffectParameters,
        source: MTLTexture,
        target: MTLTexture,
        output: MTLTexture,
        commandBuffer: MTLCommandBuffer
    ) {
        let fieldWidth = (source.width + 15) / 16
        let fieldHeight = (source.height + 15) / 16
        if fieldTexture?.width != fieldWidth || fieldTexture?.height != fieldHeight {
            fieldTexture = makeTexture(
                width: fieldWidth,
                height: fieldHeight,
                format: .rg16Float
            )
        }
        guard let fieldTexture else { return }
        var uniforms = MorphUniforms(
            width: UInt32(source.width),
            height: UInt32(source.height),
            fieldWidth: UInt32(fieldWidth),
            fieldHeight: UInt32(fieldHeight),
            progress: parameters.progress,
            intensity: parameters.intensity,
            mode: parameters.mode,
            padding: 0
        )
        dispatch(
            "morphCorrespondence",
            into: commandBuffer,
            textures: [source, target, fieldTexture],
            uniforms: &uniforms,
            width: fieldWidth,
            height: fieldHeight
        )
        dispatch(
            "dualTextureMorph",
            into: commandBuffer,
            textures: [source, target, fieldTexture, output],
            uniforms: &uniforms,
            width: source.width,
            height: source.height
        )
    }

    private func renderFeedback(
        _ parameters: MetalEffectParameters,
        source: MTLTexture,
        output: MTLTexture,
        commandBuffer: MTLCommandBuffer
    ) {
        if historyTextures.first?.width != source.width
            || historyTextures.first?.height != source.height {
            guard let first = makeTexture(
                width: source.width, height: source.height, format: .rgba16Float
            ), let second = makeTexture(
                width: source.width, height: source.height, format: .rgba16Float
            ) else { return }
            historyTextures = [first, second]
            historyIndex = 0
            frameIndex = 0
        }
        guard historyTextures.count == 2 else { return }

        let previous = historyTextures[historyIndex]
        let next = historyTextures[1 - historyIndex]
        var uniforms = FeedbackUniforms(
            width: UInt32(source.width),
            height: UInt32(source.height),
            frameIndex: frameIndex,
            padding: 0,
            center: parameters.center,
            intensity: parameters.intensity,
            decay: 0.978
        )
        if frameIndex == 0 {
            dispatch(
                "feedbackSeed",
                into: commandBuffer,
                textures: [source, previous],
                uniforms: &uniforms,
                width: source.width,
                height: source.height
            )
        }
        dispatch(
            "temporalFeedback",
            into: commandBuffer,
            textures: [source, previous, next],
            uniforms: &uniforms,
            width: source.width,
            height: source.height
        )
        dispatch(
            "feedbackComposite",
            into: commandBuffer,
            textures: [next, output],
            uniforms: &uniforms,
            width: source.width,
            height: source.height
        )
        historyIndex = 1 - historyIndex
        frameIndex &+= 1
    }

    private func renderReactionDiffusion(
        _ parameters: MetalEffectParameters,
        source: MTLTexture,
        output: MTLTexture,
        commandBuffer: MTLCommandBuffer
    ) {
        let width = max(source.width / 2, 1)
        let height = max(source.height / 2, 1)
        if chemistryTextures.first?.width != width
            || chemistryTextures.first?.height != height {
            guard let first = makeTexture(width: width, height: height, format: .rg16Float),
                  let second = makeTexture(width: width, height: height, format: .rg16Float)
            else { return }
            chemistryTextures = [first, second]
            chemistryIndex = 0
            frameIndex = 0
        }
        guard chemistryTextures.count == 2 else { return }

        var uniforms = ReactionUniforms(
            width: UInt32(width),
            height: UInt32(height),
            mode: parameters.mode,
            touching: parameters.touching ? 1 : 0,
            touch: parameters.center,
            step: 0,
            frameIndex: frameIndex
        )
        if frameIndex == 0 {
            dispatch(
                "reactionSeed",
                into: commandBuffer,
                textures: [chemistryTextures[0]],
                uniforms: &uniforms,
                width: width,
                height: height
            )
        }
        for step in 0..<10 {
            uniforms.step = UInt32(step)
            dispatch(
                "reactionStep",
                into: commandBuffer,
                textures: [chemistryTextures[chemistryIndex], chemistryTextures[1 - chemistryIndex]],
                uniforms: &uniforms,
                width: width,
                height: height
            )
            chemistryIndex = 1 - chemistryIndex
        }
        dispatch(
            "reactionComposite",
            into: commandBuffer,
            textures: [source, chemistryTextures[chemistryIndex], output],
            uniforms: &uniforms,
            width: source.width,
            height: source.height
        )
        frameIndex &+= 1
    }

    private func renderParticles(
        _ parameters: MetalEffectParameters,
        source: MTLTexture,
        output: MTLTexture,
        commandBuffer: MTLCommandBuffer
    ) {
        if particlePipeline == nil {
            guard let vertex = library.makeFunction(name: "particleShatterVertex"),
                  let fragment = library.makeFunction(name: "particleShatterFragment")
            else { return }
            let descriptor = MTLRenderPipelineDescriptor()
            descriptor.vertexFunction = vertex
            descriptor.fragmentFunction = fragment
            descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            descriptor.colorAttachments[0].isBlendingEnabled = true
            descriptor.colorAttachments[0].rgbBlendOperation = .add
            descriptor.colorAttachments[0].alphaBlendOperation = .add
            descriptor.colorAttachments[0].sourceRGBBlendFactor = .one
            descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
            descriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            descriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
            particlePipeline = try? device.makeRenderPipelineState(descriptor: descriptor)
        }
        guard let particlePipeline else { return }

        let tileSize: UInt32 = 3
        let columns = (UInt32(source.width) + tileSize - 1) / tileSize
        let rows = (UInt32(source.height) + tileSize - 1) / tileSize
        var uniforms = ParticleUniforms(
            width: UInt32(source.width),
            height: UInt32(source.height),
            columns: columns,
            tileSize: tileSize,
            progress: min(max(parameters.progress, 0), 1),
            intensity: parameters.intensity,
            seed: 0xB47291,
            padding: 0
        )

        let pass = MTLRenderPassDescriptor()
        pass.colorAttachments[0].texture = output
        pass.colorAttachments[0].loadAction = .clear
        pass.colorAttachments[0].storeAction = .store
        pass.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: pass) else {
            return
        }
        encoder.setRenderPipelineState(particlePipeline)
        encoder.setVertexBytes(&uniforms, length: MemoryLayout<ParticleUniforms>.stride, index: 0)
        encoder.setFragmentTexture(source, index: 0)
        encoder.setFragmentBytes(&uniforms, length: MemoryLayout<ParticleUniforms>.stride, index: 0)
        encoder.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: 6,
            instanceCount: Int(columns * rows)
        )
        encoder.endEncoding()
    }
}

struct MorphUniforms {
    var width: UInt32
    var height: UInt32
    var fieldWidth: UInt32
    var fieldHeight: UInt32
    var progress: Float
    var intensity: Float
    var mode: UInt32
    var padding: UInt32
}

struct FeedbackUniforms {
    var width: UInt32
    var height: UInt32
    var frameIndex: UInt32
    var padding: UInt32
    var center: SIMD2<Float>
    var intensity: Float
    var decay: Float
}

struct ReactionUniforms {
    var width: UInt32
    var height: UInt32
    var mode: UInt32
    var touching: UInt32
    var touch: SIMD2<Float>
    var step: UInt32
    var frameIndex: UInt32
}

struct ParticleUniforms {
    var width: UInt32
    var height: UInt32
    var columns: UInt32
    var tileSize: UInt32
    var progress: Float
    var intensity: Float
    var seed: UInt32
    var padding: UInt32
}
