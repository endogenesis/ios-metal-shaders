//
//  ShaderDemo.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.04.2026.
//

import SwiftUI

enum ShaderDemo: String, CaseIterable, Identifiable {
    case grayscale = "Grayscale"
    case scanlines = "Scanlines"
    case wave = "Wave"
    case oilPaint = "Oil Paint"
    case hueRotation = "Hue Rotation"
    case pencilSketch = "Pencil Sketch"
    case macroblockError = "Macroblock Error"
    case frostedNoise = "Frosted Noise"
    case tapeWrinkle = "Tape Wrinkle"
    case channelFreeze = "Channel Freeze"
    case signalScramble = "Signal Scramble"
    case burnDissolve = "Burn Dissolve"
    case chromaticAberration = "Chromatic Aberration"
    case barcodeGlitch = "Barcode Glitch"
    case hexBokeh = "Hex Bokeh"
    case feedbackLoop = "Feedback Loop"
    case crosshatch = "Crosshatch"
    case sharpen = "Sharpen"
    case rollingScanlines = "Rolling Scanlines"
    case duotone = "Duotone"
    case blockDisplacement = "Block Displacement"
    case pageCurl = "Page Curl"
    case sobelEdges = "Sobel Edges"
    case waterDroplets = "Water Droplets"
    case crtSyncLoss = "CRT Sync Loss"
    case fire = "Fire"
    case channelSwap = "Channel Swap"
    case tiltShift = "Tilt Shift"
    case vignette = "Vignette"
    case watercolor = "Watercolor"
    case laplacianEdges = "Laplacian Edges"
    case vhsTracking = "VHS Tracking"
    case boxBlur = "Box Blur"
    case starfield = "Starfield"
    case perspectiveTilt = "Perspective Tilt"
    case halftone = "Halftone"
    case bayerDither = "Bayer Dither"
    case colorInvert = "Color Invert"
    case echoFrames = "Echo Frames"
    case pixelTransition = "Pixel Transition"
    case irisReveal = "Iris Reveal"
    case ripple = "Ripple"
    case filmGrain = "Film Grain"
    case brightness = "Brightness"
    case directionalBlur = "Directional Blur"
    case blueNoiseDither = "Blue Noise Dither"
    case magnifyingGlass = "Magnifying Glass"
    case stipple = "Stipple"
    case spherize = "Spherize"
    case zoomBlur = "Zoom Blur"
    case barrelDistortion = "Barrel Distortion"
    case voronoiCells = "Voronoi Cells"
    case canvasTexture = "Canvas Texture"
    case motionBlur = "Motion Blur"
    case lensFlare = "Lens Flare"
    case smoke = "Smoke"
    case tint = "Tint"
    case gamma = "Gamma"
    case solarize = "Solarize"
    case colorCurves = "Color Curves"
    case shadowsHighlights = "Shadows & Highlights"
    case colorBandShift = "Color Band Shift"
    case tritone = "Tritone"
    case timeDisplacement = "Time Displacement"
    case blueprint = "Blueprint"
    case exposure = "Exposure"
    case displacementNoise = "Displacement Noise"
    case paperGrain = "Paper Grain"
    case plasmaField = "Plasma Field"
    case gaussianBlur = "Gaussian Blur"
    case auroraGradient = "Aurora Gradient"
    case mosaic = "Mosaic"
    case datamosh = "Datamosh"
    case liquidGlass = "Liquid Glass"
    case swirlTunnel = "Swirl Tunnel"
    case cyberpunkGlitch = "Cyberpunk Glitch"
    case bloom = "Bloom"
    case pincushionDistortion = "Pincushion Distortion"
    case radialBlur = "Radial Blur"
    case checkerPattern = "Checker Pattern"
    case dataCorruption = "Data Corruption"
    case softGlow = "Soft Glow"
    case rgbSplit = "RGB Split"
    case contrast = "Contrast"
    case noiseWarp = "Noise Warp"
    case emboss = "Emboss"
    case scanlineJitter = "Scanline Jitter"
    case rainGlass = "Rain Glass"
    case unsharpMask = "Unsharp Mask"
    case channelDrift = "Channel Drift"
    case fluidGradient = "Fluid Gradient"
    case pinch = "Pinch"
    case waveInterference = "Wave Interference"
    case lumaKey = "Luma Key"
    case bulge = "Bulge"
    case digitalStatic = "Digital Static"
    case circleReveal = "Circle Reveal"
    case sepia = "Sepia"
    case snowfall = "Snowfall"
    case polarWarp = "Polar Warp"
    case lightLeak = "Light Leak"
    case colorQuantizationGlitch = "Color Quantization Glitch"
    case godRays = "God Rays"
    case flagDistortion = "Flag Distortion"
    case analogStatic = "Analog Static"
    case stuckPixels = "Stuck Pixels"
    case terminalGlitch = "Terminal Glitch"
    case dotMatrix = "Dot Matrix"
    case signalNoise = "Signal Noise"
    case metaballs = "Metaballs"
    case posterize = "Posterize"
    case radialWipe = "Radial Wipe"
    case lineDropout = "Line Dropout"
    case levels = "Levels"
    case ghosting = "Ghosting"
    case doubleVision = "Double Vision"
    case horizontalTear = "Horizontal Tear"
    case compressionArtifacts = "Compression Artifacts"
    case chromaKey = "Chroma Key"
    case fisheye = "Fisheye"
    case deadPixels = "Dead Pixels"
    case verticalTear = "Vertical Tear"
    case kaleidoscope = "Kaleidoscope"
    case glitchMosaic = "Glitch Mosaic"
    case heatHaze = "Heat Haze"
    case sliceGlitch = "Slice Glitch"
    case colorBalance = "Color Balance"
    case toonShade = "Toon Shade"
    case vhsHeadSwitch = "VHS Head Switch"
    case pixelate = "Pixelate"
    case vibrance = "Vibrance"
    case noiseDissolve = "Noise Dissolve"
    case interlacing = "Interlacing"
    case lensRefraction = "Lens Refraction"
    case displacementTransition = "Displacement Transition"
    case saturation = "Saturation"
    case mirror = "Mirror"
    case temperature = "Temperature"
    case bitCrush = "Bit Crush"
    case outline = "Outline"
    case threshold = "Threshold"
    case fragmentShuffle = "Fragment Shuffle"
    case twirl = "Twirl"
    case thermalVision = "Thermal Vision"
    case frameJitter = "Frame Jitter"
    case crtPhosphorMask = "CRT Phosphor Mask"
    case linearWipe = "Linear Wipe"
    case waterCaustics = "Water Caustics"
    case crtCurvature = "CRT Curvature"
    case brokenLCD = "Broken LCD"
    case pixelSorting = "Pixel Sorting"
    case dualTextureMorph = "Dual-Texture Morph"
    case temporalFeedbackPortal = "Temporal Feedback Portal"
    case reactionDiffusionInk = "Reaction-Diffusion Ink"
    case particleShatter = "Particle Shatter / Reassemble"
    case borderBeam = "Border Beam"

    var id: Self { self }

    var name: String { rawValue }

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
             .brokenLCD, .temporalFeedbackPortal:
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
             .displacementTransition, .linearWipe, .dualTextureMorph,
             .particleShatter:
            .transitionsAndMasks

        case .fire, .starfield, .smoke:
            .proceduralAndAnimated

        case .plasmaField, .auroraGradient, .rainGlass, .fluidGradient, .snowfall,
             .metaballs, .waterCaustics, .reactionDiffusionInk, .borderBeam:
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
        case .dualTextureMorph:
            DualTextureMorphDemoView()
        case .temporalFeedbackPortal:
            TemporalFeedbackPortalDemoView()
        case .reactionDiffusionInk:
            ReactionDiffusionInkDemoView()
        case .particleShatter:
            ParticleShatterDemoView()
        case .borderBeam:
            BorderBeamDemoView()
        }
    }
}
