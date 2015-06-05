//
//  IJKFFOptions.m
//  IJKMediaPlayer
//
//  Created by ZhangRui on 13-10-17.
//  Copyright (c) 2013年 bilibili. All rights reserved.
//

#import "IJKFFOptions.h"
#include "ijkplayer/ios/ijkplayer_ios.h"

@implementation IJKFFOptions

+ (IJKFFOptions *)optionsByDefault
{
    IJKFFOptions *options = [[IJKFFOptions alloc] init];

    options.skipLoopFilter  = IJK_AVDISCARD_ALL;
    options.skipFrame       = IJK_AVDISCARD_NONREF;

    options.frameBufferCount        = 3;
    options.maxFps                  = 30;
    options.frameDrop               = 0;
    options.pauseInBackground       = YES;

    options.timeout                 = 30 * 1000 * 1000; // 30 seconds
    options.userAgent               = @"";
    options.videotoolboxEnabled     = YES;
    options.frameMaxWidth           = 960;
    options.autoReconnect           = YES;


    return options;
}

- (void)applyTo:(IjkMediaPlayer *)mediaPlayer
{
    [self logOptions];

    ijkmp_set_option_int(mediaPlayer, IJKMP_OPT_CATEGORY_CODEC, "skip_loop_filter", _skipLoopFilter);
    ijkmp_set_option_int(mediaPlayer, IJKMP_OPT_CATEGORY_CODEC, "skip_frame",       _skipFrame);

    ijkmp_set_option_int(mediaPlayer, IJKMP_OPT_CATEGORY_PLAYER, "max-fps",             _maxFps);
    ijkmp_set_option_int(mediaPlayer, IJKMP_OPT_CATEGORY_PLAYER, "framedrop",           _frameDrop);
    ijkmp_set_option_int(mediaPlayer, IJKMP_OPT_CATEGORY_PLAYER, "video-pictq-size",    _frameBufferCount);
    ijkmp_set_option_int(mediaPlayer, IJKMP_OPT_CATEGORY_PLAYER, "max-buffer-size",     123);
    ijkmp_ios_set_videotoolbox_enabled(mediaPlayer, _videotoolboxEnabled);
    ijkmp_ios_set_frame_max_width(mediaPlayer, _frameMaxWidth);

    if (self.autoReconnect == NO) {
        ijkmp_set_option_int(mediaPlayer, IJKMP_OPT_CATEGORY_FORMAT, "reconnect", 0);
    } else {
        ijkmp_set_option_int(mediaPlayer, IJKMP_OPT_CATEGORY_FORMAT, "reconnect", 1);
    }

    if (self.timeout > 0) {
        ijkmp_set_option_int(mediaPlayer, IJKMP_OPT_CATEGORY_FORMAT, "timeout", self.timeout);
    }

    if ([self.userAgent isEqualToString:@""] == NO) {
        ijkmp_set_option(mediaPlayer, IJKMP_OPT_CATEGORY_FORMAT, "user-agent", [self.userAgent UTF8String]);
    }
}

/*
 Added by mabiao
 */
- (void)applyToForWaitShot:(IjkMediaPlayer *)mediaPlayer
{
//    [self logOptions];
//    
//    [self setCodecOption:@"skip_loop_filter"
//               withInt64:self.skipLoopFilter
//                      to:mediaPlayer];
//    [self setCodecOption:@"skip_frame"
//               withInt64:self.skipFrame
//                      to:mediaPlayer];
//    
//    ijkmp_set_picture_queue_capicity(mediaPlayer, _frameBufferCount);
//    ijkmp_set_max_fps(mediaPlayer, _maxFps);
//    ijkmp_set_framedrop(mediaPlayer, _frameDrop);
    
//    [self setFormatOption:@"analyzeduration" withString:@"2000000" to:mediaPlayer];
//    [self setFormatOption:@"fflags" withString:@"nobuffer" to:mediaPlayer];
//    [self setFormatOption:@"probsize" withString:@"4096" to:mediaPlayer];
}

- (void)logOptions
{
    NSMutableString *echo = [[NSMutableString alloc] init];
    [echo appendString:@"========================================\n"];
    [echo appendString:@"= FFmpeg options:\n"];
    [echo appendFormat:@"= skip_loop_filter: %@\n",   [IJKFFOptions getDiscardString:self.skipLoopFilter]];
    [echo appendFormat:@"= skipFrame:        %@\n",   [IJKFFOptions getDiscardString:self.skipFrame]];
    [echo appendFormat:@"= frameBufferCount: %d\n",   self.frameBufferCount];
    [echo appendFormat:@"= maxFps:           %d\n",   self.maxFps];
    [echo appendFormat:@"= timeout:          %lld\n", self.timeout];
    [echo appendString:@"========================================\n"];
    NSLog(@"%@", echo);
}

+ (NSString *)getDiscardString:(IJKAVDiscard)discard
{
    switch (discard) {
        case IJK_AVDISCARD_NONE:
            return @"avdiscard none";
        case IJK_AVDISCARD_DEFAULT:
            return @"avdiscard default";
        case IJK_AVDISCARD_NONREF:
            return @"avdiscard nonref";
        case IJK_AVDISCARD_BIDIR:
            return @"avdicard bidir;";
        case IJK_AVDISCARD_NONKEY:
            return @"avdicard nonkey";
        case IJK_AVDISCARD_ALL:
            return @"avdicard all;";
        default:
            return @"avdiscard unknown";
    }
}

@end
