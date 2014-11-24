//
//  FICAppDelegate.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 22/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICAppDelegate.h"
#import "FICSplashViewController.h"
#import "FICCommonUtilities.h"
#import "FICConfig.h"
#import "NetworkClock.h"
#import "SWRevealViewController.h"
#import "FICLoginViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation FICAppDelegate

//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Crashlytics startWithAPIKey:@"64171d6a9f89ca3d59caa4c83f498de176108591"];
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval secs = [currentDate timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"HomeLiveUpcomingVod"]];
    if (secs>=2*60*60) {
        [self resetDatabase];
    }
    
#ifdef DEBUG
    [[FICConfig sharedManager] setIsDebugMode:NO];
#endif
    
       self.persistentStack = [[PersistentStack alloc] initWithStoreURL:self.storeURL modelURL:self.modelURL];
   
    NSString *nibName = [FICCommonUtilities getNibName:@"SplashView"];
    FICSplashViewController *splashViewController = [[FICSplashViewController alloc]initWithNibName:nibName bundle:nil];
    nibName = nil;
    self.window.rootViewController = splashViewController;
    splashViewController = nil;
   

// ----------------- Google Analytics Integration ------------------------------------------------------------
    
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-41514535-3"];


// -----------------------------------------------------------------------------------------------------------
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{

    [self saveContext];
}

//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    
//    if (![window.rootViewController isKindOfClass:[SWRevealViewController class]]) {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//    SWRevealViewController *rootViewController = (SWRevealViewController*)self.window.rootViewController;
//     UINavigationController *frontNavigationController = (id)rootViewController.frontViewController;
//   
//    if ([(id)frontNavigationController.topViewController isSupportsLandscaper])//Place your condition here
//    {
//        [[frontNavigationController.topViewController view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
//        return UIInterfaceOrientationMaskLandscape;
//        NSLog(@"Landscape");
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}

-(void)resetDatabase {
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Fox_Sports_Play.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
//    [fileManager removeItemAtURL:storeURL error:NULL];
    
    NSError* error = nil;
    [fileManager removeItemAtURL:storeURL error:nil];
    
    return;
    
    if([fileManager fileExistsAtPath:[NSString stringWithContentsOfURL:storeURL encoding:NSASCIIStringEncoding error:&error]])
    {
        [fileManager removeItemAtURL:storeURL error:nil];
    }
    
//    self.managedObjectContext = nil;
//    self.persistentStoreCoordinator = nil;
}

//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//             // Replace this implementation with code to handle the error appropriately.
//             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        } 
//    }
//}
//
//#pragma mark - Core Data stack
//
//// Returns the managed object context for the application.
//// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
//- (NSManagedObjectContext *)managedObjectContext
//{
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        _managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return _managedObjectContext;
//}
//
//// Returns the managed object model for the application.
//// If the model doesn't already exist, it is created from the application's model.
//- (NSManagedObjectModel *)managedObjectModel
//{
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Fox_Sports_Play" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//// Returns the persistent store coordinator for the application.
//// If the coordinator doesn't already exist, it is created and the application's store added to it.
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Fox_Sports_Play.sqlite"];
//    
//    NSError *error = nil;
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        /*
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//         
//         Typical reasons for an error here include:
//         * The persistent store is not accessible;
//         * The schema for the persistent store is incompatible with current managed object model.
//         Check the error message to determine what the actual problem was.
//         
//         
//         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
//         
//         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
//         * Simply deleting the existing store:
//         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
//         
//         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
//         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
//         
//         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
//         
//         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }    
//    
//    return _persistentStoreCoordinator;
//}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)saveContext
{
    NSError *error = nil;
    [self.persistentStack.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"error saving: %@", error.localizedDescription);
    }
}

- (NSURL*)storeURL
{
//    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
//                                                                       inDomain:NSUserDomainMask
//                                                              appropriateForURL:nil
//                                                                         create:YES
//                                                                          error:NULL];
//    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
    
     return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Fox_Sports_Play.sqlite"];
}

- (NSURL*)modelURL
{
//    return [[NSBundle mainBundle] URLForResource:@"Pods" withExtension:@"momd"];
    return [[NSBundle mainBundle] URLForResource:@"Fox_Sports_Play" withExtension:@"momd"];
}

@end
