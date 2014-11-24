//
//  FICVideoPlayerViewController.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 10/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICParentViewController.h"
#import "IMAAdsLoader.h"

@interface FICVideoPlayerViewController : FICParentViewController
{
    
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatior;
@property(nonatomic,retain) NSString *urlToPlay;
@property(nonatomic,retain) NSString *categoryName;
@property(nonatomic,retain) NSString *videoTitle;

@property(nonatomic, strong) IMAAdsLoader *adsLoader;

@end
