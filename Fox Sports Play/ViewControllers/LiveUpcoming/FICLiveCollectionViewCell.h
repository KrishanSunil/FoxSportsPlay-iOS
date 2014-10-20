//
//  FICLiveCollectionViewCell.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 10/10/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FICLiveCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *entryImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;
@end
