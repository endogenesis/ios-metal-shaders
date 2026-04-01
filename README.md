# iOS Metal Shaders

A dependency-free collection of 100+ Metal shaders demonstrated with SwiftUI on iOS.

## Categories

- **Glitch**
- **Color & Tone**
- **Blur & Light**
- **Distortion**
- **Pixel & Texture**
- **Stylization & Edges**
- **Transitions & Masks**
- **Procedural & Animated**

## Requirements

- Xcode 26 or newer
- iOS 26 or newer
- Swift 6

SwiftUI shader effects themselves are available from iOS 17. You can lower the
deployment target if the surrounding SwiftUI code still supports your target OS.

## Run

1. Open `IOSMetalShaders.xcodeproj`.
2. Select an iPhone simulator.
3. Build and run.

## Project structure

```text
IOSMetalShaders/
├── IOSMetalShadersApp.swift
├── ContentView.swift
├── AppTheme.swift
├── Shaders/
│   └── Shaders.metal
└── Views/
    ├── ShaderCanvasView.swift
    ├── ShaderPreviewCard.swift
    ├── GrayscaleDemoView.swift
    ├── ScanlinesDemoView.swift
    └── WaveDemoView.swift
```

## How SwiftUI finds a shader

Functions marked `[[ stitchable ]]` are compiled into the app's default Metal
library. SwiftUI exposes them through dynamic member lookup:

```swift
.colorEffect(
    ShaderLibrary.grayscale(.float(0.8))
)
```

The Swift arguments must match the extra arguments in the Metal function in the
same order.
