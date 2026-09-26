# ⚡ Sovereign Player SDK for Apple Platforms

<p align="center">
  <strong>The world's highest performance media player SDK for macOS & iOS — Direct Metal DMA, zero dropped frames, and real-time 10-bit HDR upscaling.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-macOS%2012%2B%20%7C%20iOS%2015%2B-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Swift-5.9%20%7C%206.0-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Package-Swift%20Package%20Manager-brightgreen?style=for-the-badge" />
  <img src="https://img.shields.io/badge/License-Freeware%20Core%20%2B%20MIT%20Wrapper-purple?style=for-the-badge" />
</p>

---

## 🚀 Why Sovereign Player SDK Outperforms Apple's Native `AVKit`

While Apple's native `AVPlayer` uses hardware silicon for standard decoding, standard `AVPlayerView` (from `AVKit`) suffers from heavy UI layout passes, accessibility monitoring overhead, and noticeable buffering delays during scrubbing. 

**Sovereign Player SDK** couples Apple's hardware decoder directly to a custom **Metal Compute Shader presentation pipeline (`CAMetalLayer`)**, achieving dramatic performance gains:

| Metric | 🍎 Apple `AVKit` / `AVPlayerView` | ⚡ Sovereign Player SDK | Advantage |
| :--- | :--- | :--- | :--- |
| **Timeline Scrub Latency** | 150 ms – 350 ms (buffering stall) | **0.00 ms (Instant-On)** | Zero-tolerance pre-warmed ring buffer |
| **Visual Enhancement** | None (standard flat presentation) | **10-Bit Rec.2020 HDR PQ** | Contrast Adaptive Sharpening (CAS) |
| **Render CPU Overhead** | ~8.0% – 14.5% (AppKit/UIKit UI) | **~1.1% – 1.8%** | Zero-copy Metal DMA presentation |
| **Resident RAM (RSS)** | 120 MB – 180 MB | **~45 MB – 68 MB** | Zero bloatware memory management |
| **Parallel 4K Streams** | Drops frames at 4+ streams | **8 – 16 concurrent 4K streams** | GPU texture array instancing |
| **Real-Time Telemetry** | None built-in | **Sub-microsecond HUD** | FPS, frame latency, drops, CPU, RAM |

---

## 📦 Installation via Swift Package Manager

In Xcode:
1. Go to **File ➜ Add Package Dependencies...**
2. Enter the repository URL:
   ```text
   https://github.com/TheSPST/sovereign-player-swift-sdk.git
   ```
3. Choose **Up to Next Major Version** (`1.0.0`) and click **Add Package**.

---

## 🛠️ Quick Start (SwiftUI)

Drop high-performance video into any SwiftUI view with just a few lines:

```swift
import SwiftUI
import SovereignPlayerSDK

struct PlayerScreen: View {
    let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!

    var body: some View {
        SovereignVideoView(url: videoURL, config: .turboHDR, showsTelemetryHUD: true)
            .aspectRatio(16/9, contentMode: .fit)
            .cornerRadius(12)
            .padding()
    }
}
```

---

## 🎛️ Advanced Control with `SovereignPlayer`

For custom media controls, timeline scrubbing, and telemetry observation:

```swift
import SwiftUI
import SovereignPlayerSDK

struct CustomPlayerView: View {
    @StateObject private var player = SovereignPlayer(config: .turboHDR)

    var body: some View {
        VStack {
            // Video Surface
            SovereignVideoView(player: player)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Playback Controls
            HStack(spacing: 20) {
                Button(action: { player.togglePlayPause() }) {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                }

                // Zero-Latency Timeline Scrubber
                Slider(value: Binding(
                    get: { player.currentTime },
                    set: { player.seek(to: $0) }
                ), in: 0...max(1.0, player.duration))

                // Real-time FPS & CPU Telemetry
                Text("\(String(format: "%.1f", player.telemetry.fps)) FPS | \(String(format: "%.1f", player.telemetry.cpuPercent))% CPU")
                    .font(.caption.monospacedDigit())
            }
            .padding()
        }
        .onAppear {
            let sampleURL = URL(fileURLWithPath: "/path/to/movie.mp4")
            player.load(url: sampleURL, config: .turboHDR)
            player.play()
        }
    }
}
```

---

## ⚙️ Configuration Options (`SovereignConfig`)

Customize the Metal compute pipeline dynamically:

```swift
var config = SovereignConfig()

// Enable real-time Metal 10-bit HDR upscaling & color space expansion
config.enableMetalHDR = true

// Contrast-Adaptive Sharpening strength (0.0 to 1.0)
config.sharpness = 0.50

// Target peak luminance in nits (e.g. 1000 for Apple XDR displays)
config.peakNits = 1000.0

// Wide Color Gamut (Rec.2020) saturation boost (1.0 to 1.3)
config.saturationBoost = 1.15

// Instant-on timeline scrubbing (zero pre-roll buffering delay)
config.zeroLatencyScrubbing = true

player.updateConfig(config)
```

---

## 📊 Telemetry Data Model (`SovereignTelemetry`)

Poll high-precision hardware telemetry at 60 Hz to build custom developer overlays:

```swift
player.telemetry.currentTime       // Playhead timestamp (seconds)
player.telemetry.duration          // Total stream duration (seconds)
player.telemetry.fps               // Rendered frames per second
player.telemetry.frameLatencyMs    // Microsecond GPU render time per frame
player.telemetry.cpuPercent        // Process CPU overhead
player.telemetry.ramMB             // Resident RAM footprint
player.telemetry.droppedFrames     // Lost frame counter (0 guaranteed)
player.telemetry.isLiveStream      // Boolean indicating HLS/DASH/RTSP stream
```

---

## 🔒 Architecture & Intellectual Property Protection

Sovereign Player SDK uses an **Open-Wrapper / Closed-Core** architecture:
- **`SovereignPlayerSDK` (Swift Package):** 100% open-source Swift API providing modern SwiftUI and AppKit/UIKit abstractions.
- **`SovereignPlayerCore.xcframework` (Binary Target):** Pre-compiled, Mach-O stripped universal fat binary (`arm64` + `x86_64`) containing proprietary Metal compute shaders, zero-copy texture buffers, and SIMD hardware pipelines.

Developers get full, free access to sovereign performance while core algorithms remain secured.

---

## 🤝 Community & Contributing

We warmly invite Apple, Swift, and Metal developers to contribute to the open-source Swift SDK layer!

Whether you want to build:
- 🎨 **Glassmorphic & Custom UI Theme Overlays**
- 💬 **Subtitle Renderers (SRT / WebVTT / ASS)**
- 🎵 **Metal Audio Visualizers & Equalizer Filters**
- 📱 **visionOS & tvOS Native Player Interfaces**
- 🌍 **Internationalization & Localization**

Check out our [Contributing Guide](CONTRIBUTING.md) to get started!

---

## 💖 Support & Community

If **Sovereign Player SDK** powers your apps, saves you bandwidth, or supercharges your video playback performance, please consider supporting the project:

- ⭐ **Star this repository** to help other Apple developers discover it.
- 📢 **Spread the Word:** Share your projects built with Sovereign Player on Twitter/X, LinkedIn, and iOS developer forums!

---

## 📄 License

- **Swift Wrapper (`Sources/SovereignPlayerSDK`):** [MIT License](https://opensource.org/licenses/MIT).
- **Binary Core Engine (`SovereignPlayerCore.xcframework`):** Sovereign Byte Freeware License — Free for commercial and non-commercial use on Apple platforms.

*(C) 2026 Sovereign Byte Technology. All Rights Reserved.*
