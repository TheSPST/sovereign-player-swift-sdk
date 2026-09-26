//
//  SovereignVideoView.swift
//  SovereignPlayerSDK
//
//  Copyright (c) 2026 Sovereign Byte Technology. All Rights Reserved.
//

import SwiftUI
import MetalKit
import SovereignPlayerCore

#if os(macOS)
import AppKit

/// AppKit NSViewRepresentable wrapping MTKView with Sovereign Direct Metal DMA pipeline.
public struct SovereignMetalViewRepresentable: NSViewRepresentable {
    public let player: SovereignPlayer

    public init(player: SovereignPlayer) {
        self.player = player
    }

    public func makeNSView(context: Context) -> MTKView {
        let metalView = MTKView(frame: .zero)
        player.attachMetalView(metalView)
        return metalView
    }

    public func updateNSView(_ nsView: MTKView, context: Context) {}

    public static func dismantleNSView(_ nsView: MTKView, coordinator: ()) {
        nsView.delegate = nil
    }
}

#elseif os(iOS) || os(tvOS)
import UIKit

/// UIKit UIViewRepresentable wrapping MTKView with Sovereign Direct Metal DMA pipeline.
public struct SovereignMetalViewRepresentable: UIViewRepresentable {
    public let player: SovereignPlayer

    public init(player: SovereignPlayer) {
        self.player = player
    }

    public func makeUIView(context: Context) -> MTKView {
        let metalView = MTKView(frame: .zero)
        player.attachMetalView(metalView)
        return metalView
    }

    public func updateUIView(_ uiView: MTKView, context: Context) {}

    public static func dismantleUIView(_ uiView: MTKView, coordinator: ()) {
        uiView.delegate = nil
    }
}
#endif

/// Declarative SwiftUI View for high-performance Sovereign video rendering.
public struct SovereignVideoView: View {
    @ObservedObject public var player: SovereignPlayer
    public var showsTelemetryHUD: Bool = false

    public init(player: SovereignPlayer, showsTelemetryHUD: Bool = false) {
        self.player = player
        self.showsTelemetryHUD = showsTelemetryHUD
    }

    public init(url: URL, config: SovereignConfig = .turboHDR, showsTelemetryHUD: Bool = false) {
        self.player = SovereignPlayer(url: url, config: config)
        self.showsTelemetryHUD = showsTelemetryHUD
    }

    public var body: some View {
        ZStack {
            Color.black

            SovereignMetalViewRepresentable(player: player)

            if showsTelemetryHUD {
                telemetryOverlay
            }
        }
    }

    private var telemetryOverlay: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("⚡ SOVEREIGN METAL TURBO")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                    Text("FPS: \(String(format: "%.1f", player.telemetry.fps)) | Latency: \(String(format: "%.2f", player.telemetry.frameLatencyMs))ms")
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)
                    Text("CPU: \(String(format: "%.1f", player.telemetry.cpuPercent))% | RAM: \(String(format: "%.1f", player.telemetry.ramMB))MB | Drops: \(player.telemetry.droppedFrames)")
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(8)
                .background(Color.black.opacity(0.75))
                .cornerRadius(6)

                Spacer()
            }
            .padding(12)

            Spacer()
        }
    }
}
