/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
*/

#import "FICHomeViewController.h"
#import "SWRevealViewController.h"
#import "FICEntriesDataAccess.h"
#import "FICBackgroundProcess.h"
#import "FICConfig.h"
#import "UIImageView+WebCache.h"
#import "Entries.h"
#import "FICCommonUtilities.h"
#import "FICAppDelegate.h"
#import "FICLiveUpcomingTableViewCell.h"
#import "FICUpComingViewController.h"
#import <Crashlytics/Crashlytics.h>
#import "UIImage+ImageEffects.h"
#import "UIView+BlurView.h"
@interface FICHomeViewController()<LoginSuccessDelegate> {
    
    BOOL isFirst;
    BOOL isProcessing;
    BOOL isAdLoaded;
    
}
@property(nonatomic,retain) NSMutableArray *vod_Array;
@property(nonatomic,retain) NSMutableArray *live_Array;
@property(retain,nonatomic) FICLoginViewController *loginViewController;
@property(retain,nonatomic) Entries *clickedEntry;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLable;
@property (weak, nonatomic) IBOutlet UIImageView *liveImageview;
@property (weak, nonatomic) IBOutlet UIImageView *videosImageView;
@property (weak, nonatomic) IBOutlet UILabel *upComingLable;
@property (weak, nonatomic) IBOutlet UILabel *watchliveLable;
@property (weak, nonatomic) IBOutlet UILabel *mainCategoryLable;
- (IBAction)watchLiveButtonClicked:(id)sender;

- (IBAction)videosButtonClicked:(id)sender;

// Private Methods:
- (IBAction)pushExample:(id)sender;

@end

@implementation FICHomeViewController

@synthesize vod_Array=_vod_Array;
@synthesize live_Array=_live_Array;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize liveUpcomingTableView;
@synthesize loginViewController=_loginViewController;
@synthesize clickedEntry=_clickedEntry;
#pragma mark - Timer Method

-(void)startTimer {
    
    
    
    NSTimer * repeatingTimer = [[NSTimer alloc]
                                initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.0]
                                interval:10.0 target:self selector:@selector(performInBackGround)
                                userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:repeatingTimer forMode:NSDefaultRunLoopMode];
    
}




#pragma mark - View lifecycle




- (void)viewDidLoad
{
	[super viewDidLoad];
	isAdLoaded = NO;
//	self.title = NSLocalizedString(@"Home", nil);
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightnavigationLogo.png"]];
    [self setCustomLeftBarButton];
    self.navigationItem.rightBarButtonItem = nil;
    isFirst = YES;
    isProcessing = NO;
    
    
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        self.copyrightLable.font = [UIFont fontWithName:@"UScoreRGD" size:15];
        self.watchliveLable.font = [UIFont fontWithName:@"UScoreRGD" size:20];
        self.upComingLable.font = [UIFont fontWithName:@"UScoreRGD" size:20];
    }


    [self.loadingActivityIndicator startAnimating];
    [self.loadingActivityIndicator stopAnimating];
    self.loadingActivityIndicator.hidden = YES;

    [self loadData];
    


}




-(void)loadData{
    FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    FICEntriesDataAccess *entriesDataAccess = [[FICEntriesDataAccess alloc]init];
    self.vod_Array = [[NSMutableArray alloc]initWithArray:[entriesDataAccess retriveLimitedEntryData:6 liveVodUpcoming:VOD context:appDelegate.persistentStack.backgroundManagedObjectContext]];
    
    [self performSelectorOnMainThread:@selector(setupScrollingView) withObject:nil waitUntilDone:YES];
    
    entriesDataAccess = nil;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.liveUpcomingTableView addSubview:refreshControl];
    
    refreshControl = nil;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        
        Entries *lastEntries = self.vod_Array.lastObject;
        
        [self.videosImageView sd_setImageWithURL:[NSURL URLWithString:lastEntries.defaultThumbnailUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        
        id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:0];
        
        int randomRowNumber = rand()%([sectionInfo numberOfObjects]);
        
        Entries *entries = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:randomRowNumber inSection:0]];
        
        [self.liveImageview sd_setImageWithURL:[NSURL URLWithString:entries.defaultThumbnailUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        lastEntries = nil;
        entries = nil;
        sectionInfo = nil;
        
        
        return;
    }
    
    
    return ;
}

