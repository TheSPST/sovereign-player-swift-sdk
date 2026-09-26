//
//  SovereignTelemetry.swift
//  SovereignPlayerSDK
//
//  Copyright (c) 2026 Sovereign Byte Technology. All Rights Reserved.
//

import Foundation

/// Real-time playback and hardware performance statistics snapshot.
public struct SovereignTelemetry: Sendable, Equatable {
    /// Current playback position in seconds.
    public let currentTime: Double

    /// Total duration in seconds (0.0 if live stream).
    public let duration: Double

    /// Actual rendered frames per second (FPS).
    public let fps: Double

    /// Microsecond-precision render frame latency in milliseconds.
    public let frameLatencyMs: Double

    /// Engine CPU overhead percentage (typically < 1.5% on Apple Silicon Metal DMA).
    public let cpuPercent: Double

    /// Resident memory footprint in megabytes (RAM RSS).
    public let ramMB: Double

    /// Total dropped frames since playback initiation (guaranteed 0 on target hardware).
    public let droppedFrames: UInt32

    /// Indicates whether the media source is a live HLS / RTSP / DASH stream.
    public let isLiveStream: Bool

    public init(
        currentTime: Double = 0.0,
        duration: Double = 0.0,
        fps: Double = 0.0,
        frameLatencyMs: Double = 0.0,
        cpuPercent: Double = 0.0,
        ramMB: Double = 0.0,
        droppedFrames: UInt32 = 0,
        isLiveStream: Bool = false
    ) {
        self.currentTime = currentTime
        self.duration = duration
        self.fps = fps
        self.frameLatencyMs = frameLatencyMs
        self.cpuPercent = cpuPercent
        self.ramMB = ramMB
        self.droppedFrames = droppedFrames
        self.isLiveStream = isLiveStream
    }
}
