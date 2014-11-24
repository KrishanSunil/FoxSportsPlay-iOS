//
//  FICEntriesDataAccess.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 29/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FICCommonDataAccess.h"

@interface FICEntriesDataAccess : FICCommonDataAccess

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)context;
-(NSArray*)retriveLiveAndUpcoming:(NSManagedObjectContext*)context;
-(BOOL)saveDataToEntries:(NSMutableDictionary*)data liveVodUpcoming:(EntryLiveVodUpcoming)livVodUpcoming context:(NSManagedObjectContext*)context;
-(NSArray*)retriveLimitedEntryData:(int)NumberOfEntries liveVodUpcoming:(EntryLiveVodUpcoming)livVodUpcoming context:(NSManagedObjectContext*)context;
-(NSArray*)retriveDataBasedOnMainCategory:(NSString*)mainCategory liveVodUpcoming:(NSNumber*)liveVodUpcoming context:(NSManagedObjectContext*)context;
@end
