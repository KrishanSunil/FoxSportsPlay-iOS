//
//  FICSportsVodViewController.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 10/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICSportsVodViewController.h"
#import "FICAppDelegate.h"
#import "FICCategoryDataAccess.h"
#import "SWRevealViewController.h"
#import "FICEntriesDataAccess.h"
#import "UIImageView+WebCache.h"
#import "Content.h"
#import "FICVideoPlayerViewController.h"
#import "FICLiveTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "FICLoginViewController.h"
#import "FICHorizontalTableViewCell.h"

#define kiPadFontSize 20
#define kiPhoneFontSize 16

@interface FICSportsVodViewController (){
    
    NSMutableArray *dataForTableView;
    NSMutableArray *mainCategoriesArray;
}

@property(nonatomic,retain) NSMutableArray *dataForTableView;
@property(nonatomic,retain) NSMutableArray *mainCategoriesArray;

@property(nonatomic,retain) UIButton *selectedButton;
@property (nonatomic) CGRect cellFrame;
@end

@implementation FICSportsVodViewController

@synthesize dataForTableView=_dataForTableView;
@synthesize mainCategoriesArray=_mainCategoriesArray;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize clickedCategory = _clickedCategory;
@synthesize selectedButton=_selectedButton;
@synthesize cellFrame=_cellFrame;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)downloadVodDataInBackground{
    
    dispatch_queue_t downloadVODQueue = dispatch_queue_create("VOD Quee", NULL);
    dispatch_async(downloadVODQueue, ^{
        FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
      [self  perforomSingleDownload:VOD minRange:1 maxRange:9999 inManagedOBjectContext:appDelegate.persistentStack.managedObjectContext ];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Videos";
    
    [self setCustomLeftBarButton];
    

    self.loadingAnimatior.hidden = YES;
    [self.loadingAnimatior stopAnimating];
    self.clickedCategory = @"";
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.resultsTableView addSubview:refreshControl];
    
    refreshControl = nil;
   
}

- (void)viewDidUnload {
    self.fetchedResultsController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.screenName = @"Videos Screen";
    
    NSDate *vodLastUpdatedDateTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"vodLastUpdatedDateTime"];
    
    if (!vodLastUpdatedDateTime||[vodLastUpdatedDateTime isEqual:[NSNull class]]) {
        self.loadingAnimatior.hidden = NO;
        [self.loadingAnimatior startAnimating];
        [self downloadVodDataInBackground];
        
        return;
    }
    
    NSDate* currentDateTime = [NSDate date];
    NSTimeInterval secs = [currentDateTime timeIntervalSinceDate:vodLastUpdatedDateTime];
    
    if (secs>=2*60*60) {

        self.loadingAnimatior.hidden = NO;
        [self.loadingAnimatior startAnimating];
        [self downloadVodDataInBackground];
        return;
    }
    
    [self singleDownloadSuccess];
}


#pragma mark - Download Completed

-(void)singleDownloadSuccess{
    

    
    FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    FICCategoryDataAccess *categoryDataAccess = [[FICCategoryDataAccess alloc]init];
    NSArray *categories = [categoryDataAccess getDiffrentMainCategories:appDelegate.persistentStack.managedObjectContext];
    
    self.mainCategoriesArray = [[NSMutableArray alloc]initWithArray:categories];
    

    categories = nil;
    categoryDataAccess = nil;
    
    [self setupScrollableTablView];
    
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    [self.resultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    self.loadingAnimatior.hidden = YES;
    [self.loadingAnimatior stopAnimating];
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"vodLastUpdatedDateTime"];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    FICAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:appDelegate.persistentStack.managedObjectContext];
    [fetchRequest setEntity:entity];
    

