//
//  SovereignConfig.swift
//  SovereignPlayerSDK
//
//  Copyright (c) 2026 Sovereign Byte Technology. All Rights Reserved.
//

import Foundation

/// Configuration options for Sovereign Media Engine.
public struct SovereignConfig: Sendable, Equatable {
    /// Enables real-time Metal compute pipeline for Contrast Adaptive Sharpening (CAS) and HDR.
    public var enableMetalHDR: Bool

    /// Contrast Adaptive Sharpening (CAS) strength from 0.0 (off) to 1.0 (maximum edge contrast).
    public var sharpness: Float

    /// Peak display target in nits (e.g. 1000.0 for HDR / Apple Liquid Retina XDR).
    public var peakNits: Float

    /// Wide Color Gamut (WCG) saturation expansion factor (1.0 to 1.3).
    public var saturationBoost: Float

    /// Gamma correction curve exponent (default 2.2).
    public var gamma: Float

    /// Zero-latency timeline scrubbing with zero-tolerance keyframe navigation.
    public var zeroLatencyScrubbing: Bool

    public init(
        enableMetalHDR: Bool = true,
        sharpness: Float = 0.45,
        peakNits: Float = 1000.0,
        saturationBoost: Float = 1.15,
        gamma: Float = 2.2,
        zeroLatencyScrubbing: Bool = true
    ) {
        self.enableMetalHDR = enableMetalHDR
        self.sharpness = sharpness
        self.peakNits = peakNits
        self.saturationBoost = saturationBoost
        self.gamma = gamma
        self.zeroLatencyScrubbing = zeroLatencyScrubbing
    }

    /// Standard low-overhead playback configuration (HDR upscaler disabled).
    public static let `default` = SovereignConfig(
        enableMetalHDR: false,
        sharpness: 0.0,
        zeroLatencyScrubbing: true
    )

    /// Maximum performance configuration utilizing real-time 10-bit Rec.2020 HDR compute shaders.
    public static let turboHDR = SovereignConfig(
        enableMetalHDR: true,
        sharpness: 0.45,
        peakNits: 1000.0,
        saturationBoost: 1.15,
        gamma: 2.2,
        zeroLatencyScrubbing: true
    )
}
