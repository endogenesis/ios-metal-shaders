import SwiftUI

enum BorderBeamPalettePreset: String, CaseIterable, Identifiable {
    case original = "Original"
    case colorful = "Colorful"
    case gemini = "Gemini"
    case neon = "Neon"
    case sunset = "Sunset"
    case aurora = "Aurora"
    case silver = "Silver"
    case mono = "White"

    var id: Self { self }

    var colors: [Color] {
        switch self {
        case .original: BeamPalette.spectrum
        case .colorful: BeamPalette.colorful
        case .gemini: BeamPalette.gemini
        case .neon: BeamPalette.neon
        case .sunset: BeamPalette.sunset
        case .aurora: BeamPalette.aurora
        case .silver: BeamPalette.silver
        case .mono: BeamPalette.mono
        }
    }

    // The reference uses Spectrum on the prompt and Colorful on the small and line demos.
    var controlColors: [Color] {
        self == .original ? BeamPalette.colorful : colors
    }
}
