//
//  FICHelpTermAndConditionViewController.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 24/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICParentViewController.h"

typedef enum {
    HELP,
    TERMS_CONDITION,
    TV_LISTINGS
    
} HelpTermsCondition;

@interface FICHelpTermAndConditionViewController : FICParentViewController
@property(nonatomic,assign) HelpTermsCondition conditon;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
