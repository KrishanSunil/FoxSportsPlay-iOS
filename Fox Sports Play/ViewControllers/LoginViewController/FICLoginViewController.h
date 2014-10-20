//
//  FICLoginViewController.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 18/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICParentViewController.h"

@protocol LoginSuccessDelegate

@required
-(void)loginSuccess;

@optional
-(void)logoutSuccess;

@end

@interface FICLoginViewController : FICParentViewController<UIWebViewDelegate>{
    
}
@property (nonatomic,weak) id loginSuccessDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
