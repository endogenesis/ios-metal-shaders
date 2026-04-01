//
//  ShaderDemo.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.04.2026.
//

import SwiftUI

enum ShaderDemo: Int, CaseIterable, Identifiable {
    case grayscale
    case scanlines
    case wave
    case oilPaint
    case hueRotation
    case pencilSketch
    case macroblockError
    case frostedNoise
    case tapeWrinkle
    case channelFreeze
    case signalScramble
    case burnDissolve
    case chromaticAberration
    case barcodeGlitch
    case hexBokeh
    case feedbackLoop
    case pixelSorting
    case crosshatch
    case sharpen
    case rollingScanlines
    case duotone
    case blockDisplacement
    case pageCurl
    case sobelEdges
    case waterDroplets
    case crtSyncLoss
    case fire
    case channelSwap
    case tiltShift
    case vignette
    case watercolor
    case laplacianEdges
    case vhsTracking
    case boxBlur
    case starfield
    case perspectiveTilt
    case halftone
    case bayerDither
    case colorInvert
    case echoFrames
    case pixelTransition
    case irisReveal
    case ripple
    case filmGrain
    case brightness
    case directionalBlur
    case blueNoiseDither
    case magnifyingGlass
    case stipple
    case spherize
    case zoomBlur
    case barrelDistortion
    case voronoiCells
    case canvasTexture
    case motionBlur
    case lensFlare
    case smoke
    case tint
    case gamma
    case solarize
    case colorCurves
    case shadowsHighlights
    case colorBandShift
    case tritone

    var id: Self { self }

    var category: ShaderCategory {
        switch self {
        case .scanlines, .macroblockError, .tapeWrinkle, .channelFreeze,
             .signalScramble, .chromaticAberration, .barcodeGlitch, .feedbackLoop,
             .pixelSorting, .rollingScanlines, .blockDisplacement, .crtSyncLoss,
             .channelSwap, .vhsTracking, .echoFrames, .colorBandShift:
            .glitch

        case .grayscale, .hueRotation, .duotone, .colorInvert, .brightness, .tint,
             .gamma, .solarize, .colorCurves, .shadowsHighlights, .tritone:
            .colorAndTone

        case .hexBokeh, .sharpen, .tiltShift, .vignette, .boxBlur,
             .directionalBlur, .zoomBlur, .motionBlur, .lensFlare:
            .blurAndLight

        case .wave, .pageCurl, .waterDroplets, .perspectiveTilt, .ripple,
             .magnifyingGlass, .spherize, .barrelDistortion:
            .distortion

        case .frostedNoise, .halftone, .bayerDither, .filmGrain, .blueNoiseDither,
             .voronoiCells, .canvasTexture:
            .pixelAndTexture

        case .oilPaint, .pencilSketch, .crosshatch, .sobelEdges, .watercolor,
             .laplacianEdges, .stipple:
            .stylizationAndEdges

        case .burnDissolve, .pixelTransition, .irisReveal:
            .transitionsAndMasks

        case .fire, .starfield, .smoke:
            .proceduralAndAnimated
        }
    }

    @ViewBuilder
    var content: some View {
        switch self {
        case .grayscale:
            GrayscaleDemoView()
        case .scanlines:
            ScanlinesDemoView()
        case .wave:
            WaveDemoView()
        case .oilPaint:
            OilPaintDemoView()
        case .hueRotation:
            HueRotationDemoView()
        case .pencilSketch:
            PencilSketchDemoView()
        case .macroblockError:
            MacroblockErrorDemoView()
        case .frostedNoise:
            FrostedNoiseDemoView()
        case .tapeWrinkle:
            TapeWrinkleDemoView()
        case .channelFreeze:
            ChannelFreezeDemoView()
        case .signalScramble:
            SignalScrambleDemoView()
        case .burnDissolve:
            BurnDissolveDemoView()
        case .chromaticAberration:
            ChromaticAberrationDemoView()
        case .barcodeGlitch:
            BarcodeGlitchDemoView()
        case .hexBokeh:
            HexBokehDemoView()
        case .feedbackLoop:
            FeedbackLoopDemoView()
        case .pixelSorting:
            PixelSortingDemoView()
        case .crosshatch:
            CrosshatchDemoView()
        case .sharpen:
            SharpenDemoView()
        case .rollingScanlines:
            RollingScanlinesDemoView()
        case .duotone:
            DuotoneDemoView()
        case .blockDisplacement:
            BlockDisplacementDemoView()
        case .pageCurl:
            PageCurlDemoView()
        case .sobelEdges:
            SobelEdgesDemoView()
        case .waterDroplets:
            WaterDropletsDemoView()
        case .crtSyncLoss:
            CRTSyncLossDemoView()
        case .fire:
            FireDemoView()
        case .channelSwap:
            ChannelSwapDemoView()
        case .tiltShift:
            TiltShiftDemoView()
        case .vignette:
            VignetteDemoView()
        case .watercolor:
            WatercolorDemoView()
        case .laplacianEdges:
            LaplacianEdgesDemoView()
        case .vhsTracking:
            VHSTrackingDemoView()
        case .boxBlur:
            BoxBlurDemoView()
        case .starfield:
            StarfieldDemoView()
        case .perspectiveTilt:
            PerspectiveTiltDemoView()
        case .halftone:
            HalftoneDemoView()
        case .bayerDither:
            BayerDitherDemoView()
        case .colorInvert:
            ColorInvertDemoView()
        case .echoFrames:
            EchoFramesDemoView()
        case .pixelTransition:
            PixelTransitionDemoView()
        case .irisReveal:
            IrisRevealDemoView()
        case .ripple:
            RippleDemoView()
        case .filmGrain:
            FilmGrainDemoView()
        case .brightness:
            BrightnessDemoView()
        case .directionalBlur:
            DirectionalBlurDemoView()
        case .blueNoiseDither:
            BlueNoiseDitherDemoView()
        case .magnifyingGlass:
            MagnifyingGlassDemoView()
        case .stipple:
            StippleDemoView()
        case .spherize:
            SpherizeDemoView()
        case .zoomBlur:
            ZoomBlurDemoView()
        case .barrelDistortion:
            BarrelDistortionDemoView()
        case .voronoiCells:
            VoronoiCellsDemoView()
        case .canvasTexture:
            CanvasTextureDemoView()
        case .motionBlur:
            MotionBlurDemoView()
        case .lensFlare:
            LensFlareDemoView()
        case .smoke:
            SmokeDemoView()
        case .tint:
            TintDemoView()
        case .gamma:
            GammaDemoView()
        case .solarize:
            SolarizeDemoView()
        case .colorCurves:
            ColorCurvesDemoView()
        case .shadowsHighlights:
            ShadowsHighlightsDemoView()
        case .colorBandShift:
            ColorBandShiftDemoView()
        case .tritone:
            TritoneDemoView()
        }
    }
}
