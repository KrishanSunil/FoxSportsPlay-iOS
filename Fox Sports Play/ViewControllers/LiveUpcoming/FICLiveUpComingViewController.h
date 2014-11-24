//
//  FICLiveUpComingViewController.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 10/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICParentViewController.h"
#import "FICLiveTableViewCell.h"
#import "FICUpComingViewController.h"
#import "FICLoginViewController.h"

@interface FICLiveUpComingViewController : FICParentViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LoginSuccessDelegate>

@property (weak, nonatomic) IBOutlet UITableView *liveUpComingTableView;
@property (strong, nonatomic) IBOutlet UICollectionView *liveUpcomingCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *liveUpcomingFlowlayout;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
