//
//  FICHorizontalTableViewCell.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 9/10/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPBannerView.h"
#import "GADRequest.h"
#import "FICSportsVodViewController.h"
@interface FICHorizontalTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate>{
    
   
    
}

@property (weak, nonatomic) IBOutlet UITableView *horizontalTableView;
@property (nonatomic,retain) NSString *clickedCategory;
@property (nonatomic) int sectionNumber;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,retain) FICSportsVodViewController *sportsVodViewController;
-(void)transformTableView;
@end
