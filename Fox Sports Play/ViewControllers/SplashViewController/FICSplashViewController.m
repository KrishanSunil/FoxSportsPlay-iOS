//
//  FICSplashViewController.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 22/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICSplashViewController.h"
#import "FICCommonUtilities.h"
#import "AFHTTPRequestOperationManager+timeout.h"
#import "FICMpx.h"
#import "FICCountryDataAccess.h"
#import "FICConfig.h"
#import "FICEntriesDataAccess.h"
#import "FICHomeViewController.h"
#import "FICSideMenuViewController.h"
#import "SWRevealViewController.h"
#import "FICLanguagesDataAccess.h"
#import "Languages.h"
#import "FICConfig.h"

#define GEOLOCATION_TIMEOUT 10000

@interface FICSplashViewController ()<SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;

@end

@implementation FICSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //  Check for the Internet Availability
    //  If internet not available show alert and terminate the application
    self.connectingLable.font =[UIFont fontWithName:@"UScoreRGD" size:18];
    BOOL isInternetAvailable = [FICCommonUtilities isInternetConnectionAvailable];
    
    if (!isInternetAvailable) {
        
        [self showAlertViewWithTag:InternetNonRechable title:NSLocalizedString(@"Error", @"Network not rechable") message:NSLocalizedString(@"Network_Error", @"No internet connection")];
        
        return;
        
    }
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval secs = [currentDate timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"HomeLiveUpcomingVod"]];
    
    if (secs<2*60*60) {
        [self startHomeView];
        return;
    }
    
    // obtain the Geolocation based on the iP
    
    [self getGeoLocation];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Get Geo location

-(void)getGeoLocation {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:FOX_LOCATION_SERVICE
      parameters:nil
 timeoutInterval:GEOLOCATION_TIMEOUT
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             DLog(@"JSON: %@", responseObject);
             NSMutableDictionary *jsonDictionary = responseObject;
             
             NSMutableArray *countryArray =[jsonDictionary objectForKey:@"country"];
             NSMutableDictionary *countryDictionary = [countryArray objectAtIndex:0];
  
             countryArray = nil;
             
//             [[NSUserDefaults standardUserDefaults] setObject:@"us" forKey:@"CountryCode"];
//             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [[NSUserDefaults standardUserDefaults] setObject:[[[countryDictionary objectForKey:@"countryCode"] lowercaseString] isEqualToString:@"us"]?@"sg":[[countryDictionary objectForKey:@"countryCode"] lowercaseString] forKey:@"CountryCode"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             FICCountryDataAccess *countryDataAccess  = [[FICCountryDataAccess alloc]init];
             NSArray *existingCountryArray =  [countryDataAccess retriveCountryData:[[countryDictionary objectForKey:@"countryCode"] lowercaseString]];
             
             if (!existingCountryArray ||[ existingCountryArray count]==0) {
                 
                 NSMutableArray *countryArrya = [jsonDictionary objectForKey:@"country"];
                 [countryDataAccess saveDataToCountry:[countryArrya objectAtIndex:0]];
                 
                 countryDataAccess = nil;
                 existingCountryArray = nil;
                 countryArrya= nil;
             }
           
             
             
             // get Language Files
             [self getLangugageFiles:[[[countryDictionary objectForKey:@"countryCode"] lowercaseString] isEqualToString:@"us"]?@"sg":[[[countryDictionary objectForKey:@"countryCode"] lowercaseString]  lowercaseString]];
             
             jsonDictionary = nil;
             return;
             
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             DLog(@"Error: %@", error);
             [self showAlertViewWithTag:GeoBlocked
                                  title:NSLocalizedString(@"Error", "Error")
                                message:NSLocalizedString(@"Geo_Block_Error", "GeoLocation Error")];
             
             return ;
         }];
}

#pragma mark - get Langugage Files

-(void)getLangugageFiles:(NSString*)countryCode{
    
    NSString *languageUrl = [NSString stringWithFormat:@"%@lang_%@.json",[[FICConfig sharedManager] isDebugMode]==YES?FOX_LANGUAGE_PATH_DEBUG:FOX_LANGUAGE_PATH_LIVE,countryCode];
//   NSString *languageUrl = [NSString stringWithFormat:@"%@lang_us.json",[[FICConfig sharedManager] isDebugMode]==YES?FOX_LANGUAGE_PATH_DEBUG:FOX_LANGUAGE_PATH_LIVE];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:languageUrl
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             DLog(@"JSON: %@", responseObject);
             
             FICLanguagesDataAccess *languageAccess = [[FICLanguagesDataAccess alloc]init];
             

             
             NSArray *langugeData = [languageAccess retriveLanguagesData];
             
             if (!langugeData||langugeData.count==0) {
                 

                 
                 [languageAccess saveDataToLanguages:responseObject];
                 
//                 if ([[FICConfig sharedManager] isDebugMode]) {
//                     [self startHomeView];
//                    
//                 } else{
                     [self validateCountry:countryCode];
//                 };
                 
                 return ;
             }
             
             Languages *existingLanguage = [langugeData objectAtIndex:0];
             NSMutableDictionary *languageDictionary = [[NSMutableDictionary alloc] init];
             [languageDictionary setObject:existingLanguage.version forKey:@"version"];
            
             
             BOOL isBothFileSame = [self isLanguageFilesAreSame:languageDictionary newFile:languageDictionary];
             
             if (!isBothFileSame) {
                 

                 
                 [languageAccess saveDataToLanguages:responseObject];
             }
             
             languageDictionary = nil;
             languageAccess = nil;
             existingLanguage = nil;
             
//             if ([[FICConfig sharedManager] isDebugMode]) {
//                 [self startHomeView];
//                 
//             } else{
                 [self validateCountry:countryCode];
//             };
             
             
             
             return;
             
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             DLog(@"Error: %@", error);
             
//             if ([[FICConfig sharedManager] isDebugMode]) {
//                 [self startHomeView];
//                 
//             } else{
                 [self validateCountry:countryCode];
//             }
             
             return ;
         }];
    
    languageUrl = nil;
}

-(BOOL)isLanguageFilesAreSame:(NSMutableDictionary*)oldFile newFile:(NSMutableDictionary*)newFile{
    
    BOOL isSame = YES;
    
    if ([oldFile objectForKey:@"version"]==[newFile objectForKey:@"version"]) {
        
        return isSame;
    }
    
    return isSame=NO;
    
}



-(void)validateCountry:(NSString*)countryCode {
   
    [self performOperation:VOD minRange:1 maxRange:9999 isSplash:YES];
 
    
}



-(void)startHomeView {
    
    NSString *homeNibName = [FICCommonUtilities getNibName:@"HomeView"];
    NSString *sideMenuNibName = [FICCommonUtilities getNibName:@"SideMenuView"];
 
    
    FICHomeViewController *frontViewController = [[FICHomeViewController alloc] initWithNibName:homeNibName bundle:nil];
	FICSideMenuViewController *rearViewController = [[FICSideMenuViewController alloc] initWithNibName:sideMenuNibName bundle:nil];
	
	UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
	
	SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;
    revealController.homeViweController = frontViewController;
    
    
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
	window.rootViewController = revealController;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"HomeLiveUpcomingVod"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"vodLastUpdatedDateTime"];
}

#pragma mark - SWRevealViewDelegate

- (id <UIViewControllerAnimatedTransitioning>)revealController:(SWRevealViewController *)revealController animationControllerForOperation:(SWRevealControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ( operation != SWRevealControllerOperationReplaceRightController )
        return nil;
    
        
    return nil;
}


@end
