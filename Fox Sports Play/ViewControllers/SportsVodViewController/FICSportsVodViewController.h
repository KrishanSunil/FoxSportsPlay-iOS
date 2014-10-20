//
//  FICSportsVodViewController.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 10/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICParentViewController.h"

@interface FICSportsVodViewController : FICParentViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *tabbarScrollView;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingAnimatior;
@property(nonatomic,retain) NSString *clickedCategory;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
