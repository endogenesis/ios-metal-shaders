# iOS Metal Shaders

A dependency-free gallery of 150+ interactive Metal shader demos built with
SwiftUI. Each effect pairs a focused `[[ stitchable ]]` Metal function with a
runnable SwiftUI example and live controls.

## Highlights

- 150+ shader demos across eight categories
- Animated shaders driven by `TimelineView`
- No third-party dependencies

## Categories

| Category | Examples |
| --- | --- |
| Glitch | Datamosh, VHS Tracking, RGB Split, Broken LCD |
| Color & Tone | Color Curves, Tritone, Vibrance, Temperature |
| Blur & Light | Bloom, Tilt Shift, God Rays, Lens Flare |
| Distortion | Ripple, Liquid Glass, Kaleidoscope, Heat Haze |
| Pixel & Texture | Bayer Dither, Voronoi Cells, Paper Grain, Pixelate |
| Stylization & Edges | Oil Paint, Watercolor, Toon Shade, Sobel Edges |
| Transitions & Masks | Burn Dissolve, Iris Reveal, Chroma Key, Linear Wipe |
| Procedural & Animated | Fire, Starfield, Metaballs, Water Caustics |

## How SwiftUI finds a shader

Functions marked `[[ stitchable ]]` are compiled into the app's default Metal
library. SwiftUI exposes them through dynamic member lookup:

```swift
ShaderCanvasView()
    .colorEffect(
        ShaderLibrary.grayscale(.float(0.8))
    )
```

The Swift arguments must match the extra arguments in the Metal function in the
same order.

| SwiftUI modifier | Use it when the shader... |
| --- | --- |
| `colorEffect` | changes the color of the current pixel |
| `distortionEffect` | changes where a pixel is sampled from |
| `layerEffect` | samples neighboring pixels or combines multiple samples |

For distortion and layer effects, make sure `maxSampleOffset` covers the largest
sampling distance used by the shader.

## Project structure

```text
IOSMetalShaders/
├── IOSMetalShadersApp.swift
├── ContentView.swift
├── ShaderDemo.swift          # Demo registry and category mapping
├── ShaderCategory.swift
├── ShaderSortOrder.swift
├── AppTheme.swift
├── Shaders/                  # One focused .metal file per effect
└── Views/
    ├── ShaderCanvasView.swift
    ├── ShaderPreviewCard.swift
    ├── ShaderDemoList.swift
    └── *DemoView.swift       # SwiftUI preview and controls for each shader
```

## Adding a shader

1. Add a `[[ stitchable ]]` function in `IOSMetalShaders/Shaders`.
2. Create a matching `*DemoView.swift` with a preview and controls.
3. Register the demo in `ShaderDemo`.
4. Assign it to one of the categories in `ShaderDemo.category`.
5. Build and test the effect on a simulator or device.

## Learning resources

- [The Book of Shaders: Procedural Textures](https://thebookofshaders.com/examples/?chapter=proceduralTexture) — examples built from random, noise, cellular noise, and fractal Brownian motion techniques.
- [SwiftUI `colorEffect`](https://developer.apple.com/documentation/swiftui/view/coloreffect(_:isenabled:))
- [SwiftUI `distortionEffect`](https://developer.apple.com/documentation/swiftui/view/distortioneffect(_:maxsampleoffset:isenabled:))
- [SwiftUI `layerEffect`](https://developer.apple.com/documentation/swiftui/view/layereffect(_:maxsampleoffset:isenabled:))

## License

This project is available under the [MIT License](LICENSE).
