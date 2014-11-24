//
//  FICLiveUpComingViewController.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 10/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICLiveUpComingViewController.h"
#import "FICAppDelegate.h"
#import "FICEntriesDataAccess.h"
#import "Entries.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "Content.h"
#import "FICVideoPlayerViewController.h"
#import "FICLoginViewController.h"
#import "FICLiveCollectionViewCell.h"
#import "UIView+BlurView.h"
#import "UIImage+ImageEffects.h"
@interface FICLiveUpComingViewController ()<LoginSuccessDelegate>{
    
    NSMutableArray *dataForTableView;
}

@property(retain,nonatomic) NSMutableArray *dataForTableView;
@property (nonatomic) EntryLiveVodUpcoming liveUpcoming;
@property(nonatomic,retain) FICLoginViewController *loginViewController;
@property (nonatomic,retain) Entries *clickedEntry;
@property (nonatomic,assign) int numberOfAds;
@end

@implementation FICLiveUpComingViewController

@synthesize dataForTableView=_dataForTableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize liveUpcoming=_liveUpcoming;
@synthesize loginViewController=_loginViewController;
@synthesize clickedEntry=_clickedEntry;
@synthesize numberOfAds=_numberOfAds;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.numberOfAds = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.liveUpcoming = VOD;
   [self setCustomLeftBarButton];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    NSError *error;
//	if (![[self fetchedResultsController] performFetch:&error]) {
//		// Update to handle the error appropriately.
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		exit(-1);  // Fail
//	}
    
    self.title = @"Watch Live";
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        

        
        [self.liveUpcomingCollectionView registerNib:[UINib nibWithNibName:@"LiveUpcomingCollectionViewCell_iPad" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
        
        self.liveUpcomingFlowlayout = (UICollectionViewFlowLayout*)self.liveUpcomingCollectionView.collectionViewLayout;//[[UICollectionViewFlowLayout alloc] init];
        [self.liveUpcomingFlowlayout setItemSize:CGSizeMake(338, 181)];
        [self.liveUpcomingFlowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.liveUpcomingFlowlayout.minimumInteritemSpacing = 0.0f;
        self.liveUpcomingFlowlayout.minimumLineSpacing = 0.0f;
        [self.liveUpcomingFlowlayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.liveUpcomingCollectionView setCollectionViewLayout:self.liveUpcomingFlowlayout];
        self.liveUpcomingCollectionView.bounces = YES;
        [self.liveUpcomingCollectionView setShowsHorizontalScrollIndicator:NO];
        [self.liveUpcomingCollectionView setShowsVerticalScrollIndicator:NO];
    }else{
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.liveUpComingTableView addSubview:refreshControl];
    
    refreshControl = nil;
    }

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.fetchedResultsController = nil;
    
}

-(void)downloadVodDataInBackground:(EntryLiveVodUpcoming)liveUpcoming{
    self.liveUpcoming = liveUpcoming;
    
    dispatch_queue_t downloadVODQueue = dispatch_queue_create("Live Upcoming Quee", NULL);
    dispatch_async(downloadVODQueue, ^{
        FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [self  perforomSingleDownload:liveUpcoming minRange:1 maxRange:13 inManagedOBjectContext:appDelegate.persistentStack.managedObjectContext ];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.screenName = @"Live&Upcoming Screen";
    
    NSDate *vodLastUpdatedDateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"HomeLiveUpcomingVod"];
    
    if (!vodLastUpdatedDateTime||[vodLastUpdatedDateTime isEqual:[NSNull class]]) {
        
        [self downloadVodDataInBackground:LIVE];
        
        return;
    }
    
    NSDate* currentDateTime = [NSDate date];
    NSTimeInterval secs = [currentDateTime timeIntervalSinceDate:vodLastUpdatedDateTime];
    
    if (secs>=2*60*60) {
       
        [self downloadVodDataInBackground:LIVE];
        return;
    }
    
    [self singleDownloadSuccess];
}

-(void)singleDownloadSuccess{
    
    
    if (self.liveUpcoming==LIVE) {
        [self downloadVodDataInBackground:UPCOMING];
        
        return;
    }
    
    self.fetchedResultsController = nil;
    [NSFetchedResultsController deleteCacheWithName:@"LiveUpcomingCache"];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    [self.liveUpComingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
     [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"HomeLiveUpcomingVod"];
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
     FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:appDelegate.persistentStack.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = nil;
    
    predicate= [NSPredicate predicateWithFormat: @"livevodupcoming != %@ ",[NSNumber numberWithInt:VOD]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"livevodupcoming" ascending:YES];

    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setIncludesSubentities:YES];
    
    [fetchRequest setFetchBatchSize:3];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:appDelegate.persistentStack.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"LiveUpcomingCache"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = nil;
    
    return _fetchedResultsController;
    
}

#pragma mark - Table view Datasource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
     DLog(@"sections row Counts : %i",[sectionInfo numberOfObjects]);
    DLog(@"floor Number : %i",(int)floor([sectionInfo numberOfObjects]/5));
    DLog(@"Round Number : %i",(int)round([sectionInfo numberOfObjects]/5));
    self.numberOfAds =floor([sectionInfo numberOfObjects]/5);
    return [sectionInfo numberOfObjects]+(int)round([sectionInfo numberOfObjects]/5);
}


