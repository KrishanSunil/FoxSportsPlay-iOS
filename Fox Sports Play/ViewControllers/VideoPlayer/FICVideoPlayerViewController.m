//
//  FICVideoPlayerViewController.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 10/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICVideoPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FICAppDelegate.h"
#include "IMAAdsManager.h"


#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface FICVideoPlayerViewController ()<IMAAdsLoaderDelegate,IMAAdsManagerDelegate,IMAWebOpenerDelegate>{
    
    MPMoviePlayerController *videoPlayer;
}

@property(nonatomic,strong) MPMoviePlayerController *videoPlayer;
@property(nonatomic,strong) IMAAdDisplayContainer *adDisplayContainer;
@property(nonatomic, strong) IMAAdsManager *adsManager;
@property(nonatomic,assign) BOOL isPaused;
- (IBAction)doneButtonclicked:(id)sender;

@end

@implementation FICVideoPlayerViewController

@synthesize videoPlayer;
@synthesize urlToPlay=_urlToPlay;
@synthesize adDisplayContainer = _adDisplayContainer;
@synthesize adsLoader=_adsLoader;
@synthesize categoryName=_categoryName;
@synthesize videoTitle = _videoTitle;


#pragma mark  - Pre Roll Add Creation

- (void)createAdsLoader {
    self.adsLoader = [[IMAAdsLoader alloc] initWithSettings:[self createIMASettings]];
    self.adsLoader.delegate = self;
}

- (IMASettings *) createIMASettings {
    IMASettings *settings = [[IMASettings alloc] init];
    settings.ppid = @"IMA_PPID_0";
    settings.language = @"en";
    return settings;
}

#pragma mark - IMAAdsLoderDelegate 

- (void)adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
    // Loading was successful.
    DLog(@"Ad loading successful!");
    
    self.adsManager = adsLoadedData.adsManager;
    
    
    IMAAdsRenderingSettings *settings = [[IMAAdsRenderingSettings alloc] init];
    settings.webOpenerPresentingController = self;
    settings.webOpenerDelegate = self;
    [self.adsManager initializeWithContentPlayhead:nil adsRenderingSettings:settings];


//    [self.adsManager initializeWithContentPlayhead:nil adsRenderingSettings:nil];
    self.adsManager.delegate = self;
    
    



}

- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    // Loading failed, log it.
    [self unloadAdsManager];
    [self startVideo];
    DLog(@"Ad loading error: %@", adErrorData.adError.message);
}

#pragma mark - IMAAdsManagerDelegate

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    [self.adsManager pause];
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    [self.adsManager resume];
 
}

// Process ad events.
- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
  
    switch (event.type) {
        case kIMAAdEvent_LOADED:
            [adsManager start];
            break;
        case kIMAAdEvent_ALL_ADS_COMPLETED:{
            [self unloadAdsManager];
            [self startVideo];
        }
            break;
        case kIMAAdEvent_STARTED:

            break;
      
        case kIMAAdEvent_PAUSE:
//            if (self.isPaused) {
//                [adsManager resume];
//                break;
//            }
            [adsManager pause];
            self.isPaused = YES;
            break;
        case kIMAAdEvent_RESUME:
            [adsManager start];
            break;
        case kIMAAdEvent_COMPLETE:
            
            break;
        default:
            // no-op
            break;
    }
    
    
}

- (void)unloadAdsManager {
   
    if (self.adsManager != nil) {
        [self.adsManager destroy];
        self.adsManager.delegate = nil;
        self.adsManager = nil;
        self.adDisplayContainer = nil;
        
        // added by krishan
        self.adsLoader.delegate = nil;
        self.adsLoader = nil;

    }
}

// Process ad playing errors.
- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdError:(IMAAdError *)error {
    [self unloadAdsManager];
    [self startVideo];
    DLog(@"Error during ad playback: %@", error);
}

// Optional: receive updates about individual ad progress.
- (void)adDidProgressToTime:(NSTimeInterval)mediaTime totalTime:(NSTimeInterval)totalTime {
   
}

