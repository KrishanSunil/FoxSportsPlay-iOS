
/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 
*/

#import "FICSideMenuViewController.h"

#import "SWRevealViewController.h"
#import "FICHomeViewController.h"
#import "FICLanguagesDataAccess.h"
#import "SubLanguages.h"
#import "Languages.h"
#import "Texts.h"
#import "FICCommonUtilities.h"
#import "FICSportsVodViewController.h"
#import "FICLiveUpComingViewController.h"
@interface FICSideMenuViewController(){
    
    Texts *text;
  
}

@property(retain,nonatomic) Texts *text;
@property(retain,nonatomic) NSMutableArray *subMenuArray;
@property(retain,nonatomic) FICLoginViewController *loginViewController;


@end

@implementation FICSideMenuViewController

@synthesize rearTableView = _rearTableView;
@synthesize text;
@synthesize subMenuArray;
@synthesize loginViewController=_loginViewController;

#pragma mark - View lifecycle


- (void)viewDidLoad
{
	[super viewDidLoad];
	
//    FICLanguagesDataAccess *languageDataAccess = [[FICLanguagesDataAccess alloc]init];
//    NSArray *languagesArray = [languageDataAccess retriveLanguagesData:[[NSUserDefaults standardUserDefaults] stringForKey:@"countryCode"]];
//    
//    if (languagesArray &&languagesArray.count>0) {
//        
//        Languages *languages = [languagesArray objectAtIndex:0];
//        
//        for (SubLanguages *subLanguages in languages.subLanguageRelationShip) {
//            
//            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageCode"] isEqualToString:@""]||[[[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageCode"] isKindOfClass:[NSNull class]]) {
//                
//                text = subLanguages.textRelationShip;
//                
//                break;
//            }
//            
//            if ([subLanguages.languageCode isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageCode"]]) {
//                
//                text = subLanguages.textRelationShip;
//                break;
//            }
//            
//        }
//
//    }
//    
//    if (!text||[text isKindOfClass:[NSNull class]]) {
//        self.title = NSLocalizedString(@"Menu", @"Menu");
//    }else{
//        self.title = text.txt_menu_home;
//    }
    
    subMenuArray = [[NSMutableArray alloc]init];
    

    
    
	
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.screenName = @"Menu Screen";
    
    [self loadMenuTextArray];
}

