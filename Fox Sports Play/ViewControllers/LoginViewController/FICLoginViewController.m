//
//  FICLoginViewController.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 18/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICLoginViewController.h"

@interface FICLoginViewController (){
    
}

@property (nonatomic,assign) BOOL isCallingLogout;

@end



@implementation FICLoginViewController

@synthesize isCallingLogout=_isCallingLogout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isCallingLogout = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.screenName = @"Login Screen";
    if ([self isUserVideoSessionValid]) {
        
        self.isCallingLogout = YES;
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"logout" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:htmlFile];
        NSURLRequest *rq = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:rq];
        
        return;
    }
    
    self.isCallingLogout = NO;
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"login" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:htmlFile];
    NSURLRequest *rq = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:rq];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View will Dissapear 
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
    self.webView = nil;
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}




#pragma mark UIWebViewDelegate methods
//only used here to enable or disable the back and forward buttons
- (void)webViewDidStartLoad:(UIWebView *)thisWebView
{
	DLog(@"Started");
}

- (void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
    //        setGlobalCountyCode(my)
   
	
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (self.isCallingLogout) {
        
        if([[request.URL absoluteString] rangeOfString:@"logoutStatus#"].location!=NSNotFound) {
            
           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedOut"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            DLog(@"Boolean : %hhd",[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedOut"]);
            [self.loginSuccessDelegate logoutSuccess];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            return NO;
        }
    }
    
    if([[request.URL absoluteString] hasSuffix:@"ValidateCountry#"]) {

        NSString *function = [[NSString alloc] initWithFormat: @"setGlobalCountyCode('%@')",[[NSUserDefaults standardUserDefaults] objectForKey:@"CountryCode"]];
        [webView stringByEvaluatingJavaScriptFromString:function];
        
        
        return NO;
    }
    
    if ([[request.URL absoluteString] hasPrefix:@"http://www.accccedddo.tv/?toolbox_user_token="]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoginSuccess"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"LastLoginDate"];
         [[NSUserDefaults standardUserDefaults] synchronize];
        
//        [self.loginSuccessDelegate loginSuccess];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.loginSuccessDelegate loginSuccess];
        }];
        
        return NO;
    }
    
    if ([[request.URL absoluteString] rangeOfString:@"https://sp.tbxnet.com/v2/auth/fpa/login.html?idp=prensafpa&"].location ==NSNotFound) {
        return YES;
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoginSuccess"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"LastLoginDate"];
         [[NSUserDefaults standardUserDefaults] synchronize];
//        [self.loginSuccessDelegate loginSuccess];
        [self dismissViewControllerAnimated:YES completion:^{
           [self.loginSuccessDelegate loginSuccess];
        }];
        
        return NO;
    }
    
    
    
    return YES;
}
- (IBAction)rewindButtonClicked:(id)sender {
    
    [self.webView goBack];
}
- (IBAction)cancelButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