-(void)viewDidUnload{
    [super viewDidUnload];
     self.fetchedResultsController = nil;
}

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
    
    [fetchRequest setFetchBatchSize:5];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:appDelegate.persistentStack.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"LiveUpcomingCache"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;

    
    return _fetchedResultsController;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"Home Screen";

}

-(void)performInBackGround {

//    if (isFirst) {
//        
//        [self performSelectorInBackground:@selector(downloadRemainingVOD) withObject:nil];
//        return;
//    }
    [self performSelectorInBackground:@selector(validateCountry) withObject:nil];
}
-(void)downloadRemainingVOD{
    
    [self startHomeView];
    isProcessing = YES;
    
    [self performOperation:VOD minRange:1 maxRange:9999 isSplash:NO];
}

-(void)validateCountry{
    
   
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
  
        
        if (isProcessing) {
            return;
        }
    
        NSLog(@"BackgroudnTask");
        
        NSDate* currentDateTime = [NSDate date];
        NSTimeInterval secs = [currentDateTime timeIntervalSinceDate:[[FICConfig sharedManager] lastUpdatedDate]];
        NSLog(@"Seconds --------> %@", [[FICConfig sharedManager] lastUpdatedDate]);
       FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        if (secs<=00) {
            
            if (!self.vod_Array||self.vod_Array.count>0) {
                FICEntriesDataAccess *entriesDataAccess = [[FICEntriesDataAccess alloc]init];
                self.vod_Array = [[NSMutableArray alloc]initWithArray:[entriesDataAccess retriveLimitedEntryData:6 liveVodUpcoming:VOD context:appDelegate.persistentStack.managedObjectContext]];

                [self performSelectorOnMainThread:@selector(setupScrollingView) withObject:nil waitUntilDone:YES];
                
                entriesDataAccess = nil;
            }
          
            return;
        }
        

        isProcessing = YES;
        
        
        
         [self performOperation:VOD maxRange:9999 managedObjectContext:appDelegate.persistentStack.backgroundManagedObjectContext];
        
        return;
    
        FICBackgroundProcess *backgroundProcess = [[FICBackgroundProcess alloc]init];
        
        [backgroundProcess getHighlights:^(NSMutableDictionary* responseDictionary){
            
            [self performSelectorInBackground:@selector(processData:) withObject:responseDictionary];
            
            
            
        }failure:^(NSError *responseError){
            
            if (responseError.code==400) {
                [self showAlertViewWithTag:GeoBlocked title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Geo_Block_Error", nil)];
                
                return ;
            } else {
                [self showAlertViewWithTag:InternetNonRechable title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Network_Error", nil)];
                return;
            }
            
            
            
        }liveVodUpcoming:VOD minRange:1 maxRange:9999];
        
        backgroundProcess = nil;
    });
   
}

#pragma mark - override startHomeView
-(void)startHomeView{
    
    [self performSelectorInBackground:@selector(updateHomeUI) withObject:nil];
    

    
}

