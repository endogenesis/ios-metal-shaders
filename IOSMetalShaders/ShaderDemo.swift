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
    case timeDisplacement
    case blueprint
    case exposure
    case displacementNoise
    case paperGrain
    case plasmaField
    case gaussianBlur
    case auroraGradient
    case mosaic
    case datamosh
    case liquidGlass
    case swirlTunnel
    case cyberpunkGlitch
    case bloom
    case pincushionDistortion
    case radialBlur
    case checkerPattern
    case dataCorruption
    case softGlow
    case rgbSplit
    case contrast
    case noiseWarp
    case emboss
    case scanlineJitter
    case rainGlass
    case unsharpMask
    case channelDrift
    case fluidGradient
    case pinch
    case waveInterference
    case lumaKey
    case bulge
    case digitalStatic
    case circleReveal
    case sepia
    case snowfall
    case polarWarp
    case lightLeak
    case colorQuantizationGlitch
    case godRays
    case flagDistortion
    case analogStatic
    case stuckPixels
    case terminalGlitch
    case dotMatrix
    case signalNoise
    case metaballs
    case posterize
    case radialWipe
    case lineDropout
    case levels
    case ghosting
    case doubleVision
    case horizontalTear
    case compressionArtifacts
    case chromaKey
    case fisheye
    case deadPixels
    case verticalTear
    case kaleidoscope
    case glitchMosaic
    case heatHaze
    case sliceGlitch
    case colorBalance
    case toonShade
    case vhsHeadSwitch
    case pixelate
    case vibrance
    case noiseDissolve
    case interlacing
    case lensRefraction
    case displacementTransition
    case saturation
    case mirror
    case temperature
    case bitCrush
    case outline
    case threshold
    case fragmentShuffle
    case twirl
    case thermalVision
    case frameJitter
    case crtPhosphorMask
    case linearWipe
    case waterCaustics
    case crtCurvature
    case brokenLCD
    case pixelSorting

    var id: Self { self }

    var category: ShaderCategory {
        switch self {
        case .scanlines, .macroblockError, .tapeWrinkle, .channelFreeze,
             .signalScramble, .chromaticAberration, .barcodeGlitch, .feedbackLoop,
             .pixelSorting, .rollingScanlines, .blockDisplacement, .crtSyncLoss,
             .channelSwap, .vhsTracking, .echoFrames, .colorBandShift:
            .glitch

        case .timeDisplacement, .displacementNoise, .datamosh, .cyberpunkGlitch,
             .dataCorruption, .rgbSplit, .noiseWarp, .scanlineJitter, .channelDrift,
             .waveInterference, .digitalStatic, .colorQuantizationGlitch,
             .analogStatic, .stuckPixels, .terminalGlitch, .signalNoise,
             .lineDropout, .ghosting, .doubleVision, .horizontalTear,
             .compressionArtifacts, .deadPixels, .verticalTear, .glitchMosaic,
             .sliceGlitch, .vhsHeadSwitch, .interlacing, .bitCrush,
             .fragmentShuffle, .frameJitter, .crtPhosphorMask, .crtCurvature,
             .brokenLCD:
            .glitch

        case .grayscale, .hueRotation, .duotone, .colorInvert, .brightness, .tint,
             .gamma, .solarize, .colorCurves, .shadowsHighlights, .tritone:
            .colorAndTone

        case .exposure, .contrast, .sepia, .posterize, .levels, .colorBalance,
             .vibrance, .saturation, .temperature, .threshold:
            .colorAndTone

        case .hexBokeh, .sharpen, .tiltShift, .vignette, .boxBlur,
             .directionalBlur, .zoomBlur, .motionBlur, .lensFlare:
            .blurAndLight

        case .gaussianBlur, .bloom, .radialBlur, .softGlow, .unsharpMask,
             .lightLeak, .godRays:
            .blurAndLight

        case .wave, .pageCurl, .waterDroplets, .perspectiveTilt, .ripple,
             .magnifyingGlass, .spherize, .barrelDistortion:
            .distortion

        case .liquidGlass, .swirlTunnel, .pincushionDistortion, .pinch, .bulge,
             .polarWarp, .flagDistortion, .fisheye, .kaleidoscope, .heatHaze,
             .lensRefraction, .mirror, .twirl:
            .distortion

        case .frostedNoise, .halftone, .bayerDither, .filmGrain, .blueNoiseDither,
             .voronoiCells, .canvasTexture:
            .pixelAndTexture

        case .paperGrain, .mosaic, .checkerPattern, .dotMatrix, .pixelate:
            .pixelAndTexture

        case .oilPaint, .pencilSketch, .crosshatch, .sobelEdges, .watercolor,
             .laplacianEdges, .stipple:
            .stylizationAndEdges

        case .blueprint, .emboss, .toonShade, .outline, .thermalVision:
            .stylizationAndEdges

        case .burnDissolve, .pixelTransition, .irisReveal:
            .transitionsAndMasks

        case .lumaKey, .circleReveal, .radialWipe, .chromaKey, .noiseDissolve,
             .displacementTransition, .linearWipe:
            .transitionsAndMasks

        case .fire, .starfield, .smoke:
            .proceduralAndAnimated

        case .plasmaField, .auroraGradient, .rainGlass, .fluidGradient, .snowfall,
             .metaballs, .waterCaustics:
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
        case .timeDisplacement:
            TimeDisplacementDemoView()
        case .blueprint:
            BlueprintDemoView()
        case .exposure:
            ExposureDemoView()
        case .displacementNoise:
            DisplacementNoiseDemoView()
        case .paperGrain:
            PaperGrainDemoView()
        case .plasmaField:
            PlasmaFieldDemoView()
        case .gaussianBlur:
            GaussianBlurDemoView()
        case .auroraGradient:
            AuroraGradientDemoView()
        case .mosaic:
            MosaicDemoView()
        case .datamosh:
            DatamoshDemoView()
        case .liquidGlass:
            LiquidGlassDemoView()
        case .swirlTunnel:
            SwirlTunnelDemoView()
        case .cyberpunkGlitch:
            CyberpunkGlitchDemoView()
        case .bloom:
            BloomDemoView()
        case .pincushionDistortion:
            PincushionDistortionDemoView()
        case .radialBlur:
            RadialBlurDemoView()
        case .checkerPattern:
            CheckerPatternDemoView()
        case .dataCorruption:
            DataCorruptionDemoView()
        case .softGlow:
            SoftGlowDemoView()
        case .rgbSplit:
            RGBSplitDemoView()
        case .contrast:
            ContrastDemoView()
        case .noiseWarp:
            NoiseWarpDemoView()
        case .emboss:
            EmbossDemoView()
        case .scanlineJitter:
            ScanlineJitterDemoView()
        case .rainGlass:
            RainGlassDemoView()
        case .unsharpMask:
            UnsharpMaskDemoView()
        case .channelDrift:
            ChannelDriftDemoView()
        case .fluidGradient:
            FluidGradientDemoView()
        case .pinch:
            PinchDemoView()
        case .waveInterference:
            WaveInterferenceDemoView()
        case .lumaKey:
            LumaKeyDemoView()
        case .bulge:
            BulgeDemoView()
        case .digitalStatic:
            DigitalStaticDemoView()
        case .circleReveal:
            CircleRevealDemoView()
        case .sepia:
            SepiaDemoView()
        case .snowfall:
            SnowfallDemoView()
        case .polarWarp:
            PolarWarpDemoView()
        case .lightLeak:
            LightLeakDemoView()
        case .colorQuantizationGlitch:
            ColorQuantizationGlitchDemoView()
        case .godRays:
            GodRaysDemoView()
        case .flagDistortion:
            FlagDistortionDemoView()
        case .analogStatic:
            AnalogStaticDemoView()
        case .stuckPixels:
            StuckPixelsDemoView()
        case .terminalGlitch:
            TerminalGlitchDemoView()
        case .dotMatrix:
            DotMatrixDemoView()
        case .signalNoise:
            SignalNoiseDemoView()
        case .metaballs:
            MetaballsDemoView()
        case .posterize:
            PosterizeDemoView()
        case .radialWipe:
            RadialWipeDemoView()
        case .lineDropout:
            LineDropoutDemoView()
        case .levels:
            LevelsDemoView()
        case .ghosting:
            GhostingDemoView()
        case .doubleVision:
            DoubleVisionDemoView()
        case .horizontalTear:
            HorizontalTearDemoView()
        case .compressionArtifacts:
            CompressionArtifactsDemoView()
        case .chromaKey:
            ChromaKeyDemoView()
        case .fisheye:
            FisheyeDemoView()
        case .deadPixels:
            DeadPixelsDemoView()
        case .verticalTear:
            VerticalTearDemoView()
        case .kaleidoscope:
            KaleidoscopeDemoView()
        case .glitchMosaic:
            GlitchMosaicDemoView()
        case .heatHaze:
            HeatHazeDemoView()
        case .sliceGlitch:
            SliceGlitchDemoView()
        case .colorBalance:
            ColorBalanceDemoView()
        case .toonShade:
            ToonShadeDemoView()
        case .vhsHeadSwitch:
            VHSHeadSwitchDemoView()
        case .pixelate:
            PixelateDemoView()
        case .vibrance:
            VibranceDemoView()
        case .noiseDissolve:
            NoiseDissolveDemoView()
        case .interlacing:
            InterlacingDemoView()
        case .lensRefraction:
            LensRefractionDemoView()
        case .displacementTransition:
            DisplacementTransitionDemoView()
        case .saturation:
            SaturationDemoView()
        case .mirror:
            MirrorDemoView()
        case .temperature:
            TemperatureDemoView()
        case .bitCrush:
            BitCrushDemoView()
        case .outline:
            OutlineDemoView()
        case .threshold:
            ThresholdDemoView()
        case .fragmentShuffle:
            FragmentShuffleDemoView()
        case .twirl:
            TwirlDemoView()
        case .thermalVision:
            ThermalVisionDemoView()
        case .frameJitter:
            FrameJitterDemoView()
        case .crtPhosphorMask:
            CRTPhosphorMaskDemoView()
        case .linearWipe:
            LinearWipeDemoView()
        case .waterCaustics:
            WaterCausticsDemoView()
        case .crtCurvature:
            CRTCurvatureDemoView()
        case .brokenLCD:
            BrokenLCDDemoView()
        case .pixelSorting:
            PixelSortingDemoView()
        }
    }
}