-(void)loadMenuTextArray {
    
    [self.subMenuArray removeAllObjects];
    
    if (!text||[text isKindOfClass:[NSNull class]]) {
        [self.subMenuArray addObject:@"Home"];
        [self.subMenuArray addObject:@"Watch Live"];
        
        [self.subMenuArray addObject:@"Videos"];
        [self.subMenuArray addObject:@"TV Listings"];
        if ([self isUserVideoSessionValid]) {
            [self.subMenuArray addObject:@"Logout"];
        }else{
            [self.subMenuArray addObject:@"Login"];
        }
        
        
        [self.subMenuArray addObject:@"Help"];
        [self.subMenuArray addObject:@"T & C"];
        
        
      
       
        
        
    }else{
        
        [self.subMenuArray addObject:self.text.txt_menu_home];
        [self.subMenuArray addObject:self.text.txt_menu_live];
        [self.subMenuArray addObject:self.text.txt_menu_sports_vod];
        [self.subMenuArray addObject:@"TV Listings"];
        if ([self isUserVideoSessionValid]) {
            [self.subMenuArray addObject:self.text.txt_menu_logout];
        }else{
            [self.subMenuArray addObject:self.text.txt_menu_login];
        }
        
        
        [self.subMenuArray addObject:self.text.txt_menu_help];
        [self.subMenuArray addObject:self.text.txt_menu_t_and_c];

        
    }
    
    NSString *version = [NSString stringWithFormat:@"Version : %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    
    [self.subMenuArray addObject:version];
    
    [self.rearTableView reloadData];
}


#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.subMenuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
 
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	

    
    cell.textLabel.text = [self.subMenuArray objectAtIndex:indexPath.row];
    
    if (indexPath.row==self.subMenuArray.count-1) {
        cell.textLabel.font = [UIFont fontWithName:@"UScoreRGD" size:15];
        cell.textLabel.textColor = [UIColor blackColor];

    }else{
    cell.textLabel.font = [UIFont fontWithName:@"UScoreRGD" size:18];
    cell.textLabel.textColor = [UIColor whiteColor];
    }
	cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIView alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    // Add Live ImageView
    if ([cell.textLabel.text isEqual:@"Watch Live"]||[cell.textLabel.text isEqual:self.text.txt_menu_live]) {
        
        UIImageView *liveImage = [[UIImageView alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-50-5-60, cell.contentView.frame.size.height/2-6, 50, 13)];
        [liveImage setImage:[UIImage imageNamed:@"ic_live@2x.png"]];
        [cell.contentView addSubview:liveImage];
        liveImage = nil;
        
    }
    
    
    
   // customize the Sepertor
    if (indexPath.row==3) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 2.0, cell.contentView.frame.size.width, 2)];
        
        lineView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:lineView];
        lineView = nil;
    }else if(indexPath.row!=self.subMenuArray.count-1){
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
        
        lineView.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:lineView];
        lineView = nil;
    }
    
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==self.subMenuArray.count-1) {
        return;
    }
	// Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // We know the frontViewController is a NavigationController
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
    NSInteger row = indexPath.row;

	// Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
	if (row == 0)
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.        
        if ( ![frontNavigationController.topViewController isKindOfClass:[FICHomeViewController class]] )
        {
            FICHomeViewController *frontViewController = nil;
            if (revealController.homeViweController==nil) {
                NSString *nibname = [FICCommonUtilities getNibName:@"HomeView"];
               frontViewController = [[FICHomeViewController alloc] initWithNibName:nibname bundle:nil];
            } else{
                frontViewController = revealController.homeViweController;
            }
           
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
			[revealController pushFrontViewController:navigationController animated:YES];
            frontViewController = nil;
            navigationController = nil;
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
	}
   else if (row==2) {
        if ( ![frontNavigationController.topViewController isKindOfClass:[FICSportsVodViewController class]] )
        {
            FICSportsVodViewController *sportsVod = nil;
            if (revealController.sportsVODViewController==nil) {
                NSString *nibname = [FICCommonUtilities getNibName:@"SportsVod"];
                sportsVod = [[FICSportsVodViewController alloc]initWithNibName:nibname bundle:nil];
                revealController.sportsVODViewController   = sportsVod;
            }else{
                sportsVod = revealController.sportsVODViewController;
            }
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sportsVod];
        [revealController pushFrontViewController:navigationController animated:YES];
        sportsVod = nil;
             navigationController = nil;
        }
        else
		{
            revealController.sportsVODViewController = (FICSportsVodViewController*)frontNavigationController.topViewController;
			[revealController revealToggle:self];
		}
    }
    
   else if(row==1){
       
       if ( ![frontNavigationController.topViewController isKindOfClass:[FICLiveUpComingViewController class]] )
       {
           FICLiveUpComingViewController *liveUpcoming = nil;
           if (revealController.liveUpcomingViewController==nil) {
               NSString *nibname = [FICCommonUtilities getNibName:@"LiveUpComing"];
              liveUpcoming = [[FICLiveUpComingViewController alloc]initWithNibName:nibname bundle:nil];
               revealController.liveUpcomingViewController = liveUpcoming;
           }else{
               liveUpcoming = revealController.liveUpcomingViewController;
           }
           
           
           UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:liveUpcoming];
           [revealController pushFrontViewController:navigationController animated:YES];
           liveUpcoming = nil;
            navigationController = nil;
       }
       else
       {
                       revealController.liveUpcomingViewController = (FICLiveUpComingViewController*)frontNavigationController.topViewController;
           [revealController revealToggle:self];
       }

       
   }
    
   else if(row==4){
       
       if ( ![frontNavigationController.topViewController isKindOfClass:[FICLoginViewController class]] )
       {
           
               NSString *nibname = [FICCommonUtilities getNibName:@"LoginView"];
              FICLoginViewController *loginLogoutView = [[FICLoginViewController alloc]initWithNibName:nibname bundle:nil];
           loginLogoutView.loginSuccessDelegate = self;
           self.loginViewController = loginLogoutView;
           loginLogoutView = nil;
           [self presentViewController:self.loginViewController animated:YES completion:^{
               
           }];

       }
       else
       {
           [revealController revealToggle:self];
       }

       
   }
    
   else if (row == 3)
   {
       
       if ( ![frontNavigationController.topViewController isKindOfClass:[FICHelpTermAndConditionViewController class]] )
       {
           
           NSString *nibname = [FICCommonUtilities getNibName:@"HelpTandConditions"];
           FICHelpTermAndConditionViewController*  helpTerm = [[FICHelpTermAndConditionViewController alloc]initWithNibName:nibname bundle:nil];
           helpTerm.conditon = TV_LISTINGS;
           UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:helpTerm];
           [revealController pushFrontViewController:navigationController animated:YES];
           helpTerm = nil;
           navigationController = nil;
       }
       else
       {
           FICHelpTermAndConditionViewController* helpTerm = (FICHelpTermAndConditionViewController*)frontNavigationController.topViewController;
           helpTerm.conditon = TV_LISTINGS;
           [helpTerm viewWillAppear:NO];
           [revealController revealToggle:self];
       }
       
   }

	else if (row == 5)
	{
        
        if ( ![frontNavigationController.topViewController isKindOfClass:[FICHelpTermAndConditionViewController class]] )
        {
            
                NSString *nibname = [FICCommonUtilities getNibName:@"HelpTandConditions"];
              FICHelpTermAndConditionViewController*  helpTerm = [[FICHelpTermAndConditionViewController alloc]initWithNibName:nibname bundle:nil];
            helpTerm.conditon = HELP;
                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:helpTerm];
            [revealController pushFrontViewController:navigationController animated:YES];
            helpTerm = nil;
             navigationController = nil;
        }
        else
        {
            FICHelpTermAndConditionViewController* helpTerm = (FICHelpTermAndConditionViewController*)frontNavigationController.topViewController;
            helpTerm.conditon = HELP;
            [helpTerm viewWillAppear:NO];
            [revealController revealToggle:self];
        }

	}
	else if (row == 6)
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[FICHelpTermAndConditionViewController class]] )
        {

        
        NSString *nibname = [FICCommonUtilities getNibName:@"HelpTandConditions"];
        FICHelpTermAndConditionViewController*  helpTerm = [[FICHelpTermAndConditionViewController alloc]initWithNibName:nibname bundle:nil];
        helpTerm.conditon = TERMS_CONDITION;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:helpTerm];
        [revealController pushFrontViewController:navigationController animated:YES];
        helpTerm = nil;
         navigationController = nil;
        }else{
            FICHelpTermAndConditionViewController* helpTerm = (FICHelpTermAndConditionViewController*)frontNavigationController.topViewController;
            helpTerm.conditon = TERMS_CONDITION;
            [helpTerm viewWillAppear:NO];
            [revealController revealToggle:self];
        }
    }
   


}

-(void)loginSuccess{
     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedOut"];
    
     [[NSUserDefaults standardUserDefaults] synchronize];
    if (!text||[text isKindOfClass:[NSNull class]]) {
        [self.subMenuArray replaceObjectAtIndex:3 withObject:@"Logout"];
    }else{
        [self.subMenuArray replaceObjectAtIndex:3 withObject:self.text.txt_menu_logout];
    }
    self.loginViewController = nil;
    [self.rearTableView reloadData];
}

-(void)logoutSuccess{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedOut"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    if (!text||[text isKindOfClass:[NSNull class]]) {
        [self.subMenuArray replaceObjectAtIndex:3 withObject:@"Login"];
    }else{
        [self.subMenuArray replaceObjectAtIndex:3 withObject:self.text.txt_menu_login];
    }
     self.loginViewController = nil;
    [self.rearTableView reloadData];
}



//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}

@end