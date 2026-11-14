//
//  HolographicFoil.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 15.11.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

static float foilLuma(half4 color) {
    return dot(float3(color.rgb) / max(float(color.a), 0.0001f), float3(0.2126f, 0.7152f, 0.0722f));
}

[[ stitchable ]]
half4 holographicFoil(float2 position, SwiftUI::Layer layer, float2 size,
                      float time, float2 pointer, float strength, float density) {
    half4 source = layer.sample(position);
    if (source.a <= 0.0h || strength <= 0.0f) return source;

    float2 uv = position / max(size, float2(1.0f));
    float2 gradient = float2(
        foilLuma(layer.sample(position + float2(2, 0))) - foilLuma(layer.sample(position - float2(2, 0))),
        foilLuma(layer.sample(position + float2(0, 2))) - foilLuma(layer.sample(position - float2(0, 2)))
    );
    float3 normal = normalize(float3(-gradient * 2.0f + (uv - 0.5f) * 0.25f, 1.0f));
    float3 light = normalize(float3((pointer - 0.5f) * 2.8f, 1.0f));
    float3 halfway = normalize(light + float3(0, 0, 1));
    float specular = pow(max(dot(normal, halfway), 0.0f), 28.0f);

    // Spectral bands follow the light direction; microscopic grooves break up the sheen.
    float phase = dot(uv, float2(1.3f, 0.75f)) + dot(normal.xy, light.xy) * 0.8f;
    phase += (pointer.x - pointer.y) * 0.7f + sin(time * 0.45f) * 0.09f;
    float3 spectrum = 0.5f + 0.5f * cos(6.2831853f * (phase + float3(0, 0.333f, 0.667f)));
    float groovePhase = (uv.x + uv.y * 0.45f) * density;
    float antialias = 1.0f - smoothstep(0.3f, 0.65f, fwidth(groovePhase));
    float grooves = 0.92f + 0.08f * cos(groovePhase * 6.2831853f) * antialias;
    float glint = pow(max(sin(uv.x * 173.0f + sin(uv.y * 91.0f)) *
                          sin(uv.y * 157.0f - phase * 9.0f), 0.0f), 20.0f);
    float3 base = float3(source.rgb) / float(source.a);
    float3 foil = base * (0.55f + spectrum * 0.45f) * grooves;
    foil += spectrum * (0.18f + specular * 0.36f) + glint * specular * 0.22f;
    return half4(half3(clamp(mix(base, foil, clamp(strength, 0.0f, 1.0f)), 0.0f, 1.0f)) * source.a, source.a);
}