//   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"availableDate" ascending:YES];
    NSSortDescriptor *subCategorySortDiscriptor = [[NSSortDescriptor alloc] initWithKey:@"categoriesRelationship.name" ascending:YES];


    NSPredicate *predicate = nil;
    if ([self.clickedCategory isEqualToString:@""]||[self.clickedCategory isKindOfClass:[NSNull class]]) {
        predicate= [NSPredicate predicateWithFormat: @"livevodupcoming == %@ AND expirationDate >= %@ ",[NSNumber numberWithInt:VOD],[NSDate date]];
    }else{
        predicate= [NSPredicate predicateWithFormat: @"livevodupcoming == %@ AND categoriesRelationship.mainCategory CONTAINS[cd] %@ AND expirationDate >= %@", [NSNumber numberWithInt:VOD],self.clickedCategory,[NSDate date]];
    }

    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:subCategorySortDiscriptor,nil]];
    [fetchRequest setIncludesSubentities:YES];
    [fetchRequest setFetchBatchSize:3];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:appDelegate.persistentStack.managedObjectContext sectionNameKeyPath:@"categoriesRelationship.name"
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}


#pragma mark - Scrollabe Tab View

-(void)setupScrollableTablView{
    
    int x = 0;
    
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allButton.tag = 0;
    [allButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [allButton setTitle:@"ALL Sports" forState:UIControlStateNormal];
    [allButton setTitleColor:[UIColor colorWithRed:37/255. green:171/255. blue:208/255. alpha:1.0] forState:UIControlStateSelected];
    [allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [allButton.titleLabel setFont:[UIFont fontWithName:@"UScoreRGD" size:UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?kiPadFontSize:kiPhoneFontSize]];
    [allButton sizeToFit];
    allButton.frame = CGRectMake(x+30, 5, allButton.frame.size.width, self.tabbarScrollView.frame.size.height-10);
    
    if ([self.clickedCategory isEqual:@""]) {
        self.selectedButton = allButton;
        self.selectedButton.selected = YES;
        allButton.selected = YES;
    }
    
    [self.tabbarScrollView addSubview:allButton];
    x = x + allButton.frame.size.width+60;
    allButton = nil;
    
    for (int i=0; i<self.mainCategoriesArray.count; i++) {
        
        UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        allButton.tag = i+1;
        [allButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [allButton setTitle:[self.mainCategoriesArray[i] objectForKey:@"mainCategory"] forState:UIControlStateNormal];
        [allButton setTitleColor:[UIColor colorWithRed:37/255. green:171/255. blue:208/255. alpha:1.0] forState:UIControlStateSelected];
        [allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [allButton.titleLabel setFont:[UIFont fontWithName:@"UScoreRGD" size:UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?kiPadFontSize:kiPhoneFontSize]];
        [allButton sizeToFit];
        if ([self.clickedCategory isEqual:[self.mainCategoriesArray[i] objectForKey:@"mainCategory"]]) {
            self.selectedButton = allButton;
            self.selectedButton.selected = YES;
        }
        allButton.frame = CGRectMake(x, 5, allButton.frame.size.width, self.tabbarScrollView.frame.size.height-10);
        
        [self.tabbarScrollView addSubview:allButton];
        
        x = x + allButton.frame.size.width+30;
        allButton = nil;
    }
    
    self.tabbarScrollView.contentSize = CGSizeMake(x, self.tabbarScrollView.frame.size.height);
    [self.tabbarScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void)buttonPressed:(id)sender{
    
    UIButton *clickedButton = (UIButton*)sender;
    
    self.selectedButton.selected = NO;
    
    self.selectedButton = nil;
    self.selectedButton = clickedButton;
    self.selectedButton.selected = YES;
    self.clickedCategory =clickedButton.tag==0?@"":[self.mainCategoriesArray[clickedButton.tag-1] objectForKey:@"mainCategory" ];
    self.fetchedResultsController = nil;
    
    
     // Setup the Google Analytics
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"CategoryButtonClicked"     // Event category (required)
                                                          action:@"ButtonClicked"  // Event action (required)
                                                           label:self.clickedCategory          // Event label
                                                           value:nil] build]];
    
    self.screenName = [NSString stringWithFormat:@"Videos Screen/%@",self.clickedCategory];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    [self.resultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

   

}



#pragma mark - Table View Data source and Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [_fetchedResultsController sections].count;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//
//{
//    
//    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
//
//    return [theSection name];
//    
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    

    
    CGSize stringsize1 = [[theSection name] sizeWithAttributes:
                                             @{NSFontAttributeName:
                                                   [UIFont fontWithName:@"UScoreRGD" size:18]}];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, tableView.frame.size.width, stringsize1.height)];
    [label setFont:[UIFont fontWithName:@"UScoreRGD" size:18]];
    NSString *string =[theSection name];
    [label setText:string];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, label.frame.size.height+30)];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor blackColor]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    
    
    CGSize stringsize1 = [[theSection name] sizeWithAttributes:
                          @{NSFontAttributeName:
                                [UIFont fontWithName:@"UScoreRGD" size:18]}];