-(NSString*)getAdTag{
    
    NSString *doubleClickServerString =@"http://pubads.g.doubleclick.net/gampad/ads?sz=638x359&iu=/21535281/foxplayasia.ios.%@_preroll_1_638x359&ciu_szs&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=http://foxplayasia.com/&correlator={date:60:true}";
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    NSString *resultString = [[self.categoryName componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
   
    return [doubleClickServerString stringByReplacingOccurrencesOfString:@"%@" withString:resultString];
}

- (void)requestAds {
    NSString *adTag = [self getAdTag];
    
    //@"http://pubads.g.doubleclick.net/gampad/ads?sz=512x288&iu=/21535281/racematelive.ios.home_preroll_1_512x288&ciu_szs&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=www.racematelive.com&correlator={date:60:true}"
    
    
    self.adDisplayContainer = [[IMAAdDisplayContainer alloc]
                               initWithAdContainer:self.view companionSlots:nil];
    IMAAdsRequest *request =
    [[IMAAdsRequest alloc] initWithAdTagUrl:adTag
                         adDisplayContainer:self.adDisplayContainer
                                userContext:nil];
    [self.adsLoader requestAdsWithRequest:request];
    
    request = nil;
}

- (void)startAds {
    [self.adsManager start];
    

  
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    DLog(@"did become active notification");
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    NSLog(@"did enter foreground notification");
    if (self.isPaused) {
        [self.adsManager resume];
        self.isPaused = NO;
    }

}



#pragma mark - Start Video
-(void)startVideo{
    
    NSURL *streamURL = [NSURL URLWithString:self.urlToPlay];
    
    
    videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:streamURL];
    
    
    if (self.view.frame.size.width>self.view.frame.size.height) {
        [self.videoPlayer.view setFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }else{
        [self.videoPlayer.view setFrame: CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    }
    
    
    
    [self.activityIndicatior startAnimating];
    
    self.videoPlayer.controlStyle = MPMovieControlStyleFullscreen;
    [self.videoPlayer setFullscreen:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreenNotification:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    [self.view addSubview: self.videoPlayer.view];
    self.videoPlayer.scalingMode = MPMovieScalingModeAspectFit;
    [self.videoPlayer prepareToPlay];
    
    [self.videoPlayer play];
    self.videoPlayer.view.hidden = YES;

}

#pragma mark - View Controller default methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isPaused = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createAdsLoader];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight animated:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [self transfromViewToLandscape];
    }
    

    [self requestAds];
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = [NSString stringWithFormat:@"VideoPlayer Screen / %@ / %@",self.categoryName,self.videoTitle];
    

    
  
}

-(NSString*)getPercentage:(NSTimeInterval)playedTime totalTime:(NSTimeInterval)totalTime {
    
    float percentage = (playedTime/totalTime)*100;
    
    if (percentage>=75) {
        return @"75-100";
    }
    
    if (percentage<75&&percentage>=50) {
        return @"50-75";
    }
    
    if (percentage<50&&percentage>=25) {
        return @"25-50";
    }
    
    
    return @"00-25";
    
    
}

- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
//    if (self.videoPlayer.playbackState == MPMoviePlaybackStatePlaying)
//    {
//        NSLog(@"Play back STarted");
//    }
//    if (self.videoPlayer.playbackState == MPMoviePlaybackStateStopped)
//    {
//        NSLog(@"Play back STarted");
//    }if (self.videoPlayer.playbackState == MPMoviePlaybackStatePaused)
//    {
//         NSLog(@"Play back STarted");
//    }if (self.videoPlayer.playbackState == MPMoviePlaybackStateInterrupted)
//    {
//         NSLog(@"Play back STarted");
//    }if (self.videoPlayer.playbackState == MPMoviePlaybackStateSeekingForward)
//    {
//         NSLog(@"Play back STarted");
//    }if (self.videoPlayer.playbackState == MPMoviePlaybackStateSeekingBackward)
//    {
//         NSLog(@"Play back STarted");
//    }
    
    if (self.videoPlayer.playbackState == MPMoviePlaybackStateStopped)
    {
        // Setup the Google Analytics
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Video Finished Playing"     // Event category (required)
                                                              action:self.categoryName // Event action (required)
                                                               label:[NSString stringWithFormat:@"%@/75-100",self.videoTitle ]        // Event label
                                                               value:[NSNumber numberWithInt:100]] build]];
        
        return;
    }
    [self.activityIndicatior stopAnimating];
    self.videoPlayer.view.hidden = NO;
    
//    [self clearAdds];
    
}

-(void)moviePlayerWillExitFullscreenNotification:(NSNotification*)notification{
    
    NSNumber *reason = [notification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if ([reason intValue]==MPMovieFinishReasonPlaybackError) {
        
        [self.videoPlayer stop];
        self.videoPlayer = nil;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    
        return;
    }
    
    if ([reason intValue]==MPMovieFinishReasonUserExited) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
         NSTimeInterval playableDuration = [self.videoPlayer playableDuration];
        NSTimeInterval currentPlayedTime = [self.videoPlayer currentPlaybackTime];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Video Stopped Playing"     // Event category (required)
                                                              action:self.categoryName // Event action (required)
                                                               label:[NSString stringWithFormat:@"%@/%@",self.videoTitle,[self getPercentage:currentPlayedTime totalTime:playableDuration] ]         // Event label
                                                               value:[NSNumber numberWithInt:(currentPlayedTime * 100)/playableDuration]] build]];

        
        [self.videoPlayer stop];
        self.videoPlayer = nil;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
 
}

-(void)transfromViewToLandscape{
    
    NSInteger rotationDirecton;
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice]orientation];
    
    if (currentOrientation==UIDeviceOrientationLandscapeLeft) {
        rotationDirecton = 1;
    }else{
        rotationDirecton = -1;
    }
    
    CGAffineTransform transform = [self.view transform];
    transform = CGAffineTransformRotate(transform, DEGREES_RADIANS(rotationDirecton*90));
    [self.view setTransform:transform];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark IMABrowser Delegate implementation
- (void)browserDidOpen {
    DLog(@"Browser Opened");
}
- (void)browserDidClose {
    DLog(@"Browser Closed");
}

- (void)willOpenExternalBrowser {
    DLog(@"External Browser will Open");
}
- (void)willOpenInAppBrowser {
    DLog(@"Internal Browser Will Open");
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight animated:NO];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didOpenInAppBrowser {
   DLog(@"In App Browser Opened");
}
- (void)willCloseInAppBrowser {
    DLog(@"Will Close In App Browser");
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight animated:NO];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didCloseInAppBrowser {
    DLog(@"IN App Browser Closed");
  
}



- (IBAction)doneButtonclicked:(id)sender {
    
    [self.videoPlayer stop];
    self.videoPlayer = nil;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    return;

}
@end
