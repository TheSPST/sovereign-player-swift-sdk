//
//  main.swift
//  SovereignPlayerDemo
//
//  Copyright (c) 2026 Sovereign Byte Technology. All Rights Reserved.
//

import SwiftUI
import SovereignPlayerSDK

@main
struct SovereignPlayerDemoApp: App {
    var body: some Scene {
        WindowGroup {
            DemoContentView()
                .frame(minWidth: 800, minHeight: 500)
        }
    }
}

struct DemoContentView: View {
    @StateObject private var player = SovereignPlayer(config: .turboHDR)
    @State private var videoPath: String = ""
    @State private var isHDRActive: Bool = true
    @State private var sharpnessValue: Float = 0.45

    var body: some View {
        VStack(spacing: 0) {
            // Top Toolbar
            HStack {
                Text("⚡ Sovereign Player SDK Demo")
                    .font(.headline)

                Spacer()

                Button("Open Video...") {
                    openFilePanel()
                }

                Toggle("10-Bit Metal HDR", isOn: $isHDRActive)
                    .onChange(of: isHDRActive) { newValue in
                        var config = player.telemetry.isLiveStream ? SovereignConfig.default : SovereignConfig.turboHDR
                        config.enableMetalHDR = newValue
                        config.sharpness = sharpnessValue
                        player.updateConfig(config)
                    }

                HStack {
                    Text("Sharpness:")
                    Slider(value: $sharpnessValue, in: 0.0...1.0)
                        .frame(width: 100)
                        .onChange(of: sharpnessValue) { newValue in
                            var config = SovereignConfig.turboHDR
                            config.enableMetalHDR = isHDRActive
                            config.sharpness = newValue
                            player.updateConfig(config)
                        }
                }
            }
            .padding(10)
            .background(Color(NSColor.windowBackgroundColor))

            // Main Video Surface
            SovereignVideoView(player: player, showsTelemetryHUD: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Bottom Controls
            HStack(spacing: 16) {
                Button(action: { player.togglePlayPause() }) {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                }
                .buttonStyle(.plain)

                Text(formatTime(player.currentTime))
                    .font(.caption.monospacedDigit())

                Slider(value: Binding(
                    get: { player.currentTime },
                    set: { player.seek(to: $0) }
                ), in: 0...max(1.0, player.duration))

                Text(formatTime(player.duration))
                    .font(.caption.monospacedDigit())

                Image(systemName: "speaker.wave.2.fill")
                Slider(value: $player.volume, in: 0...1)
                    .frame(width: 80)
            }
            .padding(12)
            .background(Color(NSColor.controlBackgroundColor))
        }
    }

    private func openFilePanel() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [.movie, .video, .quickTimeMovie, .mpeg4Movie]
        if panel.runModal() == .OK, let url = panel.url {
            player.load(url: url, config: isHDRActive ? .turboHDR : .default)
            player.play()
        }
    }

    private func formatTime(_ seconds: Double) -> String {
        guard !seconds.isNaN && !seconds.isInfinite && seconds >= 0 else { return "00:00" }
        let total = Int(seconds)
        let s = total % 60
        let m = (total / 60) % 60
        let h = total / 3600
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        }
        return String(format: "%02d:%02d", m, s)
    }
}