- (void)configureCell:(FICLiveTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Entries *entry = [_fetchedResultsController objectAtIndexPath:indexPath];
  
    if ([entry.livevodupcoming intValue]!=LIVE) {
        cell.liveImageView.hidden = YES;
        cell.dateLabel.text = [FICCommonUtilities formatDate:@"EEEE dd hh:mm a" timeZone:@"UTC" date:entry.availableDate];
        cell.dateLabel.font = [UIFont fontWithName:@"UScoreRGD" size:13];
    }else{
        cell.liveImageView.hidden = NO;
        cell.dateLabel.hidden = YES;
//        cell.dateLabel.text = @"NOW LIVE";//liveEntries.availableDate;
//        cell.dateLabel.font = [UIFont fontWithName:@"UScoreRGD" size:13];
//        cell.dateLabel.textColor = [UIColor redColor];
    }
    
    [cell.entryImageView sd_setImageWithURL:[NSURL URLWithString:entry.defaultThumbnailUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.titleLable.text = entry.title;
   cell.titleLable.font = [UIFont fontWithName:@"UScoreRGD" size:18];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DLog(@"********************************** Index Path Row : %i",indexPath.row);

    static NSString *cellIdentifier = @"Cell";
    
    FICLiveTableViewCell *cell = (FICLiveTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *nibname = [FICCommonUtilities getNibName:@"LiveUpcomingTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibname owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    if (indexPath.row%5>=1&&indexPath.row>5) {
//        indexPath = [NSIndexPath indexPathForRow:indexPath.row-round(indexPath.row/5) inSection:indexPath.section];
//    }
     [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc]init];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 5.0, cell.contentView.frame.size.width, 5)];
    
    lineView.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:lineView];
    lineView = nil;
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    Entries *clickedEntry = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([clickedEntry.livevodupcoming intValue]!=LIVE) {
        
        NSString *nibName = [FICCommonUtilities getNibName:@"Upcoming"];
        FICUpComingViewController *upComing = [[FICUpComingViewController alloc]initWithNibName:nibName bundle:nil];
        upComing.clickedEntry = clickedEntry;
        

        
        
     

        [self.navigationController pushViewController:upComing animated:YES];
        
        upComing = nil;

        return;
    }
    
    NSArray *contentArray = [clickedEntry.contentRelationship allObjects];
    
    for (Content *content in contentArray) {
        
        if ([content.format isEqualToString:@"M3U"]) {
            
            if ([self isUserVideoSessionValid]) {
               
                FICVideoPlayerViewController *videoPlayer = [[FICVideoPlayerViewController alloc]initWithNibName:@"VideoPlayer_iPhone" bundle:nil];
                videoPlayer.urlToPlay = content.url;
                 videoPlayer.categoryName =clickedEntry.categoriesRelationship.name;
                videoPlayer.videoTitle = clickedEntry.title;
                [self.navigationController pushViewController:videoPlayer animated:YES];
                
                videoPlayer = nil;
                return;
            }
            self.clickedEntry = clickedEntry;
            
            NSString *nibName = [FICCommonUtilities getNibName:@"LoginView"];
            FICLoginViewController *login = [[FICLoginViewController alloc]initWithNibName:nibName bundle:nil];
            login.loginSuccessDelegate = self;
            self.loginViewController = login;
            [self.navigationController presentViewController:self.loginViewController animated:YES completion:^{
                
            }];

            login = nil;
        }
    }
}

