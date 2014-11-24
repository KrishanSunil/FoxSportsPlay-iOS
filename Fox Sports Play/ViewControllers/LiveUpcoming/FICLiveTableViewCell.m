//
//  FICLiveTableViewCell.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 12/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICLiveTableViewCell.h"

@implementation FICLiveTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
