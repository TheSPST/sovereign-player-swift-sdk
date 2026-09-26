//
//  SovereignPlayerCore.h
//  SovereignPlayerCore
//
//  Copyright (c) 2026 Sovereign Byte Technology. All Rights Reserved.
//  Proprietary & Confidential.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <CoreVideo/CoreVideo.h>

//! Project version number for SovereignPlayerCore.
FOUNDATION_EXPORT double SovereignPlayerCoreVersionNumber;

//! Project version string for SovereignPlayerCore.
FOUNDATION_EXPORT const unsigned char SovereignPlayerCoreVersionString[];

NS_ASSUME_NONNULL_BEGIN

/**
 * Telemetry snapshot emitted by the Sovereign Metal Turbo engine.
 */
@interface SovereignCoreTelemetry : NSObject

@property (nonatomic, readonly) double currentTime;
@property (nonatomic, readonly) double duration;
@property (nonatomic, readonly) double fps;
@property (nonatomic, readonly) double frameLatencyMs;
@property (nonatomic, readonly) double cpuPercent;
@property (nonatomic, readonly) double ramMB;
@property (nonatomic, readonly) uint32_t droppedFrames;
@property (nonatomic, readonly) BOOL isLiveStream;

- (instancetype)initWithCurrentTime:(double)currentTime
                           duration:(double)duration
                                fps:(double)fps
                     frameLatencyMs:(double)frameLatencyMs
                         cpuPercent:(double)cpuPercent
                              ramMB:(double)ramMB
                      droppedFrames:(uint32_t)droppedFrames
                       isLiveStream:(BOOL)isLiveStream;

@end

/**
 * Configuration parameters for the Sovereign Metal Turbo real-time render pipeline.
 */
@interface SovereignCoreConfig : NSObject

@property (nonatomic, assign) BOOL enableMetalHDR;
@property (nonatomic, assign) float sharpness;
@property (nonatomic, assign) float peakNits;
@property (nonatomic, assign) float saturationBoost;
@property (nonatomic, assign) float gamma;
@property (nonatomic, assign) BOOL zeroLatencyScrubbing;

+ (instancetype)defaultConfiguration;
+ (instancetype)turboHDRConfiguration;

@end

/**
 * Core engine interface managing zero-copy Metal presentation,
 * compute-shader HDR tonemapping, and hardware buffer caching.
 */
@interface SovereignCoreEngine : NSObject

@property (nonatomic, readonly, nullable) NSURL *mediaURL;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) float playbackRate;
@property (nonatomic, readonly) double duration;
@property (nonatomic, readonly) double currentTime;

- (instancetype)initWithURL:(NSURL *)url config:(SovereignCoreConfig *)config;

- (void)attachMetalView:(MTKView *)metalView;
- (void)detachMetalView;

- (void)play;
- (void)pause;
- (void)seekToTime:(double)seconds completion:(nullable void (^)(BOOL finished))completion;
- (void)updateConfig:(SovereignCoreConfig *)config;
- (SovereignCoreTelemetry *)pollTelemetry;
- (void)shutdown;

@end

NS_ASSUME_NONNULL_END
