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

    init?(device: MTLDevice) {
        guard let queue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary() else { return nil }
        self.device = device
        self.queue = queue
        self.library = library
    }

    func resetState() {
        fieldTexture = nil
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

    func dispatch(
        _ name: String,
        into commandBuffer: MTLCommandBuffer,
        textures: [MTLTexture?],
        uniforms: inout MorphUniforms,
        width: Int,
        height: Int
    ) {
        guard let pipeline = pipeline(name),
              let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
        encoder.setComputePipelineState(pipeline)
        for (index, texture) in textures.enumerated() {
            encoder.setTexture(texture, index: index)
        }
        encoder.setBytes(&uniforms, length: MemoryLayout<MorphUniforms>.stride, index: 0)
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
        case .feedback, .reactionDiffusion, .particles:
            return
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