//    DLog(@"String Size : %f",stringsize1.height+30);
//    return 50;
    return round(stringsize1.height+30);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return 1;
    }

    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects]+1;
}

- (void)configureCell:(FICLiveTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Entries *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
 
//    if (entry.livevodupcoming!=[NSNumber numberWithInt:LIVE]) {
        cell.liveImageView.hidden = YES;
//    }
    
    [cell.entryImageView sd_setImageWithURL:[NSURL URLWithString:entry.defaultThumbnailUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.titleLable.text = entry.title;
    cell.titleLable.font = [UIFont fontWithName:@"UScoreRGD" size:18];
    cell.titleLable.center = cell.backgroundView.center;
    cell.dateLabel.hidden = YES;
    cell.dateLabel.font = [UIFont fontWithName:@"UScoreRGD" size:14];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        static NSString *cellIdentifier = @"Cell";
        
        FICHorizontalTableViewCell *cell = (FICHorizontalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSString *nibname = @"FICHorizontalTableViewCell";//[FICCommonUtilities getNibName:@"SportsVodTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibname owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.sportsVodViewController = self;
        [cell transformTableView];
        cell.fetchedResultsController = self.fetchedResultsController;
        cell.sectionNumber = (int)indexPath.section;
        
        return cell;
    }
    
    
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:indexPath.section];
    if (indexPath.row==[sectionInfo numberOfObjects]) {
        
        static NSString *cellIdentifier = @"ADD_VOD";
        
        FICLiveTableViewCell *cell = (FICLiveTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSString *nibname = [FICCommonUtilities getNibName:@"adsTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibname owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:[self createBannerView:kGADAdSizeLargeBanner adUnitID:[self getAddUnitId:[self.clickedCategory isEqual:@""]?[sectionInfo name]:self.clickedCategory adSize:@"320x100"] rootViewController:self]];
        cell.backgroundColor = [UIColor blackColor];
        
        
        
        return cell;
        
    }
    
    static NSString *cellIdentifier = @"Cell";
    
    FICLiveTableViewCell *cell = (FICLiveTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *nibname = [FICCommonUtilities getNibName:@"SportsVodTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibname owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    self.cellFrame = cell.frame;

    
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc]init];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 5.0, cell.contentView.frame.size.width, 5)];
    
    lineView.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:lineView];
    lineView = nil;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:indexPath.section];
    if (indexPath.row==[sectionInfo numberOfObjects]) {
        return 100.0;
    }
    
    return 180.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:indexPath.section];
    
    if (indexPath.row==[sectionInfo numberOfObjects]) {
        return;
    }
    Entries *clickedEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *homeScrollViewDetailsNibName = [FICCommonUtilities getNibName:@"ScrollViewDetails"];
    
    FICHomeScrollViewDetailsController *homeScrollViewDetails = [[FICHomeScrollViewDetailsController alloc]initWithNibName:homeScrollViewDetailsNibName bundle:nil];
    homeScrollViewDetails.clickedEntry = clickedEntry;
    [self.navigationController pushViewController:homeScrollViewDetails animated:YES];
    
    
    
    clickedEntry = nil;
    homeScrollViewDetailsNibName = nil;
    homeScrollViewDetails = nil;

    
}

#pragma mark - NSFetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.resultsTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.resultsTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(FICLiveTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
            [self.resultsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.resultsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.resultsTableView endUpdates];
}





@end
