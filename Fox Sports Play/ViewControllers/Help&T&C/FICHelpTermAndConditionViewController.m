//
//  FICHelpTermAndConditionViewController.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 24/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICHelpTermAndConditionViewController.h"

@interface FICHelpTermAndConditionViewController ()

@end

@implementation FICHelpTermAndConditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCustomLeftBarButton];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.conditon==HELP) {
        
        
       
        NSURL *url = [NSURL URLWithString:@"http://apps.foxsportsasia.com/fsp/android/Help.html"];
        NSURLRequest *rq = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:rq];
        self.screenName = @"Help Screen";
        self.title  = @"Help";
        return;
    }
    if (self.conditon==TV_LISTINGS) {
        NSURL *url = [NSURL URLWithString:@"http://tv.foxsportsasia.com"];
        NSURLRequest *rq = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:rq];
        self.screenName = @"TV Listings";
        self.title  = @"TV Listings";
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://apps.foxsportsasia.com/fsp/android/FSPTandC.html"];
    NSURLRequest *rq = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:rq];
    self.screenName = @"T&C Screen";
    self.title = @"Terms & Conditions";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
