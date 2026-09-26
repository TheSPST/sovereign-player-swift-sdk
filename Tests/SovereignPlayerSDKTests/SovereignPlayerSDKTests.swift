import XCTest
@testable import SovereignPlayerSDK
import SovereignPlayerCore

final class SovereignPlayerSDKTests: XCTestCase {
    func testConfigInitialization() {
        let defaultConfig = SovereignConfig.default
        XCTAssertFalse(defaultConfig.enableMetalHDR)
        XCTAssertEqual(defaultConfig.sharpness, 0.0)
        XCTAssertTrue(defaultConfig.zeroLatencyScrubbing)

        let turboConfig = SovereignConfig.turboHDR
        XCTAssertTrue(turboConfig.enableMetalHDR)
        XCTAssertEqual(turboConfig.sharpness, 0.45)
        XCTAssertEqual(turboConfig.peakNits, 1000.0)
        XCTAssertEqual(turboConfig.saturationBoost, 1.15)
        XCTAssertTrue(turboConfig.zeroLatencyScrubbing)
    }

    func testTelemetryDefaults() {
        let telemetry = SovereignTelemetry()
        XCTAssertEqual(telemetry.currentTime, 0.0)
        XCTAssertEqual(telemetry.duration, 0.0)
        XCTAssertEqual(telemetry.fps, 0.0)
        XCTAssertEqual(telemetry.droppedFrames, 0)
        XCTAssertFalse(telemetry.isLiveStream)
    }

    @MainActor
    func testPlayerControllerLifecycle() {
        let player = SovereignPlayer(config: .turboHDR)
        XCTAssertNil(player.url)
        XCTAssertFalse(player.isPlaying)
        XCTAssertEqual(player.volume, 1.0)
        XCTAssertEqual(player.playbackRate, 1.0)
    }
}
