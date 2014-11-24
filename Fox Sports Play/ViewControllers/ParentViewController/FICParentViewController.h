//
//  FICParentViewController.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 22/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FICCommonDataAccess.h"
#import "Entries.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"
#import "DFPBannerView.h"
#import "GADRequest.h"
typedef enum {
    EmptyTag,
    InternetNonRechable,
    GeoBlocked,
    CoredataStorageError,
    GeoError
} AlertViewTag;

@interface FICParentViewController : GAITrackedViewController<UIAlertViewDelegate,GADBannerViewDelegate>



@property(nonatomic,retain) FICParentViewController *modelParentViewController;

-(void)setCustomLeftBarButton;
-(void)setCustomRightBarButton;
-(void)showAlertViewWithTag:(AlertViewTag)tag title:(NSString*)title message:(NSString*)message;
-(void)performOperation:(EntryLiveVodUpcoming)liveVodUpcoming minRange:(int)minRange maxRange:(int)maxRange isSplash:(BOOL)isSplash;
-(void)performOperation:(EntryLiveVodUpcoming)liveVodUpcoming maxRange:(int)maxRange managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

-(void)perforomSingleDownload:(EntryLiveVodUpcoming)liveVodUpcoming minRange:(int)minRange maxRange:(int)maxRange inManagedOBjectContext:(NSManagedObjectContext*)managedObjectContext;

-(void)downloadUpcomingData:(BOOL)isSplash;
-(void)downloadLiveData:(BOOL)isSplash;
-(void)startHomeView;
-(void)singleDownloadSuccess;
-(BOOL)isSupportsLandscaper;
-(void)playVideo:(Entries*)clickedEntry;
-(BOOL)isUserVideoSessionValid;
-(void)refresh:(id)sender;


-(DFPBannerView*)createBannerView:(GADAdSize)adSize adUnitID:(NSString*)adUnitID rootViewController:(UIViewController*)rootViewController;
-(NSString*)getAddUnitId:(NSString*)mainCategory adSize:(NSString*)adSize;
@end
