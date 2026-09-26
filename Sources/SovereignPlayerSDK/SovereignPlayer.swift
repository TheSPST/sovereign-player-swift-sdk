//
//  SovereignPlayer.swift
//  SovereignPlayerSDK
//
//  Copyright (c) 2026 Sovereign Byte Technology. All Rights Reserved.
//

import Foundation
import Combine
import SovereignPlayerCore
import MetalKit

/// The central media player controller for Sovereign Media Player.
@MainActor
public final class SovereignPlayer: ObservableObject {
    /// Active media URL loaded in the engine.
    @Published public private(set) var url: URL?

    /// Current playback status.
    @Published public private(set) var isPlaying: Bool = false

    /// Current playback position in seconds.
    @Published public private(set) var currentTime: Double = 0.0

    /// Total media duration in seconds.
    @Published public private(set) var duration: Double = 0.0

    /// Real-time hardware performance telemetry stream.
    @Published public private(set) var telemetry: SovereignTelemetry = SovereignTelemetry()

    /// Audio volume level from 0.0 (muted) to 1.0 (full).
    @Published public var volume: Float = 1.0 {
        didSet {
            coreEngine?.volume = volume
        }
    }

    /// Playback rate (1.0 = normal, 2.0 = 2x speed, etc.).
    @Published public var playbackRate: Float = 1.0 {
        didSet {
            coreEngine?.playbackRate = playbackRate
        }
    }

    /// Internal core engine handle.
    public private(set) var coreEngine: SovereignCoreEngine?
    private var telemetryTimer: Timer?
    private var configuration: SovereignConfig

    public init(url: URL? = nil, config: SovereignConfig = .turboHDR) {
        self.url = url
        self.configuration = config
        if let targetURL = url {
            load(url: targetURL, config: config)
        }
    }

    /// Loads a new media file or stream URL.
    public func load(url: URL, config: SovereignConfig? = nil) {
        if let newConfig = config {
            self.configuration = newConfig
        }
        self.url = url

        coreEngine?.shutdown()
        let coreConfig = SovereignCoreConfig()
        coreConfig.enableMetalHDR = configuration.enableMetalHDR
        coreConfig.sharpness = configuration.sharpness
        coreConfig.peakNits = configuration.peakNits
        coreConfig.saturationBoost = configuration.saturationBoost
        coreConfig.gamma = configuration.gamma
        coreConfig.zeroLatencyScrubbing = configuration.zeroLatencyScrubbing

        let engine = SovereignCoreEngine(url: url, config: coreConfig)
        engine.volume = volume
        self.coreEngine = engine

        startTelemetryPolling()
    }

    /// Starts or resumes media playback.
    public func play() {
        coreEngine?.play()
        isPlaying = true
    }

    /// Pauses media playback.
    public func pause() {
        coreEngine?.pause()
        isPlaying = false
    }

    /// Toggles between play and pause.
    public func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    /// Seeks to an absolute timestamp in seconds with zero-tolerance keyframe positioning.
    public func seek(to seconds: Double, completion: ((Bool) -> Void)? = nil) {
        coreEngine?.seek(toTime: seconds) { [weak self] finished in
            Task { @MainActor [weak self] in
                if finished {
                    self?.currentTime = seconds
                }
                completion?(finished)
            }
        }
    }

    /// Updates active engine configuration at runtime without interrupting playback.
    public func updateConfig(_ config: SovereignConfig) {
        self.configuration = config
        let coreConfig = SovereignCoreConfig()
        coreConfig.enableMetalHDR = config.enableMetalHDR
        coreConfig.sharpness = config.sharpness
        coreConfig.peakNits = config.peakNits
        coreConfig.saturationBoost = config.saturationBoost
        coreConfig.gamma = config.gamma
        coreConfig.zeroLatencyScrubbing = config.zeroLatencyScrubbing
        coreEngine?.update(coreConfig)
    }

    /// Attaches the engine's zero-copy presenter to a Metal view.
    public func attachMetalView(_ view: MTKView) {
        coreEngine?.attachMetalView(view)
    }

    /// Detaches the engine from the Metal view.
    public func detachMetalView() {
        coreEngine?.detachMetalView()
    }

    private func startTelemetryPolling() {
        telemetryTimer?.invalidate()
        telemetryTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self, let engine = self.coreEngine else { return }
                let raw = engine.pollTelemetry()
                self.currentTime = raw.currentTime
                self.duration = raw.duration
                self.telemetry = SovereignTelemetry(
                    currentTime: raw.currentTime,
                    duration: raw.duration,
                    fps: raw.fps,
                    frameLatencyMs: raw.frameLatencyMs,
                    cpuPercent: raw.cpuPercent,
                    ramMB: raw.ramMB,
                    droppedFrames: raw.droppedFrames,
                    isLiveStream: raw.isLiveStream
                )
            }
        }
    }

    deinit {
        telemetryTimer?.invalidate()
        coreEngine?.shutdown()
    }
}
