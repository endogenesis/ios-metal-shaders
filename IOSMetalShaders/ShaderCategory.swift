//
//  ShaderCategory.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.04.2026.
//

enum ShaderCategory: String, CaseIterable, Identifiable {
    case glitch = "Glitch"
    case colorAndTone = "Color & Tone"
    case blurAndLight = "Blur & Light"
    case distortion = "Distortion"
    case pixelAndTexture = "Pixel & Texture"
    case stylizationAndEdges = "Stylization & Edges"
    case transitionsAndMasks = "Transitions & Masks"
    case proceduralAndAnimated = "Procedural & Animated"

    var id: Self { self }
}
