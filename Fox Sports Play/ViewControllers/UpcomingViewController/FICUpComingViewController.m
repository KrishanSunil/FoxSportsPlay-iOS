//
//  FICUpComingViewController.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 24/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICUpComingViewController.h"
#import "UIImageView+WebCache.h"
#import "FICAppDelegate.h"
#import "FICScrollViewDetailTableViewCell.h"
#import "FICCommonUtilities.h"
#import "Categories.h"
#import "FICLoginViewController.h"
@interface FICUpComingViewController ()<NSFetchedResultsControllerDelegate,LoginSuccessDelegate>

@property (weak, nonatomic) IBOutlet UILabel *eventNotStartedLable;
@property (weak, nonatomic) IBOutlet UIImageView *clickedImageView;
@property (weak, nonatomic) IBOutlet UITableView *otherVideosTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *otherVideosLable;
@property (retain,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIImageView *plyerButton;
@property (retain,nonatomic) NSString *mainCategory;
@property (nonatomic,assign) BOOL isPlayerButtonEnabled;
@property (nonatomic,assign) BOOL isButtonPressed;
@property (weak, nonatomic) IBOutlet UILabel *bacgroundLable;
@property (nonatomic,retain) FICLoginViewController *loginViewController;
- (IBAction)imageButtonClicked:(id)sender;
- (IBAction)closePopover:(id)sender;
@end

@implementation FICUpComingViewController

@synthesize clickedEntry = _clickedEntry;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize mainCategory=_mainCategory;
@synthesize isPlayerButtonEnabled = _isPlayerButtonEnabled;
@synthesize isButtonPressed = _isButtonPressed;
@synthesize loginViewController = _loginViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isPlayerButtonEnabled = NO;
        self.isButtonPressed = NO;
    }
    return self;
}

-(void)loadMainImage{
    [self.clickedImageView sd_setImageWithURL:[NSURL URLWithString:self.clickedEntry.defaultThumbnailUrl]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.titleLable.text = self.clickedEntry.title;
    self.titleLable.font = [UIFont fontWithName:@"UScoreRGD" size:18];
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval secs = [currentDate timeIntervalSinceDate:self.clickedEntry.availableDate];
    
    if (secs>=0) {
        self.plyerButton.hidden = NO;
        self.isPlayerButtonEnabled = YES;
        self.eventNotStartedLable.text = @"This Event Has Started";
        return;
    }
    
    self.plyerButton.hidden = YES;
    self.isPlayerButtonEnabled = NO;
    self.eventNotStartedLable.text = @"This Event Has Not Yet Started";
    return;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self loadMainImage];
    self.bacgroundLable.hidden = NO;
    
    Categories *categoriesSet = self.clickedEntry.categoriesRelationship;//[self.clickedEntry valueForKey:@"categoriesRelationship"];
//    NSArray *categoriesArray = [categoriesSet allObjects];
    
    self.mainCategory = categoriesSet.subCategory;
    
//    for (Categories *category in categoriesArray) {
//        self.mainCategory = category.subCategory;
//        break;
//    }
    categoriesSet = nil;
//    categoriesArray = nil;
    
    self.titleLable.text = self.clickedEntry.title;
    
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setCustomRightBarButton];
    self.eventNotStartedLable.font = self.titleLable.font = [UIFont fontWithName:@"UScoreRGD" size:18];
    self.otherVideosLable.font = self.titleLable.font = [UIFont fontWithName:@"UScoreRGD" size:18];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.otherVideosTableView addSubview:refreshControl];
    
    refreshControl = nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"Upcoming Details Screen";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload{
    self.fetchedResultsController = nil;
    [super viewDidUnload];
}

#pragma mark - NSFetchresults controller
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    FICAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:appDelegate.persistentStack.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"availableDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
   NSPredicate  *predicate= [NSPredicate predicateWithFormat: @"livevodupcoming == %@ AND categoriesRelationship.subCategory CONTAINS[cd] %@ AND guid != %@", self.clickedEntry.livevodupcoming,self.mainCategory,self.clickedEntry.guid];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setFetchBatchSize:2];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:appDelegate.persistentStack.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    theFetchedResultsController = nil;
    return _fetchedResultsController;
    
}

#pragma mark - Table View Data Source and Delegate Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(FICScrollViewDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Entries *sameCategoryEntries = [_fetchedResultsController objectAtIndexPath:indexPath];
    [cell.similarImages sd_setImageWithURL:[NSURL URLWithString:sameCategoryEntries.defaultThumbnailUrl]
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    cell.datelable.text = sameCategoryEntries.title;
    cell.datelable.font = [UIFont fontWithName:@"UScoreRGD" size:18];
    [cell.datelable sizeToFit];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CellIdentifier";
    
    FICScrollViewDetailTableViewCell *cell = (FICScrollViewDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *nibname = [FICCommonUtilities getNibName:@"ScrollViewDetailsTableCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibname owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc]init];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    
    lineView.backgroundColor = [UIColor colorWithRed:36/255. green:53/255. blue:71/255. alpha:1.0];
    [cell.contentView addSubview:lineView];
    lineView = nil;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.clickedEntry = nil;
    self.clickedEntry =[_fetchedResultsController objectAtIndexPath:indexPath];
    [self loadMainImage];
    self.fetchedResultsController = nil;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    [self.otherVideosTableView reloadData];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.otherVideosTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.otherVideosTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(FICScrollViewDetailTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
            [self.otherVideosTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.otherVideosTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.otherVideosTableView endUpdates];
}

#pragma mark - Player Button Clicked
- (IBAction)imageButtonClicked:(id)sender {
    
    if (!self.isPlayerButtonEnabled) {
        return;
    }
    
    self.isButtonPressed = YES;
    
    if ([self isUserVideoSessionValid]) {
        [self playVideo:self.clickedEntry];
        return;
    }
    
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
    //    [self.navigationController pushViewController:self.loginViewController animated:YES];
    login = nil;

}

- (IBAction)closePopover:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Login Delegate

-(void)loginSuccess{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedOut"];
    [self playVideo:self.clickedEntry];
}
@end
