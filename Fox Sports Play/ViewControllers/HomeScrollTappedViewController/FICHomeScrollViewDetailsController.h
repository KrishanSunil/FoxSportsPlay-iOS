//
//  FICHomeScrollViewDetailsController.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 5/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICParentViewController.h"
#import "Entries.h"
#import "UIImageView+WebCache.h"
#import "FICScrollViewDetailTableViewCell.h"
#import "FICLoginViewController.h"

@interface FICHomeScrollViewDetailsController : FICParentViewController<UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate,LoginSuccessDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UILabel *otherVideosLable;
@property (nonatomic,retain) Entries *clickedEntry;
@property (weak, nonatomic) IBOutlet UIImageView *clickedVideoImageView;
@property (weak, nonatomic) IBOutlet UITableView *otherVideosTableView; 
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
- (IBAction)imageViewButtonClicked:(id)sender;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end