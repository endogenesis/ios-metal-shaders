//
//  ContentView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.12.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var sortOrder = ShaderSortOrder.newest

    private let topAnchor = "shader-gallery-top"

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(
                        alignment: .leading,
                        spacing: AppTheme.cardSpacing,
                        pinnedViews: sortOrder == .category ? .sectionHeaders : []
                    ) {
                        VStack(alignment: .leading) {
                            Text("GPU effects built with SwiftUI and Metal.")
                                .font(.headline)

                            Text("Move the sliders to see how Swift values become shader uniforms.")
                                .foregroundStyle(.secondary)
                        }
                        .id(topAnchor)

                        TimeDisplacementDemoView()

                        BlueprintDemoView()

                        ExposureDemoView()

                        DisplacementNoiseDemoView()

                        PaperGrainDemoView()

                        PlasmaFieldDemoView()

                        GaussianBlurDemoView()

                        AuroraGradientDemoView()

                        MosaicDemoView()

                        DatamoshDemoView()

                        LiquidGlassDemoView()

                        SwirlTunnelDemoView()

                        CyberpunkGlitchDemoView()

                        BloomDemoView()

                        PincushionDistortionDemoView()

                        RadialBlurDemoView()

                        CheckerPatternDemoView()

                        DataCorruptionDemoView()

                        SoftGlowDemoView()

                        RGBSplitDemoView()

                        ContrastDemoView()

                        NoiseWarpDemoView()

                        EmbossDemoView()

                        ScanlineJitterDemoView()

                        RainGlassDemoView()

                        UnsharpMaskDemoView()

                        ChannelDriftDemoView()

                        FluidGradientDemoView()

                        PinchDemoView()

                        WaveInterferenceDemoView()

                        LumaKeyDemoView()

                        BulgeDemoView()

                        DigitalStaticDemoView()

                        CircleRevealDemoView()

                        SepiaDemoView()

                        SnowfallDemoView()

                        PolarWarpDemoView()

                        LightLeakDemoView()

                        ColorQuantizationGlitchDemoView()

                        GodRaysDemoView()

                        FlagDistortionDemoView()

                        AnalogStaticDemoView()

                        StuckPixelsDemoView()

                        TerminalGlitchDemoView()

                        DotMatrixDemoView()

                        SignalNoiseDemoView()

                        MetaballsDemoView()

                        PosterizeDemoView()

                        RadialWipeDemoView()

                        LineDropoutDemoView()

                        LevelsDemoView()

                        GhostingDemoView()

                        DoubleVisionDemoView()

                        HorizontalTearDemoView()

                        ShaderDemoList(sortOrder: sortOrder)
                    }
                    .padding()
                }
                .navigationTitle("Metal Shader Lab")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Menu("Sort Shaders", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort Order", selection: $sortOrder) {
                                ForEach(ShaderSortOrder.allCases) { order in
                                    Label(order.title, systemImage: order.systemImage)
                                        .tag(order)
                                }
                            }
                        }

                        Button("Latest Shader", systemImage: "clock.arrow.circlepath") {
                            sortOrder = .newest

                            withAnimation {
                                proxy.scrollTo(topAnchor, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
