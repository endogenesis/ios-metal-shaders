//
//  PixelSortingMetalView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 10.09.2026.
//

import MetalKit
import SwiftUI

struct PixelSortingMetalView<Content: View>: UIViewRepresentable {
    private static var renderSize: CGSize { CGSize(width: 320, height: 200) }

    let amount: Float
    let thresholdMinimum: Float
    let thresholdMaximum: Float
    let direction: UInt32
    let keyMode: UInt32
    let descending: Bool
    let onRenderingError: @MainActor (String?) -> Void

    @ViewBuilder private let content: Content

    init(
        amount: Float,
        thresholdMinimum: Float,
        thresholdMaximum: Float,
        direction: UInt32,
        keyMode: UInt32,
        descending: Bool,
        onRenderingError: @escaping @MainActor (String?) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.amount = amount
        self.thresholdMinimum = thresholdMinimum
        self.thresholdMaximum = thresholdMaximum
        self.direction = direction
        self.keyMode = keyMode
        self.descending = descending
        self.onRenderingError = onRenderingError
        self.content = content()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> MTKView {
        let view = PixelSortingRenderView(frame: .zero, device: MTLCreateSystemDefaultDevice())
        context.coordinator.onRenderingError = onRenderingError
        context.coordinator.configure(view)
        update(view, coordinator: context.coordinator)
        return view
    }

    func updateUIView(_ view: MTKView, context: Context) {
        update(view, coordinator: context.coordinator)
    }

    static func dismantleUIView(_ view: MTKView, coordinator: Coordinator) {
        view.delegate = nil
        coordinator.makeSourceImage = nil
        coordinator.onRenderingError = nil
    }

    func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: MTKView,
        context: Context
    ) -> CGSize? {
        let width = proposal.width ?? Self.renderSize.width
        return CGSize(
            width: width,
            height: width * Self.renderSize.height / Self.renderSize.width
        )
    }

    private func update(
        _ view: MTKView,
        coordinator: Coordinator
    ) {
        // Capture after attachment/layout, not during SwiftUI's makeUIView.
        // Keep the provider so a failed first capture can be retried.
        coordinator.makeSourceImage = makeSourceImage
        coordinator.onRenderingError = onRenderingError

        coordinator.update(
            amount: amount,
            thresholdMinimum: thresholdMinimum,
            thresholdMaximum: thresholdMaximum,
            direction: direction,
            keyMode: keyMode,
            descending: descending,
            in: view
        )
    }

    private func makeSourceImage() -> CGImage? {
        let renderer = ImageRenderer(
            content: content.frame(
                width: Self.renderSize.width,
                height: Self.renderSize.height
            )
        )
        renderer.proposedSize = ProposedViewSize(Self.renderSize)
        renderer.scale = 1
        return renderer.cgImage
    }
}

extension PixelSortingMetalView {
    @MainActor
    final class Coordinator: NSObject, MTKViewDelegate {
        var makeSourceImage: (@MainActor () -> CGImage?)?
        var onRenderingError: (@MainActor (String?) -> Void)?

        private struct Uniforms {
            var width: UInt32
            var height: UInt32
            var direction: UInt32
            var keyMode: UInt32
            var thresholdMinimum: Float
            var thresholdMaximum: Float
            var amount: Float
            var descending: UInt32
        }

        private var commandQueue: MTLCommandQueue?
        private var computePipeline: MTLComputePipelineState?
        private var sourceTexture: MTLTexture?
        private var renderingError: String?
        private var uniforms = Uniforms(
            width: 0,
            height: 0,
            direction: 0,
            keyMode: 0,
            thresholdMinimum: 0,
            thresholdMaximum: 1,
            amount: 1,
            descending: 0
        )

        func configure(_ view: MTKView) {
            // Keep the SwiftUI source visible underneath until the first
            // successful compute frame has been presented.
            view.isOpaque = false
            view.backgroundColor = .clear
            view.layer.isOpaque = false
            view.clearColor = MTLClearColorMake(0, 0, 0, 0)

            guard
                let device = view.device,
                let commandQueue = device.makeCommandQueue(),
                let library = device.makeDefaultLibrary(),
                let function = library.makeFunction(name: "truePixelSort")
            else {
                reportError("Pixel sorting is unavailable on this device.")
                return
            }

            let computePipeline: MTLComputePipelineState
            do {
                computePipeline = try device.makeComputePipelineState(function: function)
            } catch {
                print("PixelSorting: pipeline creation failed: \(error)")
                reportError("Pixel sorting could not start.")
                return
            }

            self.commandQueue = commandQueue
            self.computePipeline = computePipeline

            view.delegate = self
            view.colorPixelFormat = .bgra8Unorm
            view.framebufferOnly = false
            view.autoResizeDrawable = false
            view.drawableSize = PixelSortingMetalView<Content>.renderSize
            view.enableSetNeedsDisplay = true
            view.isPaused = true
        }

        func setSourceImage(_ image: CGImage, in view: MTKView) {
            guard let device = view.device else {
                return
            }

            guard let texture = makeSourceTexture(from: image, device: device) else {
                reportError("Pixel sorting could not load the preview image.")
                return
            }
            sourceTexture = texture

            uniforms.width = UInt32(image.width)
            uniforms.height = UInt32(image.height)
            view.drawableSize = CGSize(width: image.width, height: image.height)
        }

