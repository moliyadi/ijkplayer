/*
 * Copyright (C) 2013-2015 Zhang Rui <bbcallen@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "IJKMoviePlayerViewController.h"
#import "IJKMediaControl.h"
#import "IJKCommon.h"
#import "IJKMediaPlayer/IJKMediaPlayer.h"
#import "IJKDemoHistory.h"

@implementation IJKVideoViewController

- (void)dealloc
{
}

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void (^)())completion {
    IJKDemoHistoryItem *historyItem = [[IJKDemoHistoryItem alloc] init];
    
    historyItem.title = title;
    historyItem.url = url;
    [[IJKDemoHistory instance] add:historyItem];
    
    [viewController presentViewController:[[IJKVideoViewController alloc] initWithURL:url] animated:YES completion:completion];
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [self initWithNibName:@"IJKMoviePlayerViewController" bundle:nil];
    if (self) {
        self.url = url;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];

    //NSURL *theMovieURL = [NSURL URLWithString:@"http://wshdl.acgvideo.com/live/live_5099_3038_d0ffe541.flv"];
    //NSURL *theMovieURL = [NSURL URLWithString:@"https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"];
    //NSURL *theMovieURL = [NSURL URLWithString:@"http://192.166.62.108/guangDongPlayBad.ts"];
    //NSURL *theMovieURL = [NSURL URLWithString:@"http://192.166.62.108/jingZhou.mp4"];
    //NSURL *theMovieURL = [NSURL URLWithString:@"http://192.166.62.108/vlc_output2.mp4"]; //网关
    //NSURL *theMovieURL = [NSURL URLWithString:@"http://192.168.88.2/dvb/live_514000_1_5_1_33_27_32_4.mp4"]; //网关盒子内地址
    //NSURL *theMovieURL = [NSURL URLWithString:@"http://192.166.62.60:1935/vod/_definst_/mp4:GCABLE_20150310091030344194126/20150310091030344194126.mp4/playlist.m3u8"];
    //NSURL *theMovieURL = [NSURL URLWithString:@"http://cdnbakmi.kaltura.com/p/243342/sp/24334200/playManifest/entryId/0_uka1msg4/flavorIds/1_vqhfu6uy,1_80sohj7p/format/applehttp/protocol/http/a.m3u8"];
    NSURL *theMovieURL = [NSURL URLWithString:@"http://114.80.182.141/sohu/s26h23eab6/v1/TmX3TmPAoKIsD40veVfshMNtDGvIvBxXRFwoSJKqKBgXpxWsm3AXp.mp4?k=n8zykY&p=jWlvzSwAqmkCqSY&r=TUqvtvGDXixnyLbUZDWSqTPGRDb4WGoioMycY&q=OpCChW7IWBodRDbsfhASotE7ZD6sWDXOZYXOfYAHfhvXvmbcWJWXfGA4RYeSqD2tfOoUZDS&cip=115.28.209.129"];

    //NSURL *theMovieURL = [NSURL URLWithString:@"http://vhotwsh.video.qq.com/flv/32/146/r0015d10iwu.p203.1.mp4?vkey=68023055CEC9CC9E1D988B0E71E4B58C38B0374F1CB9805F4A1901D8E87B42137DD9680CF88D3685C3A59F030BAE55AA2E7238551DCB6BFF&fmt=sd&type=mp4"];

    [IJKFFMoviePlayerController setLogReport:YES];
#if 0 //mabiao
    IJKFFOptions *options = [[IJKFFOptions alloc] init];
    options.skipLoopFilter  = IJK_AVDISCARD_ALL;
    options.skipFrame       = IJK_AVDISCARD_NONREF;
//
    options.frameBufferCount        = 3;
    options.maxFps                  = 30;
    options.frameDrop               = 0;
    options.pauseInBackground       = YES;
    
    options.timeout                 = 30 * 1000 * 1000; // 30 seconds
    options.userAgent               = @"";
    options.videotoolboxEnabled     = YES;
    options.frameMaxWidth           = 960;
    options.autoReconnect           = YES;
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:theMovieURL withOptions:[IJKFFOptions optionsByDefault]];
    //self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:theMovieURL withOptions:options];
#else
    //self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:theMovieURL withOptions:nil];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
#endif

    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = MPMovieScalingModeAspectFit;

    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    [self.view addSubview:self.mediaControl];

    self.mediaControl.delegatePlayer = self.player;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self installMovieNotificationObservers];

    [self.player prepareToPlay];
    [self.player play];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.player shutdown];
    [self removeMovieNotificationObservers];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction

- (IBAction)onClickMediaControl:(id)sender
{
    [self.mediaControl showAndFade];
}

- (IBAction)onClickOverlay:(id)sender
{
    [self.mediaControl hide];
}

- (IBAction)onClickBack:(id)sender
{
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onClickPlay:(id)sender
{
    [self.player play];
    [self.mediaControl refreshMediaControl];
}

- (IBAction)onClickPause:(id)sender
{
    [self.player pause];
    [self.mediaControl refreshMediaControl];
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started

    MPMovieLoadState loadState = _player.loadState;

    if ((loadState & MPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: MPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & MPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: MPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];

    switch (reason)
    {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: MPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;

        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: MPMovieFinishReasonUserExited: %d\n", reason);
            break;

        case MPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: MPMovieFinishReasonPlaybackError: %d\n", reason);
            break;

        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward

    switch (_player.playbackState)
    {
        case MPMoviePlaybackStateStopped: {
            NSLog(@"moviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case MPMoviePlaybackStatePlaying: {
            NSLog(@"moviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case MPMoviePlaybackStatePaused: {
            NSLog(@"moviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case MPMoviePlaybackStateInterrupted: {
            NSLog(@"moviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case MPMoviePlaybackStateSeekingForward:
        case MPMoviePlaybackStateSeekingBackward: {
            NSLog(@"moviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"moviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMoviePlayerLoadStateDidChangeNotification
                                               object:_player];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMoviePlayerPlaybackDidFinishNotification
                                               object:_player];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

@end
