//
//  FICHorizontalTableViewCell.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 9/10/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICHorizontalTableViewCell.h"
#import "ControlVariables.h"
#import "Entries.h"
#import "FICLiveTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FICCommonUtilities.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"
#import "DFPBannerView.h"
#import "GADRequest.h"
#import "FICHomeScrollViewDetailsController.h"
#import "UIView+BlurView.h"
#import "UIImage+ImageEffects.h"

@implementation FICHorizontalTableViewCell

@synthesize horizontalTableView = _horizontalTableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize clickedCategory = _clickedCategory;
@synthesize sectionNumber=_sectionNumber;
@synthesize sportsVodViewController = _sportsVodViewController;
#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"section Number : %i", self.sectionNumber);
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:self.sectionNumber];
   
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
    
//    NSLog(@"Entry Title : %@",entry.title);
//    NSLog(@"Entry Available Date : %@",entry.availableDate);
//    NSLog(@"Entry Expiration Date : %@",entry.expirationDate);
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:self.sectionNumber];
    if (indexPath.row==[sectionInfo numberOfObjects]) {
        
        static NSString *cellIdentifier = @"ADD_VOD";
        
        FICLiveTableViewCell *cell = (FICLiveTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSString *nibname = [FICCommonUtilities getNibName:@"adsTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibname owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.transform =CGAffineTransformMakeRotation(M_PI * 0.5);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *adSubView = [self.sportsVodViewController createBannerView:kGADAdSizeLargeBanner adUnitID:[self.sportsVodViewController getAddUnitId:[self.sportsVodViewController.clickedCategory isEqual:@""]?[sectionInfo name]:self.sportsVodViewController.clickedCategory adSize:@"320x100"] rootViewController:self.sportsVodViewController];
        adSubView.center = [cell.contentView convertPoint:cell.contentView.center fromView:cell.contentView.superview];
        
        [cell.contentView addSubview:adSubView];
        cell.backgroundColor = [UIColor blackColor];
        cell.contentMode = UIViewContentModeCenter;
        
        
        
        return cell;

    }
    

    
    static NSString *cellIdentifier = @"Cell";
    
    FICLiveTableViewCell *cell = (FICLiveTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *nibname = @"SportsVodTableViewCell_iPhone";//[FICCommonUtilities getNibName:@"SportsVodTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibname owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.transform =CGAffineTransformMakeRotation(M_PI * 0.5);
    
    
//    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    

    
//    self.cellFrame = cell.frame;
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.sectionNumber];
    [self configureCell:cell atIndexPath:newIndexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc]init];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 5.0, 0, 5, cell.contentView.frame.size.height)];
    
    lineView.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:lineView];
    lineView = nil;
    
    return cell;
}

-(void)transformTableView{
    self.horizontalTableView.showsVerticalScrollIndicator = NO;
    self.horizontalTableView.showsHorizontalScrollIndicator = NO;
    self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:self.sectionNumber];
//    if (indexPath.row==[sectionInfo numberOfObjects]) {
//        return 100.0;
//    }
    return 320.0;
}

#pragma mark - TableView Did Select Delegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:self.sectionNumber];
    
    if (indexPath.row==[sectionInfo numberOfObjects]) {
        return;
    }
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.sectionNumber];
    Entries *clickedEntry = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
    
    NSString *homeScrollViewDetailsNibName = [FICCommonUtilities getNibName:@"ScrollViewDetails"];
    
    FICHomeScrollViewDetailsController *homeScrollViewDetails = [[FICHomeScrollViewDetailsController alloc]initWithNibName:homeScrollViewDetailsNibName bundle:nil];
    homeScrollViewDetails.clickedEntry = clickedEntry;
    homeScrollViewDetails.view.backgroundColor = [UIColor clearColor];
    homeScrollViewDetails.modelParentViewController = self.sportsVodViewController;
    
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    UIImage *blurImage = [self.sportsVodViewController.view convertViewToImage];
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
    
    [self.sportsVodViewController presentViewController:homeScrollViewDetails animated:YES completion:nil];
//    [self.sportsVodViewController.navigationController pushViewController:homeScrollViewDetails animated:YES];
    
    clickedEntry = nil;
    homeScrollViewDetailsNibName = nil;
    homeScrollViewDetails = nil;

}






@end