-(void)updateHomeUI{
    
    FICEntriesDataAccess *entriesDataAccess = [[FICEntriesDataAccess alloc]init];
    FICAppDelegate *delegate = [UIApplication sharedApplication].delegate;
   
    if (!self.vod_Array||self.vod_Array.count==0) {
        self.vod_Array = [[NSMutableArray alloc]initWithArray:[entriesDataAccess retriveLimitedEntryData:6 liveVodUpcoming:VOD context:delegate.persistentStack.backgroundManagedObjectContext]];
        
        //                    [self setupScrollingView];
        [self performSelectorOnMainThread:@selector(setupScrollingView) withObject:nil waitUntilDone:YES];
    }else{
        
        NSMutableArray *tempVodArray =[[NSMutableArray alloc]initWithArray:[entriesDataAccess retriveLimitedEntryData:6 liveVodUpcoming:VOD context:delegate.persistentStack.backgroundManagedObjectContext]];
        BOOL isSame = false;
        for (Entries *entry in tempVodArray) {
            
            for (Entries *vodEntried in self.vod_Array) {
                
                if ([vodEntried.guid isEqualToString:entry.guid]) {
                    isSame = true;
                    break;
                }
            }
            
            tempVodArray = nil;
            if (!isSame) {
                self.vod_Array = [[NSMutableArray alloc]initWithArray:[entriesDataAccess retriveLimitedEntryData:6 liveVodUpcoming:VOD context:delegate.persistentStack.managedObjectContext]];
                [self performSelectorOnMainThread:@selector(setupScrollingView) withObject:nil waitUntilDone:YES];
                break;
            }
            
            
        }
        
    }
    isProcessing = NO;
    entriesDataAccess = nil;
}

#pragma mark - Process Data
-(void)processData :(NSMutableDictionary*) responseDictionary{
    
    FICEntriesDataAccess *entriesDataAccess = [[FICEntriesDataAccess alloc]init];

    FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSMutableArray *entriesArray  = [responseDictionary objectForKey:@"entries"];
    
    BOOL isSaved = false;
    
    for (NSMutableDictionary *entries in entriesArray) {
        isSaved =  [entriesDataAccess saveDataToEntries:entries liveVodUpcoming:VOD context:appDelegate.persistentStack.backgroundManagedObjectContext];
    }
    
    if (!isSaved) {
        [self showAlertViewWithTag:CoredataStorageError title:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Something went wrong with your application, Please try again later", nil)];
        isProcessing = NO;
        return ;
    }


    if (!self.vod_Array||self.vod_Array.count==0) {
        self.vod_Array = [[NSMutableArray alloc]initWithArray:[entriesDataAccess retriveLimitedEntryData:6 liveVodUpcoming:VOD context:appDelegate.persistentStack.backgroundManagedObjectContext]];

        [self performSelectorOnMainThread:@selector(setupScrollingView) withObject:nil waitUntilDone:YES];
    }else{
        
        NSMutableArray *tempVodArray =[[NSMutableArray alloc]initWithArray:[entriesDataAccess retriveLimitedEntryData:6 liveVodUpcoming:VOD context:appDelegate.persistentStack.backgroundManagedObjectContext]];
        BOOL isSame = false;
        for (Entries *entry in tempVodArray) {
            
            for (Entries *vodEntried in self.vod_Array) {
                
                if ([vodEntried.guid isEqualToString:entry.guid]) {
                    isSame = true;
                    break;
                }
            }
            
            tempVodArray = nil;
            if (!isSame) {
                self.vod_Array = [[NSMutableArray alloc]initWithArray:[entriesDataAccess retriveLimitedEntryData:6 liveVodUpcoming:VOD context:appDelegate.persistentStack.backgroundManagedObjectContext]];
                [self performSelectorOnMainThread:@selector(setupScrollingView) withObject:nil waitUntilDone:YES];
                break;
            }
            
            
        }
        
    }
    
    entriesDataAccess = nil;
}
#pragma mark - Example Code


- (IBAction)pushExample:(id)sender
{
	UIViewController *stubController = [[UIViewController alloc] init];
	stubController.view.backgroundColor = [UIColor whiteColor];
	[self.navigationController pushViewController:stubController animated:YES];
}

#pragma mark - Scrolling View

-(NSMutableArray*)loadScrollViewData{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.vod_Array];//[NSMutableArray alloc]initwit];
    [array removeLastObject];
    [array insertObject:self.vod_Array[self.vod_Array.count-2] atIndex:0];
//    [array insertObject:self.vod_Array[0] atIndex:self.vod_Array.count+1];
    [array addObject:self.vod_Array[0]];
 
    
    return array;
}