        private func makeSourceTexture(
            from image: CGImage,
            device: MTLDevice
        ) -> MTLTexture? {
            let width = image.width
            let height = image.height
            let bytesPerPixel = 4
            let bytesPerRow = width * bytesPerPixel
            var pixels = [UInt8](repeating: 0, count: bytesPerRow * height)

            let didDraw = pixels.withUnsafeMutableBytes { buffer -> Bool in
                guard let context = CGContext(
                    data: buffer.baseAddress,
                    width: width,
                    height: height,
                    bitsPerComponent: 8,
                    bytesPerRow: bytesPerRow,
                    space: CGColorSpaceCreateDeviceRGB(),
                    bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
                        | CGBitmapInfo.byteOrder32Little.rawValue
                ) else {
                    return false
                }

                context.interpolationQuality = .high
                context.draw(
                    image,
                    in: CGRect(x: 0, y: 0, width: width, height: height)
                )
                return true
            }

            guard didDraw else {
                return nil
            }

            let descriptor = MTLTextureDescriptor.texture2DDescriptor(
                pixelFormat: .bgra8Unorm,
                width: width,
                height: height,
                mipmapped: false
            )
            descriptor.storageMode = .shared
            descriptor.usage = .shaderRead

            guard let texture = device.makeTexture(descriptor: descriptor) else {
                return nil
            }

            pixels.withUnsafeBytes { buffer in
                guard let baseAddress = buffer.baseAddress else {
                    return
                }
                texture.replace(
                    region: MTLRegionMake2D(0, 0, width, height),
                    mipmapLevel: 0,
                    withBytes: baseAddress,
                    bytesPerRow: bytesPerRow
                )
            }
            return texture
        }

        private func reportError(_ message: String?) {
            guard renderingError != message else { return }
            renderingError = message
            if let message {
                print("PixelSorting: \(message)")
            }
            // Errors can originate in makeUIView or a Metal completion handler.
            // Publish outside the current SwiftUI view update.
            Task { @MainActor [weak self] in
                self?.onRenderingError?(message)
            }
        }

        func update(
            amount: Float,
            thresholdMinimum: Float,
            thresholdMaximum: Float,
            direction: UInt32,
            keyMode: UInt32,
            descending: Bool,
            in view: MTKView
        ) {
            uniforms.amount = min(max(amount, 0), 1)
            uniforms.thresholdMinimum = min(max(thresholdMinimum, 0), 1)
            uniforms.thresholdMaximum = min(max(thresholdMaximum, 0), 1)
            uniforms.direction = direction
            uniforms.keyMode = keyMode
            uniforms.descending = descending ? 1 : 0
            view.setNeedsDisplay()
        }

        func draw(in view: MTKView) {
            guard view.window != nil, view.bounds.width > 0, view.bounds.height > 0 else {
                return
            }
            guard let computePipeline, let commandQueue else {
                return
            }
            if sourceTexture == nil {
                guard let image = makeSourceImage?() else {
                    reportError("Pixel sorting could not capture the preview image.")
                    return
                }
                setSourceImage(image, in: view)
            }
            guard let sourceTexture else { return }
            guard let drawable = view.currentDrawable else {
                return
            }
            guard
                let commandBuffer = commandQueue.makeCommandBuffer(),
                let encoder = commandBuffer.makeComputeCommandEncoder()
            else {
                reportError("Pixel sorting could not render this frame.")
                return
            }

            let width = Int(uniforms.width)
            let height = Int(uniforms.height)
            guard width > 0, height > 0 else {
                return
            }

            encoder.setComputePipelineState(computePipeline)
            encoder.setTexture(sourceTexture, index: 0)
            encoder.setTexture(drawable.texture, index: 1)
            encoder.setBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 0)

            let threadgroupWidth = min(computePipeline.threadExecutionWidth, width)
            let availableRows = computePipeline.maxTotalThreadsPerThreadgroup / threadgroupWidth
            let threadgroupHeight = min(max(availableRows, 1), min(8, height))
            encoder.dispatchThreadgroups(
                MTLSize(
                    width: (width + threadgroupWidth - 1) / threadgroupWidth,
                    height: (height + threadgroupHeight - 1) / threadgroupHeight,
                    depth: 1
                ),
                threadsPerThreadgroup: MTLSize(
                    width: threadgroupWidth,
                    height: threadgroupHeight,
                    depth: 1
                )
            )
            encoder.endEncoding()

            let reportCompletion: @MainActor @Sendable (String?) -> Void = { [weak self] message in
                self?.reportError(message)
            }
            commandBuffer.addCompletedHandler { commandBuffer in
                let errorDescription = commandBuffer.error?.localizedDescription
                if let errorDescription {
                    print("PixelSorting: command buffer failed: \(errorDescription)")
                }
                Task { @MainActor in
                    reportCompletion(
                        errorDescription == nil ? nil : "Pixel sorting could not render this frame."
                    )
                }
            }
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        }
    }
}

// A paused MTKView must be invalidated when UIKit actually attaches and lays it
// out. Task.yield() does not guarantee either event has happened in a LazyVStack.
private final class PixelSortingRenderView: MTKView {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            setNeedsDisplay()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if window != nil, bounds.width > 0, bounds.height > 0 {
            setNeedsDisplay()
        }
    }
}
