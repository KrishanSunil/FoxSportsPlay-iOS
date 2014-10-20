//
//  FICParentViewController.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 22/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICParentViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "FICCommonUtilities.h"
#import "FICMpx.h"
#import "FICLanguagesDataAccess.h"
#import "Languages.h"
#import "SubLanguages.h"
#import "FICBackgroundProcess.h"
#import "FICEntriesDataAccess.h"
#import "FICHomeViewController.h"
#import "FICSideMenuViewController.h"
#import "SWRevealViewController.h"
#import "FICAppDelegate.h"
#import "FICVideoPlayerViewController.h"
#import "TFHpple.h"
#import "TFHppleElement.h"




@interface FICParentViewController (){
    
}
@property(retain,nonatomic) UIActivityIndicatorView *activityIndicator;


@end

@implementation FICParentViewController
@synthesize activityIndicator=_activityIndicator;
@synthesize modelParentViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)setCustomLeftBarButton{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"reveal-icon.png"] ;
    
    UIButton *customLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customLeftButton setFrame:CGRectMake(0, 0, 22, 17)];
    [customLeftButton setImage:leftButtonImage forState:UIControlStateNormal];
    customLeftButton.contentMode = UIViewContentModeCenter;
    [customLeftButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftButton];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    customLeftButton = nil;
    [self setCustomRightBarButton];

}

-(void)setCustomRightBarButton{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"rightnavigationLogo.png"] ;
    
    UIButton *customLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customLeftButton setFrame:CGRectMake(0, 0, 36, 30)];
    [customLeftButton setImage:leftButtonImage forState:UIControlStateNormal];
    customLeftButton.contentMode = UIViewContentModeCenter;
    [customLeftButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftButton];
    
    self.navigationItem.rightBarButtonItem = revealButtonItem;
    
    customLeftButton = nil;
    
}
-(void)rightButtonClicked:(id)sender{
    
    SWRevealViewController *revealController = self.revealViewController;

    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[FICHomeViewController class]] )
    {
        FICHomeViewController *frontViewController = nil;
        if (revealController.homeViweController==nil) {
            NSString *nibname = [FICCommonUtilities getNibName:@"HomeView"];
            frontViewController = [[FICHomeViewController alloc] initWithNibName:nibname bundle:nil];
        } else{
            frontViewController = revealController.homeViweController;
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealController pushFrontViewController:navigationController animated:YES];
        frontViewController = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar.layer setShadowOffset:CGSizeMake(50, 50)];
    [self.navigationController.navigationBar.layer setShadowColor:[[UIColor redColor] CGColor]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue]>=7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:43.0/255.0 blue:73.0/255.0 alpha:1.0]];
    }else{
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0/255.0 green:43.0/255.0 blue:73.0/255.0 alpha:1.0]];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"UScoreRGD" size:21],
      NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
      
       NSFontAttributeName:[UIFont fontWithName:@"UScoreRGD" size:18]
       }
     forState:UIControlStateNormal];
}



-(BOOL)isSupportsLandscaper{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Alertview and Alertview delegate

-(void)showAlertViewWithTag:(AlertViewTag)tag title:(NSString*)title message:(NSString*)message {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Ok", @"Localized string for OK")
                                             otherButtonTitles:nil
                              , nil];
    alertView.tag = tag;
    [alertView show];
    
    alertView = nil;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==EmptyTag) {
        
        return;
    }
    
    switch (alertView.tag) {
        case InternetNonRechable:
            exit(0);
            break;
        case GeoBlocked:
            exit(0);
            break;
        case CoredataStorageError:
            exit(0);
            break;
        default:
            break;
    }
}