-(void)setupScrollingView{
    
   NSMutableArray *scrollViewData = [self loadScrollViewData];
    self.pagingController.numberOfPages = scrollViewData.count-2;
    
    for (int i=0; i<scrollViewData.count; i++) {
        
        Entries *entry = scrollViewData[i];
        CGRect frame;
        frame.origin.x = self.imageScrollingView.frame.size.width*i;
        frame.origin.y  = 0;
        frame.size = self.imageScrollingView.frame.size;
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        [subview sd_setImageWithURL:[NSURL URLWithString:entry.defaultThumbnailUrl]
            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame; //edit for you own frame
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        [self.imageScrollingView addSubview:subview];
        [self.imageScrollingView addSubview:btn];
        
        entry = nil;
    }
    
    self.imageScrollingView.contentSize = CGSizeMake(self.imageScrollingView.frame.size.width * (self.vod_Array.count+1), self.imageScrollingView.frame.size.height);
    [self.imageScrollingView setContentOffset:CGPointMake(1*self.imageScrollingView .frame.size.width, 0) animated:NO];
    Entries *entry = scrollViewData[1];
    self.titleLable.text = entry.title;
    self.titleLable.font = [UIFont fontWithName:@"UScoreRGD" size:20];
    self.labelTitle.hidden= NO;
    self.titleLable.hidden = NO;
   
    if (self.mainCategoryLable!=nil) {
        self.mainCategoryLable.text = entry.categoriesRelationship.mainCategory;
        self.mainCategoryLable.hidden = NO;
        self.mainCategoryLable.font =[UIFont fontWithName:@"UScoreRGD" size:16];
    }
    self.pagingController.hidden = NO;
    self.pagingController.currentPage = 0;
    
    scrollViewData = nil;
    entry = nil;
    
[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
    [self performSelectorOnMainThread:@selector(setupLiveUpcomingTableView) withObject:nil waitUntilDone:YES];// setupLiveUpcomingTableView
    [self.loadingActivityIndicator stopAnimating];
    
    isProcessing = NO;

}




#pragma mark - ImageView Tapped Method

- (void)btnTapped:(id)sender {
   
    UIButton *buttonTapped = sender;
    DLog(@"Tagged index : %li", (long)buttonTapped.tag);
    Entries *tappedEntry = nil;
    if (buttonTapped.tag==self.vod_Array.count) {
        tappedEntry = self.vod_Array[0];
    }else{
    
   tappedEntry = self.vod_Array[buttonTapped.tag-1];
    }
    
    NSString *homeScrollViewDetailsNibName = [FICCommonUtilities getNibName:@"ScrollViewDetails"];
    
    FICHomeScrollViewDetailsController *homeScrollViewDetails = [[FICHomeScrollViewDetailsController alloc]initWithNibName:homeScrollViewDetailsNibName bundle:nil];
    homeScrollViewDetails.clickedEntry = tappedEntry;
    

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        
        homeScrollViewDetails.view.backgroundColor = [UIColor clearColor];
        
        
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        
        UIImage *blurImage = [self.view convertViewToImage];
        blurImage = [blurImage applyBlurWithRadius:20
                                         tintColor:[UIColor colorWithWhite:1.0 alpha:0.2]
                             saturationDeltaFactor:1.3
                                         maskImage:nil];
        
        UIImageView* backView = [[UIImageView alloc] initWithFrame:homeScrollViewDetails.view.frame];
        backView.image = blurImage;
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        [homeScrollViewDetails.view insertSubview:backView atIndex:0];
        
        blurImage = nil;
        backView = nil;
        homeScrollViewDetails.modelParentViewController = self;
        
        [self presentViewController:homeScrollViewDetails animated:YES completion:nil];
        //    [self.sportsVodViewController.navigationController pushViewController:homeScrollViewDetails animated:YES];
        
        tappedEntry = nil;
        homeScrollViewDetailsNibName = nil;
        homeScrollViewDetails = nil;
        
        return;
    }

    [self.navigationController pushViewController:homeScrollViewDetails animated:YES];
  //  }
    
    tappedEntry = nil;
    homeScrollViewDetailsNibName = nil;
    homeScrollViewDetails = nil;
    
}


#pragma mark - Live Upcoming Table View

-(void)setupLiveUpcomingTableView{
    
//    FICEntriesDataAccess *entriesDataAccess = [[FICEntriesDataAccess alloc]init];
//    FICAppDelegate *appDelegarte = [UIApplication sharedApplication].delegate;
//    self.live_Array = [[NSMutableArray alloc]initWithArray:[entriesDataAccess retriveLiveAndUpcoming:appDelegarte.persistentStack.managedObjectContext]];
//    [self.liveUpcomingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
     [self.liveUpcomingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

}

-(void)scrollingTimer{
    
    CGFloat contentOffset = self.imageScrollingView.contentOffset.x;
    
    int currentPage = (int)(contentOffset/self.imageScrollingView.frame.size.width);
    
    if (currentPage==self.vod_Array.count) {
        [self.imageScrollingView setContentOffset:CGPointMake(1*self.imageScrollingView.frame.size.width, 0) animated:NO];
        [self.imageScrollingView scrollRectToVisible:CGRectMake(2*self.imageScrollingView.frame.size.width, 0, self.imageScrollingView.frame.size.width, self.imageScrollingView.frame.size.height) animated:YES];
        Entries *entry = self.vod_Array[0];
        self.titleLable.text = entry.title;
        if (self.mainCategoryLable!=nil) {
            self.mainCategoryLable.text = entry.categoriesRelationship.mainCategory;
//            self.mainCategoryLable.font =[UIFont fontWithName:@"UScoreRGD" size:14];
        }
        self.pagingController.currentPage = 1;
        return;
    }
    int nextPage = (int)(contentOffset/self.imageScrollingView.frame.size.width) + 1 ;
    [self.imageScrollingView scrollRectToVisible:CGRectMake(nextPage*self.imageScrollingView.frame.size.width, 0, self.imageScrollingView.frame.size.width, self.imageScrollingView.frame.size.height) animated:YES];
    if (currentPage==self.vod_Array.count-1) {
        currentPage = 0;
    }
    Entries *entry = self.vod_Array[currentPage];
    self.titleLable.text = entry.title;
    if (self.mainCategoryLable!=nil) {
        self.mainCategoryLable.text = entry.categoriesRelationship.mainCategory;
//        self.mainCategoryLable.font =[UIFont fontWithName:@"UScoreRGD" size:14];
    }
    self.pagingController.currentPage = currentPage;
    
}


#pragma mark - Scrollview Delegate Methods


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat contentOffset = self.imageScrollingView.contentOffset.x;
    
    int currentPage = (int)(contentOffset/self.imageScrollingView.frame.size.width);
    
    if (currentPage==self.vod_Array.count-1) {

        Entries *entry = self.vod_Array[self.vod_Array.count-2];
        if (self.mainCategoryLable!=nil) {
            self.mainCategoryLable.text = entry.categoriesRelationship.mainCategory;
//            self.mainCategoryLable.font =[UIFont fontWithName:@"UScoreRGD" size:14];
        }
        self.titleLable.text = entry.title;
        self.pagingController.currentPage = self.vod_Array.count-1;
        return;
    }
    
    if (currentPage==self.vod_Array.count) {
                [self.imageScrollingView setContentOffset:CGPointMake(1*self.imageScrollingView.frame.size.width, 0) animated:NO];

        Entries *entry = self.vod_Array[0];
        self.titleLable.text = entry.title;
        if (self.mainCategoryLable!=nil) {
            self.mainCategoryLable.text = entry.categoriesRelationship.mainCategory;
            //            self.mainCategoryLable.font =[UIFont fontWithName:@"UScoreRGD" size:14];
        }
        self.pagingController.currentPage = 0;
        return;
    }
    
    if (currentPage==0) {
        [self.imageScrollingView setContentOffset:CGPointMake((self.vod_Array.count-1)*self.imageScrollingView.frame.size.width, 0) animated:NO];
        Entries *entry = self.vod_Array[self.vod_Array.count-2];
        self.titleLable.text = entry.title;
        if (self.mainCategoryLable!=nil) {
            self.mainCategoryLable.text = entry.categoriesRelationship.mainCategory;
//            self.mainCategoryLable.font =[UIFont fontWithName:@"UScoreRGD" size:14];
        }
        self.pagingController.currentPage = self.vod_Array.count-1;
        return;

    }
  
    if (currentPage==self.vod_Array.count-1) {
        currentPage = 0;
    }
    Entries *entry = self.vod_Array[currentPage-1];
    self.titleLable.text = entry.title;
    if (self.mainCategoryLable!=nil) {
        self.mainCategoryLable.text = entry.categoriesRelationship.mainCategory;
//        self.mainCategoryLable.font =[UIFont fontWithName:@"UScoreRGD" size:14];
    }
    self.pagingController.currentPage = currentPage-1;
}


#pragma mark - Table View Datasource & Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return self.live_Array.count;
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects]+1;
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    id  sectionInfo =
//    [_fetchedResultsController sections] ;
//    DLog(@"Total Sections : %i",[sectionInfo count]);
//    return [sectionInfo count];
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
//    
//    
//    
//    CGSize stringsize1 = [[theSection name] sizeWithAttributes:
//                          @{NSFontAttributeName:
//                                [UIFont fontWithName:@"UScoreRGD" size:18]}];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, tableView.frame.size.width, stringsize1.height)];
//    [label setFont:[UIFont fontWithName:@"UScoreRGD" size:18]];
//    NSString *string = [[theSection name] isEqualToString:@"0"]?@"Live":@"Upcoming";
//    [label setText:string];
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    label.numberOfLines = 0;
//    label.textColor = [UIColor whiteColor];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, label.frame.size.height+30)];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:0/255. green:44/255. blue:75/255. alpha:1.0]]; //your background color...
//    return view;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
//    
//    
//    
//    CGSize stringsize1 = [[theSection name] sizeWithAttributes:
//                          @{NSFontAttributeName:
//                                [UIFont fontWithName:@"UScoreRGD" size:18]}];
//    //    DLog(@"String Size : %f",stringsize1.height+30);
//    //    return 50;
//    return round(stringsize1.height+30);
//}

