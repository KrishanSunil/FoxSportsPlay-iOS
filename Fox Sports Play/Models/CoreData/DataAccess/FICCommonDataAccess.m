//
//  FICCommonDataAccess.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 3/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICCommonDataAccess.h"
#import "FICAppDelegate.h"

@implementation FICCommonDataAccess


- (void) deleteAllObjects: (NSString *) entityDescription liveVodUpcoming:(EntryLiveVodUpcoming)liveVodUpcoming context:(NSManagedObjectContext*)_managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"livevodupcoming == %@", [NSNumber numberWithInt:liveVodUpcoming]];
    [fetchRequest setPredicate:predicate];

    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];

    
    
    for (NSManagedObject *managedObject in items) {
    	[_managedObjectContext deleteObject:managedObject];
    	DLog(@"%@ object deleted",entityDescription);
    }
    if (![_managedObjectContext save:&error]) {
    	DLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
    _managedObjectContext = nil;

    
    return;
    
    _managedObjectContext = nil;

    
}



@end