#pragma mark - Download Data
-(void)performOperation:(EntryLiveVodUpcoming)liveVodUpcoming maxRange:(int)maxRange managedObjectContext:(NSManagedObjectContext*)managedObjectContext{
    
    FICBackgroundProcess *backGroundProcess = [[FICBackgroundProcess alloc]init];
    
    [backGroundProcess getHighlights:^(NSMutableDictionary* responseDictionary){
        
        FICEntriesDataAccess *entriesDataAccess = [[FICEntriesDataAccess alloc]init];

        [entriesDataAccess deleteAllObjects:@"Entries" liveVodUpcoming:liveVodUpcoming context:managedObjectContext];

        NSMutableArray *entriesArray  = [responseDictionary objectForKey:@"entries"];
        
        BOOL isSaved = false;
        
        for (NSMutableDictionary *entries in entriesArray) {
            isSaved =  [entriesDataAccess saveDataToEntries:entries liveVodUpcoming:liveVodUpcoming context:managedObjectContext];
        }
        
        if (!isSaved && entriesArray.count>0) {
            [self showAlertViewWithTag:CoredataStorageError title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Something went wrong with your application, Please try again later", nil)];
            return ;
        }
        
        entriesArray = nil;
        entriesDataAccess = nil;
        switch (liveVodUpcoming) {
            case VOD:
                [self downloadLiveDataWithContext:managedObjectContext];
                break;
            case UPCOMING:
                [self startHomeView];
                break;
            case LIVE:
                [self downloadUpcomingDataWithContext:managedObjectContext];
                
                
            default:
                break;
        }

        
    }failure:^(NSError *responseError){
        
        if (responseError.code==400) {
            [self showAlertViewWithTag:GeoBlocked title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Geo_Block_Error", nil)];
            
            return ;
        } else {
            [self showAlertViewWithTag:InternetNonRechable title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Network_Error", nil)];
            return;
        }
        
        
        
    } liveVodUpcoming:liveVodUpcoming minRange:1 maxRange:maxRange];
    
    backGroundProcess = nil;
}

-(void)downloadUpcomingDataWithContext:(NSManagedObjectContext*)managedObjectContext{
    FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [self performOperation:UPCOMING maxRange:13 managedObjectContext:appDelegate.persistentStack.backgroundManagedObjectContext];
    appDelegate = nil;
}

-(void)downloadLiveDataWithContext:(NSManagedObjectContext*)managedObjectContext{
    FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [self performOperation:LIVE maxRange:13 managedObjectContext:appDelegate.persistentStack.managedObjectContext];
    appDelegate = nil;
    
}

-(void)performOperation:(EntryLiveVodUpcoming)liveVodUpcoming minRange:(int)minRange maxRange:(int)maxRange isSplash:(BOOL)isSplash{
    
    FICBackgroundProcess *backGroundProcess = [[FICBackgroundProcess alloc]init];
    
    [backGroundProcess getHighlights:^(NSMutableDictionary* responseDictionary){
        
        FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        FICEntriesDataAccess *entriesDataAccess = [[FICEntriesDataAccess alloc]initWithManagedObjectContext:appDelegate.persistentStack.managedObjectContext];
        
        if (!isSplash) {
              [entriesDataAccess deleteAllObjects:@"Entries" liveVodUpcoming:liveVodUpcoming context:appDelegate.persistentStack.managedObjectContext];
        }

        
        

        NSMutableArray *entriesArray  = [responseDictionary objectForKey:@"entries"];
        
        BOOL isSaved = false;
        
        for (NSMutableDictionary *entries in entriesArray) {
            isSaved =  [entriesDataAccess saveDataToEntries:entries liveVodUpcoming:liveVodUpcoming context:appDelegate.persistentStack.managedObjectContext];
        }
        
        if (!isSaved && entriesArray.count>0) {
            [self showAlertViewWithTag:CoredataStorageError title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Something went wrong with your application, Please try again later", nil)];
            return ;
        }
         entriesDataAccess = nil;
        entriesArray = nil;

        switch (liveVodUpcoming) {
            case VOD:

                [self downloadLiveData:isSplash];
                break;
            case UPCOMING:

                [self startHomeView];
                break;
            case LIVE:
                [self downloadUpcomingData:isSplash];
                
                
            default:
                break;
        }

        
    }failure:^(NSError *responseError){
        
        if (responseError.code==400) {
            [self showAlertViewWithTag:GeoBlocked title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Geo_Block_Error", nil)];
            
            return ;
        } else {
            [self showAlertViewWithTag:InternetNonRechable title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Network_Error", nil)];
            return;
        }
        
        
        
    } liveVodUpcoming:liveVodUpcoming minRange:minRange maxRange:maxRange];
    
    backGroundProcess = nil;
}

-(void)downloadUpcomingData:(BOOL)isSplash{
    [self performOperation:UPCOMING minRange:1 maxRange:13 isSplash:isSplash];
}

-(void)downloadLiveData:(BOOL)isSplash{
    [self performOperation:LIVE minRange:1 maxRange:13 isSplash:isSplash];
    
}

#pragma mark - Perform Single Operation Only

-(void)perforomSingleDownload:(EntryLiveVodUpcoming)liveVodUpcoming minRange:(int)minRange maxRange:(int)maxRange inManagedOBjectContext:(NSManagedObjectContext*)managedObjectContext{
    
    FICBackgroundProcess *backGroundProcess = [[FICBackgroundProcess alloc]init];
    
    [backGroundProcess getHighlights:^(NSMutableDictionary* responseDictionary){
        

        
        FICEntriesDataAccess *entriesDataAccess = [[FICEntriesDataAccess alloc]initWithManagedObjectContext:managedObjectContext];
        
        [entriesDataAccess deleteAllObjects:@"Entries" liveVodUpcoming:liveVodUpcoming context:managedObjectContext];
        
        
        NSMutableArray *entriesArray  = [responseDictionary objectForKey:@"entries"];
        
          BOOL __block __isSaved = false;
        
        for (NSMutableDictionary *entries in entriesArray) {
       
                __isSaved =  [entriesDataAccess saveDataToEntries:entries liveVodUpcoming:liveVodUpcoming context:managedObjectContext];
       
            
        }
        
        if (!__isSaved && entriesArray>0) {
            [self showAlertViewWithTag:CoredataStorageError title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Something went wrong with your application, Please try again later", nil)];
            return ;
        }
        entriesDataAccess = nil;
        entriesArray = nil;
        
        
        
        [self singleDownloadSuccess];
        
    }failure:^(NSError *responseError){
        
        if (responseError.code==400) {
            [self showAlertViewWithTag:GeoBlocked title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Geo_Block_Error", nil)];
            
            return ;
        } else {
            [self showAlertViewWithTag:InternetNonRechable title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Network_Error", nil)];
            return;
        }
        
        
        
    } liveVodUpcoming:liveVodUpcoming minRange:minRange maxRange:maxRange];
    
    backGroundProcess = nil;
}

#pragma mark - Single Download Success

-(void)singleDownloadSuccess{
    
    DLog(@"Over right Single Perform Success Method");
}


-(void)startHomeView {
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"HomeLiveUpcomingVod"];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"vodLastUpdatedDateTime"];
    
    NSString *homeNibName = [FICCommonUtilities getNibName:@"HomeView"];
    NSString *sideMenuNibName = [FICCommonUtilities getNibName:@"SideMenuView"];
    
    
    FICHomeViewController *frontViewController = [[FICHomeViewController alloc] initWithNibName:homeNibName bundle:nil];
	FICSideMenuViewController *rearViewController = [[FICSideMenuViewController alloc] initWithNibName:sideMenuNibName bundle:nil];
	
	UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
	
	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;
    
    
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
	window.rootViewController = revealController;
    
}

-(void)processSmilFile:(Entries*)clickedEntry success:(void(^)(FICVideoPlayerViewController* videoPlayer))success{
    
    
    NSArray *contentArray = [clickedEntry.contentRelationship allObjects];
    
    if (contentArray.count>0) {
        Content *content = contentArray[0];
        
        FICVideoPlayerViewController *videoPlayer = [[FICVideoPlayerViewController alloc]initWithNibName:@"VideoPlayer_iPhone" bundle:nil];
        
        NSURL *tutorialsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@&manifest=m3u",content.url ]];
        NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
        
        // 2
        TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
        
        // 3
        
        NSString *tutorialsXpathQueryString = @"//seq/video";
        NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
        
        // 4
        
        for (TFHppleElement *element in tutorialsNodes) {
            videoPlayer.urlToPlay = [NSString stringWithFormat:@"%@",[element objectForKey:@"src"] ];
            
            break;
        }
         videoPlayer.categoryName =clickedEntry.categoriesRelationship.name;
        videoPlayer.videoTitle = clickedEntry.title;
        success(videoPlayer);
        videoPlayer = nil;
        content = nil;
    }

}

#pragma mark- Play Video 

-(void)pushViedeoView:(FICVideoPlayerViewController*)videoPlayer{
    
//    SWRevealViewController *revealController = self.revealViewController;
//    
//    // We know the frontViewController is a NavigationController
//    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
//    [frontNavigationController.topViewController.navigationController pushViewController:videoPlayer animated:YES];
//    
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
//        
//        SWRevealViewController *rootViewController = (SWRevealViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
//        
//        
//            UINavigationController *frontNavigationController = (id)rootViewController.frontViewController;
//            [frontNavigationController.topViewController pushViewController:videoPlayer animated:YES];
//      
//        return;
//    }
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
//        [self.modelParentViewController.navigationController pushViewController:videoPlayer animated:YES];
        
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        
        [self presentViewController:videoPlayer animated:YES completion:nil];
        [self.activityIndicator stopAnimating];
        rootViewController = nil;
        
        return;
    }

    [self.navigationController pushViewController:videoPlayer animated:YES];
    [self.activityIndicator stopAnimating];
}



-(void)doInBackgroud:(Entries*)clickedEntry{
    
    [self processSmilFile:clickedEntry success:^(FICVideoPlayerViewController* videoPlayer){
        [self performSelectorOnMainThread:@selector(pushViedeoView:) withObject:videoPlayer waitUntilDone:YES];
    }];
}
-(void)playVideo:(Entries*)clickedEntry{
    
    UIActivityIndicatorView *activityIndication = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndication setCenter:self.view.center];
    FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [activityIndication setCenter:appDelegate.window.center ] ;
    [activityIndication startAnimating];
    self.activityIndicator = activityIndication;
    [appDelegate.window addSubview:self.activityIndicator];
    
    activityIndication = nil;
    
    
    [self performSelectorInBackground:@selector(doInBackgroud:) withObject:clickedEntry];
   
}

#pragma mark - Check Whether User have logged in 

-(BOOL)isUserVideoSessionValid{
    
    BOOL isValidLogin = NO;
    DLog(@"Boolean : %hhd",[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedOut"]);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedOut"]) {
        return NO;
    }

    NSDate *lastLogginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastLoginDate"];
    if (!lastLogginDate||[lastLogginDate isKindOfClass:[NSNull class]]) {
        
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedOut"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        return isValidLogin = NO;
    }
    
    
    NSTimeInterval intervalSinceSuccessLogin = [[NSDate date] timeIntervalSinceDate:lastLogginDate];
    
    // Check whether last login is 2 week old or not
    if (intervalSinceSuccessLogin >= 2*7*24*60*60) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedOut"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return isValidLogin = NO;
    }
    
    
    return isValidLogin = YES;
}


#pragma mark - Refresh
-(void)finishRefresh:(NSTimer*)timer{
    
    UIRefreshControl *refreshController = [timer userInfo];
    [refreshController endRefreshing];
}

-(void)refresh:(id)sender{
    
    UIRefreshControl *senderControl = (UIRefreshControl*)sender;
    
    NSTimer * repeatingTimer = [[NSTimer alloc]
                                initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.0]
                                interval:3.0 target:self selector:@selector(finishRefresh:)
                                userInfo:senderControl repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:repeatingTimer forMode:NSDefaultRunLoopMode];
    
}


#pragma mark - Create Ad Baner View

-(DFPBannerView*)createBannerView:(GADAdSize)adSize adUnitID:(NSString*)adUnitID rootViewController:(UIViewController*)rootViewController{
    
    DFPBannerView *bannerView = [[DFPBannerView alloc] initWithAdSize:adSize];

    bannerView.delegate = self;
    
    ///21535281/foxplayasia.com.AmericanFootballAmericanFootball_1_320x50
    bannerView.adUnitID = adUnitID;//@"/21535281/foxplayasia.com.Testing_1_320x100";//@"/6499/example/banner";
    bannerView.rootViewController = rootViewController;
    [bannerView loadRequest:[GADRequest request]];

    bannerView.backgroundColor = [UIColor clearColor];
    
    return bannerView;
}

// Called when an ad request loaded an ad.
- (void)adViewDidReceiveAd:(DFPBannerView *)adView {
    DLog(@"adViewDidReceiveAd");
}

/// Called when an ad request failed.
- (void)adView:(DFPBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    DLog(@"adViewDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Called just before presenting the user a full screen view, such as
/// a browser, in response to clicking on an ad.
- (void)adViewWillPresentScreen:(DFPBannerView *)adView {
    DLog(@"adViewWillPresentScreen");
}

/// Called just before dismissing a full screen view.
- (void)adViewWillDismissScreen:(DFPBannerView *)adView {
    DLog(@"adViewWillDismissScreen");
}

/// Called just after dismissing a full screen view.
- (void)adViewDidDismissScreen:(DFPBannerView *)adView {
    DLog(@"adViewDidDismissScreen");
}

/// Called just before the application will background or terminate
/// because the user clicked on an ad that will launch another
/// application (such as the App Store).
- (void)adViewWillLeaveApplication:(DFPBannerView *)adView {
    DLog(@"adViewWillLeaveApplication");
}

#pragma mark - DFBannerView Add UnitID

-(NSString*)getAddUnitId:(NSString*)mainCategory adSize:(NSString*)adSize{
    
    NSString *doubleClickServerString =@"/21535281/foxplayasia.ios.%@_1_%@";
    
   
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    NSString *resultString = [[mainCategory componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    notAllowedChars = nil;
    
//    return @"/21535281/foxplayasia.com.YachtingYachting_1_320x50";//@"/21535281/foxsportsmobile.ios.othersports_smartphonestatic_1_320x50";//@"/21535281/foxplayasia.ios.Testing_1_320x50";
    
    DLog(@"Ad Request : %@", [NSString stringWithFormat:doubleClickServerString,resultString,adSize]);
    return [NSString stringWithFormat:doubleClickServerString,resultString,adSize];
}




@end