- (void)configureCell:(FICLiveUpcomingTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Entries *liveEntries = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.titleLabel.text = liveEntries.title ;
    cell.titleLabel.font = [UIFont fontWithName:@"UScoreRGD" size:18];
    
    if (liveEntries.livevodupcoming!=[NSNumber numberWithInt:LIVE]) {
        cell.liveImageView.hidden = YES;
        cell.dateLabel.hidden = NO;
        cell.dateLabel.text = [FICCommonUtilities formatDate:@"EEEE dd hh:mm a" timeZone:@"SGT" date:liveEntries.availableDate];//liveEntries.availableDate;
        cell.dateLabel.font = [UIFont fontWithName:@"UScoreRGD" size:13];
    }else{
        cell.dateLabel.hidden = YES;
        cell.liveImageView.hidden = NO;

    }
   
    liveEntries = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"TableCell";
    
//    id  sectionInfo =
//    [[_fetchedResultsController sections] objectAtIndex:indexPath.section];
    
    if (indexPath.row==3) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADD"];
        if (cell==nil) {
             cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ADD"];
        }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!isAdLoaded) {
            UIImageView *adPlaceHolderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foxPlayLogo.png"]];
            [adPlaceHolderImageView setFrame:CGRectMake(0, 0, 50, 45)];
            adPlaceHolderImageView.center = CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2);
            
            //        [adPlaceHolderImageView setImage:[UIImage imageNamed:@"foxPlayLogo.png"]];
            adPlaceHolderImageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:adPlaceHolderImageView];
            
            
            
            adPlaceHolderImageView = nil;
            
            [cell.contentView addSubview:[self createBannerView:kGADAdSizeBanner adUnitID:[self getAddUnitId:@"Sport" adSize:@"320x50"] rootViewController:self]];
            cell.backgroundColor = [UIColor blackColor];
            
            isAdLoaded = YES;
        }
        
        
       
        
        return cell;
    }
    
     FICLiveUpcomingTableViewCell *cell = (FICLiveUpcomingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    NSString *nibname = @"LiveUpcomingTableCell_iPhone";//[FICCommonUtilities getNibName:@"LiveUpcomingTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibname owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    nibname = nil;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    
    lineView.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:lineView];
    lineView = nil;
    
  
    
    if (indexPath.row>3) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        [self configureCell:cell atIndexPath:newIndexPath];
    }else{
        [self configureCell:cell atIndexPath:indexPath];
    }