#pragma mark - Collection View Datasource Delegate Method

- (void)configureCollectionViewCell:(FICLiveCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Entries *entry = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    DLog(@"Entry : %@", entry);
    if ([entry.livevodupcoming intValue]!=LIVE) {
        cell.liveImageView.hidden = YES;
        cell.dateLabel.hidden = NO;
        cell.dateLabel.text = [FICCommonUtilities formatDate:@"EEEE dd hh:mm a" timeZone:@"UTC" date:entry.availableDate];
        cell.dateLabel.font = [UIFont fontWithName:@"UScoreRGD" size:13];

    }else{
        cell.liveImageView.hidden = NO;
        cell.dateLabel.hidden = YES;
//        cell.dateLabel.text = @"NOW LIVE";//liveEntries.availableDate;
//        cell.dateLabel.font = [UIFont fontWithName:@"UScoreRGD" size:13];
//        cell.dateLabel.textColor = [UIColor redColor];
    }
    
    [cell.entryImageView sd_setImageWithURL:[NSURL URLWithString:entry.defaultThumbnailUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.titleLable.text = entry.title;
    cell.titleLable.font = [UIFont fontWithName:@"UScoreRGD" size:18];
    }

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
//    DLog(@"Number of objects : %i",[sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
//    UICollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    cell1.backgroundColor = [UIColor redColor];
//    return cell1;
    
    FICLiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *nibname = @"LiveUpcomingCollectionViewCell_iPhone";//[FICCommonUtilities getNibName:@"LiveUpcomingCollectionViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibname owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
  
    [self configureCollectionViewCell:cell atIndexPath:indexPath];
  
    return cell;
}




- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


-(void)checkLoginAndPlayVideo{
    
    if ([self isUserVideoSessionValid]) {
        [self playVideo:self.clickedEntry];
        return;
    }
    
    NSString *nibName = [FICCommonUtilities getNibName:@"LoginView"];
    FICLoginViewController *login = [[FICLoginViewController alloc]initWithNibName:nibName bundle:nil];
    login.loginSuccessDelegate = self;
    self.loginViewController = login;
    
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
//        //        [self.modelParentViewController.navigationController pushViewController:videoPlayer animated:YES];
//        
//        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
//        rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
//        
//        
//        [self presentViewController:self.loginViewController animated:YES completion:nil];
//        
//        login = nil;
//        
//        return;
//    }
    [self.navigationController presentViewController:self.loginViewController animated:YES completion:^{
        
    }];
    
    login = nil;

}

//-(void)loginSuccess{
//   
//}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Entries *clickedEntry = [_fetchedResultsController objectAtIndexPath:indexPath];
     self.clickedEntry = clickedEntry;
    
    // Check For the upComing Event Started or not
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval secs = [currentDate timeIntervalSinceDate:self.clickedEntry.availableDate];
    
    if (secs>=0&&[clickedEntry.livevodupcoming intValue]!=LIVE) {
        
        [self checkLoginAndPlayVideo];
        currentDate = nil;
        return;
    }
    
    
    //
    if ([clickedEntry.livevodupcoming intValue]!=LIVE) {
        
        NSString *nibName = [FICCommonUtilities getNibName:@"Upcoming"];
        FICUpComingViewController *upComing = [[FICUpComingViewController alloc]initWithNibName:nibName bundle:nil];
        upComing.clickedEntry = clickedEntry;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            
            upComing.view.backgroundColor = [UIColor clearColor];
            
            
            UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
            rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            

            UIImage *blurImage = [self.view convertViewToImage];
            blurImage = [blurImage applyBlurWithRadius:20
                                                                     tintColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                                                         saturationDeltaFactor:1.3
                                                                     maskImage:nil];
            
            UIImageView* backView = [[UIImageView alloc] initWithFrame:upComing.view.frame];
            backView.image = blurImage;
            backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
           
            [upComing.view insertSubview:backView atIndex:0];
            
            blurImage = nil;
            backView = nil;
            upComing.modelParentViewController = self;
            
            [self presentViewController:upComing animated:YES completion:nil];
            //    [self.sportsVodViewController.navigationController pushViewController:homeScrollViewDetails animated:YES];
            
            clickedEntry = nil;
            nibName = nil;
            upComing = nil;
            
            return;
        }
        [self.navigationController pushViewController:upComing animated:YES];
        
        upComing = nil;
        
        return;
    }
    
    NSArray *contentArray = [clickedEntry.contentRelationship allObjects];
    
    for (Content *content in contentArray) {
        
        if ([content.format isEqualToString:@"M3U"]) {
            
            if ([self isUserVideoSessionValid]) {
                
                NSString *nibName = [FICCommonUtilities getNibName:@"VideoPlayer"];
                FICVideoPlayerViewController *videoPlayer = [[FICVideoPlayerViewController alloc]initWithNibName:nibName bundle:nil];
                videoPlayer.urlToPlay = content.url;
                videoPlayer.categoryName =self.clickedEntry.categoriesRelationship.name;
                videoPlayer.videoTitle = self.clickedEntry.title;
                
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
                    //        [self.modelParentViewController.navigationController pushViewController:videoPlayer animated:YES];
                    
                    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
                    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
                    
                    
                    [self presentViewController:videoPlayer animated:YES completion:nil];
                    
                    videoPlayer = nil;
                    nibName = nil;
                    return;
                }
                [self.navigationController pushViewController:videoPlayer animated:YES];
                
                videoPlayer = nil;
                nibName = nil;
                return;
            }
            self.clickedEntry = clickedEntry;
            
            NSString *nibName = [FICCommonUtilities getNibName:@"LoginView"];
            FICLoginViewController *login = [[FICLoginViewController alloc]initWithNibName:nibName bundle:nil];
            login.loginSuccessDelegate = self;
            self.loginViewController = login;
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
                //        [self.modelParentViewController.navigationController pushViewController:videoPlayer animated:YES];
                
                UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
                rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
                
                
                [self presentViewController:self.loginViewController animated:YES completion:nil];
                
                login = nil;
                
                return;
            }
            [self.navigationController presentViewController:self.loginViewController animated:YES completion:^{
                
            }];
            
            login = nil;
        }
    }

}

#pragma mark - Login Success Delegate

-(void)loginSuccess{
    
    if ([self.clickedEntry.livevodupcoming intValue]!=LIVE) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedOut"];
         [[NSUserDefaults standardUserDefaults] synchronize];
        [self playVideo:self.clickedEntry];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedOut"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *contentArray = [self.clickedEntry.contentRelationship allObjects];
    
    for (Content *content in contentArray) {
        
        if ([content.format isEqualToString:@"M3U"]) {
            FICVideoPlayerViewController *videoPlayer = [[FICVideoPlayerViewController alloc]initWithNibName:@"VideoPlayer_iPhone" bundle:nil];
            videoPlayer.urlToPlay = content.url;
             videoPlayer.categoryName =self.clickedEntry.categoriesRelationship.name;
            videoPlayer.videoTitle = self.clickedEntry.title;
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
                //        [self.modelParentViewController.navigationController pushViewController:videoPlayer animated:YES];
                
                UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
                rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
                
                
                [self presentViewController:videoPlayer animated:YES completion:nil];
                
                videoPlayer = nil;
                
                return;
            }

            [self.navigationController pushViewController:videoPlayer animated:YES];
            videoPlayer = nil;

        }
    }

    
    
    
}
@end
