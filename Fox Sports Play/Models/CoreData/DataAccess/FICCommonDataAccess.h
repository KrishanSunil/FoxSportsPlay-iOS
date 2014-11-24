//
//  FICCommonDataAccess.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 3/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    
    LIVE = 0,
    VOD = 1,
    UPCOMING = 2
    
} EntryLiveVodUpcoming;

@interface FICCommonDataAccess : NSObject
- (void) deleteAllObjects: (NSString *) entityDescription liveVodUpcoming:(EntryLiveVodUpcoming)liveVodUpcoming context:(NSManagedObjectContext*)_managedObjectContext;
@end
