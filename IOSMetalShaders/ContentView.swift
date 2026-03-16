//
//  ContentView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.12.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppTheme.cardSpacing) {
                    VStack(alignment: .leading) {
                        Text("GPU effects built with SwiftUI and Metal.")
                            .font(.headline)

                        Text("Move the sliders to see how Swift values become shader uniforms.")
                            .foregroundStyle(.secondary)
                    }

                    GrayscaleDemoView()
                    ScanlinesDemoView()
                    WaveDemoView()
                    OilPaintDemoView()
                    HueRotationDemoView()
                    PencilSketchDemoView()
                    MacroblockErrorDemoView()
                    FrostedNoiseDemoView()
                    TapeWrinkleDemoView()
                    ChannelFreezeDemoView()
                    SignalScrambleDemoView()
                    BurnDissolveDemoView()
                    ChromaticAberrationDemoView()
                    BarcodeGlitchDemoView()
                    HexBokehDemoView()
                    FeedbackLoopDemoView()
                    PixelSortingDemoView()
                    CrosshatchDemoView()
                    SharpenDemoView()
                    RollingScanlinesDemoView()
                    DuotoneDemoView()
                    BlockDisplacementDemoView()
                    PageCurlDemoView()
                    SobelEdgesDemoView()
                    WaterDropletsDemoView()
                    CRTSyncLossDemoView()
                    FireDemoView()
                    ChannelSwapDemoView()
                    TiltShiftDemoView()
                    VignetteDemoView()
                    WatercolorDemoView()
                    LaplacianEdgesDemoView()
                    VHSTrackingDemoView()
                    BoxBlurDemoView()
                    StarfieldDemoView()
                    PerspectiveTiltDemoView()
                    HalftoneDemoView()
                    BayerDitherDemoView()
                    ColorInvertDemoView()
                    EchoFramesDemoView()
                    PixelTransitionDemoView()
                    IrisRevealDemoView()
                    RippleDemoView()
                    FilmGrainDemoView()
                    BrightnessDemoView()
                    DirectionalBlurDemoView()
                    BlueNoiseDitherDemoView()
                    MagnifyingGlassDemoView()
                    StippleDemoView()
                    SpherizeDemoView()
                    ZoomBlurDemoView()
                }
                .padding()
            }
            .navigationTitle("Metal Shader Lab")
        }
    }
}

#Preview {
    ContentView()
}