//       cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
//    
//    lineView.backgroundColor = [UIColor blackColor];
//    [cell.contentView addSubview:lineView];
//    lineView = nil;
    
    return cell;
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

    [self.navigationController presentViewController:self.loginViewController animated:YES completion:^{
        
    }];
    
    login = nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [[Crashlytics sharedInstance] crash];
    if (indexPath.row==3) {
        return;
    }
    
    if (indexPath.row>3) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
    
    Entries *clickedEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    self.clickedEntry = clickedEntry;
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval secs = [currentDate timeIntervalSinceDate:self.clickedEntry.availableDate];
    
    if (secs>=0&&clickedEntry.livevodupcoming!=[NSNumber numberWithInt:LIVE]) {
        
        [self checkLoginAndPlayVideo];
        currentDate = nil;
        return;
    }

    
    if ([clickedEntry.livevodupcoming isEqual:[NSNumber numberWithInt:LIVE]]) {
        
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
               
//                self.clickedEntry = clickedEntry;
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
        
        return;

    }
    
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
    
}

#pragma mark - Fetched Results controller Delegate

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.liveUpcomingTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.liveUpcomingTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(FICLiveUpcomingTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.liveUpcomingTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.liveUpcomingTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.liveUpcomingTableView endUpdates];
}


#pragma mark - Login Success Delegate Method

-(void)loginSuccess{
    self.loginViewController.webView = nil;
    self.loginViewController = nil;
     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedOut"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *contentArray = [self.clickedEntry.contentRelationship allObjects];
    
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
        }
    }

}
- (IBAction)watchLiveButtonClicked:(id)sender {
    
    FICLiveUpComingViewController *liveUpcoming = nil;
   
        NSString *nibname = [FICCommonUtilities getNibName:@"LiveUpComing"];
        liveUpcoming = [[FICLiveUpComingViewController alloc]initWithNibName:nibname bundle:nil];
    
    [self.navigationController pushViewController:liveUpcoming animated:YES];
    liveUpcoming = nil;
    
}

- (IBAction)videosButtonClicked:(id)sender {
    

        FICSportsVodViewController *sportsVod = nil;
    
            NSString *nibname = [FICCommonUtilities getNibName:@"SportsVod"];
            sportsVod = [[FICSportsVodViewController alloc]initWithNibName:nibname bundle:nil];
           
    [self.navigationController pushViewController:sportsVod animated:YES];
        sportsVod = nil;
      

}
@end