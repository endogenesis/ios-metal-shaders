//
//  MetalEffectView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 21.09.2026.
//

import MetalKit
import SwiftUI

enum MetalEffectKind: Equatable {
    case morph
    case feedback
    case reactionDiffusion
    case particles
}

struct MetalEffectParameters {
    let kind: MetalEffectKind
    var progress: Float = 0
    var intensity: Float = 0.5
    var mode: UInt32 = 0
    var center: SIMD2<Float> = SIMD2<Float>(0.5, 0.5)
    var touching = false
    var resetToken = 0
}

struct MetalEffectView<Source: View, Target: View>: UIViewRepresentable {
    static var renderSize: CGSize { CGSize(width: 320, height: 200) }

    let parameters: MetalEffectParameters
    let source: Source
    let target: Target

    init(
        parameters: MetalEffectParameters,
        @ViewBuilder source: () -> Source,
        @ViewBuilder target: () -> Target
    ) {
        self.parameters = parameters
        self.source = source()
        self.target = target()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView(frame: .zero, device: MTLCreateSystemDefaultDevice())
        view.isOpaque = false
        view.backgroundColor = .clear
        view.layer.isOpaque = false
        view.clearColor = MTLClearColorMake(0, 0, 0, 0)
        view.colorPixelFormat = .bgra8Unorm
        view.framebufferOnly = false
        view.autoResizeDrawable = false
        view.drawableSize = Self.renderSize
        view.enableSetNeedsDisplay = true
        view.isPaused = true
        context.coordinator.configure(view)
        captureScenes(in: view, coordinator: context.coordinator)
        context.coordinator.update(parameters, in: view)
        return view
    }

    func updateUIView(_ view: MTKView, context: Context) {
        if context.coordinator.resetToken != parameters.resetToken {
            captureScenes(in: view, coordinator: context.coordinator)
        }
        context.coordinator.update(parameters, in: view)
        // The drawable can be unavailable during makeUIView. Draw after layout.
        Task { @MainActor [weak view] in
            await Task.yield()
            view?.draw()
        }
    }

    static func dismantleUIView(_ view: MTKView, coordinator: Coordinator) {
        view.isPaused = true
        view.delegate = nil
    }

    func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: MTKView,
        context: Context
    ) -> CGSize? {
        let width = proposal.width ?? Self.renderSize.width
        return CGSize(width: width, height: width * 0.625)
    }

    private func captureScenes(in view: MTKView, coordinator: Coordinator) {
        guard let device = view.device else { return }
        coordinator.sourceTexture = Self.capture(source, device: device)
        if parameters.kind == .morph {
            coordinator.targetTexture = Self.capture(target, device: device)
        }
        coordinator.resetToken = parameters.resetToken
        coordinator.resetState()
    }

    private static func capture<V: View>(_ content: V, device: MTLDevice) -> MTLTexture? {
        let renderer = ImageRenderer(
            content: content.frame(width: renderSize.width, height: renderSize.height)
        )
        renderer.proposedSize = ProposedViewSize(renderSize)
        renderer.scale = 1
        guard let image = renderer.cgImage else { return nil }

        let bytesPerRow = image.width * 4
        var pixels = [UInt8](repeating: 0, count: bytesPerRow * image.height)
        let drawn = pixels.withUnsafeMutableBytes { buffer -> Bool in
            guard let context = CGContext(
                data: buffer.baseAddress,
                width: image.width,
                height: image.height,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
                    | CGBitmapInfo.byteOrder32Little.rawValue
            ) else { return false }
            context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
            return true
        }
        guard drawn else { return nil }

        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .bgra8Unorm,
            width: image.width,
            height: image.height,
            mipmapped: false
        )
        descriptor.storageMode = .shared
        descriptor.usage = .shaderRead
        guard let texture = device.makeTexture(descriptor: descriptor) else { return nil }
        pixels.withUnsafeBytes { buffer in
            guard let baseAddress = buffer.baseAddress else { return }
            texture.replace(
                region: MTLRegionMake2D(0, 0, image.width, image.height),
                mipmapLevel: 0,
                withBytes: baseAddress,
                bytesPerRow: bytesPerRow
            )
        }
        return texture
    }

    @MainActor
    final class Coordinator: NSObject, MTKViewDelegate {
        var sourceTexture: MTLTexture?
        var targetTexture: MTLTexture?
        var resetToken = 0

        private var renderer: MetalEffectRenderer?
        private var parameters = MetalEffectParameters(kind: .morph)

        func configure(_ view: MTKView) {
            guard let device = view.device else { return }
            renderer = MetalEffectRenderer(device: device)
            view.delegate = self
        }

        func resetState() {
            renderer?.resetState()
        }

        func update(_ value: MetalEffectParameters, in view: MTKView) {
            parameters = value
            view.setNeedsDisplay()
        }

        func draw(in view: MTKView) {
            guard let sourceTexture, let renderer, let drawable = view.currentDrawable else {
                return
            }
            renderer.render(
                parameters,
                source: sourceTexture,
                target: targetTexture,
                drawable: drawable
            )
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            resetState()
        }
    }
}

extension MetalEffectView where Target == EmptyView {
    init(parameters: MetalEffectParameters, @ViewBuilder source: () -> Source) {
        self.init(parameters: parameters, source: source, target: { EmptyView() })
    }
}
