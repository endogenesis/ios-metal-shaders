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

    @ViewBuilder private let content: Content

    init(
        amount: Float,
        thresholdMinimum: Float,
        thresholdMaximum: Float,
        direction: UInt32,
        keyMode: UInt32,
        descending: Bool,
        @ViewBuilder content: () -> Content
    ) {
        self.amount = amount
        self.thresholdMinimum = thresholdMinimum
        self.thresholdMaximum = thresholdMaximum
        self.direction = direction
        self.keyMode = keyMode
        self.descending = descending
        self.content = content()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView(frame: .zero, device: MTLCreateSystemDefaultDevice())
        context.coordinator.configure(view)
        update(view, coordinator: context.coordinator, shouldRefreshSource: true)
        return view
    }

    func updateUIView(_ view: MTKView, context: Context) {
        update(view, coordinator: context.coordinator, shouldRefreshSource: false)
        context.coordinator.drawWhenReady(in: view)
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
        coordinator: Coordinator,
        shouldRefreshSource: Bool
    ) {
        if shouldRefreshSource, let image = makeSourceImage() {
            coordinator.setSourceImage(image, in: view)
        }

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

        private static var itemStride: Int { 16 }

        private var commandQueue: MTLCommandQueue?
        private var computePipeline: MTLComputePipelineState?
        private var sourceTexture: MTLTexture?
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
                return
            }

            let computePipeline: MTLComputePipelineState
            do {
                computePipeline = try device.makeComputePipelineState(function: function)
            } catch {
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
                return
            }
            sourceTexture = texture

            uniforms.width = UInt32(image.width)
            uniforms.height = UInt32(image.height)
            view.drawableSize = CGSize(width: image.width, height: image.height)
            view.setNeedsDisplay()
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

        func drawWhenReady(in view: MTKView) {
            // setNeedsDisplay() can be consumed before an MTKView installed by
            // SwiftUI has a window/currentDrawable. Retry on the next main-actor
            // turn, when the view has completed layout.
            Task { @MainActor [weak view] in
                await Task.yield()
                view?.draw()
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
            guard let sourceTexture else {
                return
            }
            guard let computePipeline, let commandQueue else {
                return
            }
            guard let drawable = view.currentDrawable else {
                return
            }
            guard
                let commandBuffer = commandQueue.makeCommandBuffer(),
                let encoder = commandBuffer.makeComputeCommandEncoder()
            else {
                return
            }

            let lineLength = Int(uniforms.direction == 1 ? uniforms.height : uniforms.width)
            let lineCount = Int(uniforms.direction == 1 ? uniforms.width : uniforms.height)
            guard
                lineLength > 0,
                lineCount > 0,
                lineLength <= computePipeline.maxTotalThreadsPerThreadgroup,
                lineLength * Self.itemStride <= (view.device?.maxThreadgroupMemoryLength ?? 0)
            else {
                return
            }

            encoder.setComputePipelineState(computePipeline)
            encoder.setTexture(sourceTexture, index: 0)
            encoder.setTexture(drawable.texture, index: 1)
            encoder.setBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 0)
            encoder.setThreadgroupMemoryLength(lineLength * Self.itemStride, index: 0)
            encoder.dispatchThreadgroups(
                MTLSize(width: lineCount, height: 1, depth: 1),
                threadsPerThreadgroup: MTLSize(width: lineLength, height: 1, depth: 1)
            )
            encoder.endEncoding()

            commandBuffer.addCompletedHandler { commandBuffer in
                if let error = commandBuffer.error {
                    print("PixelSorting: command buffer failed: \(error)")
                }
            }
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        }
    }
}
