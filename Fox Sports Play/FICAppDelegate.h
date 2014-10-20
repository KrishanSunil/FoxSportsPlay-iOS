//
//  FICAppDelegate.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 22/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersistentStack.h"
#import "GAI.h"

@interface FICAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) PersistentStack *persistentStack;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
