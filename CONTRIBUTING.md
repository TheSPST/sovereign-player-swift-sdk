# Contributing to Sovereign Player SDK for Apple Platforms

Thank you for your interest in contributing to **Sovereign Player SDK**! We welcome contributions from Swift, Metal, iOS, and macOS developers worldwide.

---

## 🌟 Open-Source Architecture

This SDK follows a clean **Open-Wrapper / Closed-Core** paradigm:
- **Open-Source (`Sources/SovereignPlayerSDK/`):** 100% MIT Licensed. You have full freedom to build, enhance, and customize the SwiftUI and AppKit/UIKit abstractions, controls, overlays, and integrations.
- **Pre-Compiled Core (`Frameworks/SovereignPlayerCore.xcframework`):** Closed-source proprietary freeware binary delivering direct Metal DMA hardware decoding and real-time HDR compute shaders.

---

## 🛠️ Areas Where You Can Contribute

We are actively seeking contributions in the following areas:

### 1. SwiftUI & UIKit UI Components
- Custom player control overlays (glassmorphic, minimalist, studio, broadcast).
- Picture-in-Picture (PiP) integrations for macOS & iOS.
- Dynamic gesture handlers (pinch-to-zoom, brightness/volume scrub gestures).
- AirPlay & SharePlay integrations.

### 2. Subtitles & Closed Captions
- Parsers and real-time Metal renderers for SRT, WebVTT, and ASS/SSA subtitle tracks.
- Dynamic styling, font scaling, and collision-avoidance positioning.

### 3. Audio & Visualization
- Real-time audio spectrum visualizers (FFT wave, stereo bars) driven by Metal.
- Spatial Audio / Multi-channel surround sound routing enhancements.

### 4. Codecs, Demuxers & Containers
- Demuxers for MKV, WebM, and custom streaming container protocols.
- Pre-buffering heuristics and adaptive streaming quality selectors.

### 5. Documentation, Localizations & Demos
- VisionOS and tvOS sample applications.
- UI localization and multi-language translation.
- Interactive Xcode Playgrounds and developer tutorials.

---

## 🚀 Development Workflow

1. **Fork** the repository on GitHub:
   ```bash
   git clone https://github.com/TheSPST/sovereign-player-swift-sdk.git
   cd sovereign-player-swift-sdk
   ```

2. **Open in Xcode:**
   - Double-click `Package.swift` or drag the folder directly into Xcode.
   - Run the test suite: **Product ➜ Test** (`Cmd + U`).

3. **Create a Feature Branch:**
   ```bash
   git checkout -b feature/awesome-ui-overlay
   ```

4. **Commit Your Changes:**
   Use conventional commit formatting:
   ```bash
   git commit -m "feat(ui): add glassmorphic scrubber control bar"
   ```

5. **Submit a Pull Request:**
   Push your branch and open a PR with screenshots or screen recordings showing your additions.

---

## 💖 Support the Project

If you or your company build great apps using Sovereign Player SDK, consider supporting our ongoing development:
- **Star this repository** on GitHub.
- **Share** your implementations with the community!

*(C) 2026 Sovereign Byte Technology. All Rights Reserved.*
