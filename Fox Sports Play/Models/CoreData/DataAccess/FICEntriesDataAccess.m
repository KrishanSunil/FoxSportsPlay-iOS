//
//  FICEntriesDataAccess.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 29/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICEntriesDataAccess.h"
#import "FICAppDelegate.h"
#import "Entries.h"
#import "FICCategoryDataAccess.h"
#import "FICContentDataAccess.h"
#import "FICThubmnailDataAccess.h"

@interface FICEntriesDataAccess(){
    
    NSManagedObjectContext *managedObjectContext;
}

@property(retain,nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation FICEntriesDataAccess
@synthesize managedObjectContext=_managedObjectContext;

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)context{
    
    if (self=[super init]) {
        self.managedObjectContext = context;
    }
    return self;
}


-(NSArray*)retriveLimitedEntryData:(int)NumberOfEntries liveVodUpcoming:(EntryLiveVodUpcoming)livVodUpcoming context:(NSManagedObjectContext*)context{

   
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:NumberOfEntries];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"livevodupcoming == %@", [NSNumber numberWithInt:(int)livVodUpcoming]];
    [fetchRequest setPredicate:predicate];

    [fetchRequest setIncludesSubentities:YES];

    
    
    
    NSArray *fetchedObject = [context executeFetchRequest:fetchRequest error:&error];
    
    

    context = nil;
    fetchRequest = nil;
    entity = nil;
 
    return fetchedObject;
}


-(NSArray*)retriveDataBasedOnMainCategory:(NSString*)mainCategory liveVodUpcoming:(NSNumber*)liveVodUpcoming context:(NSManagedObjectContext*)context{
    

    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = nil;
    if ([mainCategory isEqualToString:@""]||[mainCategory isKindOfClass:[NSNull class]]) {
        predicate= [NSPredicate predicateWithFormat: @"livevodupcoming == %@ ",liveVodUpcoming];
    }else{
     predicate= [NSPredicate predicateWithFormat: @"livevodupcoming == %@ AND categoriesRelationship.mainCategory CONTAINS[cd] %@", liveVodUpcoming,mainCategory];
    }
    [fetchRequest setPredicate:predicate];

    [fetchRequest setIncludesSubentities:YES];
    
    
    
    
    NSArray *fetchedObject = [context executeFetchRequest:fetchRequest error:&error];
    
    
    
    context = nil;
    fetchRequest = nil;
    entity = nil;
    predicate = nil;
    return fetchedObject;
    
}

-(NSArray*)retriveLiveAndUpcoming:(NSManagedObjectContext*)context{

    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Entries" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = nil;
    
        predicate= [NSPredicate predicateWithFormat: @"livevodupcoming != %@ ",[NSNumber numberWithInt:VOD]];
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"livevodupcoming" ascending:YES];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setIncludesSubentities:YES];
    
    
    
    
    NSArray *fetchedObject = [context executeFetchRequest:fetchRequest error:&error];
    
    
    
    context = nil;
    fetchRequest = nil;
    entity = nil;
    predicate = nil;
    return fetchedObject;
    
}

-(BOOL)saveDataToEntries:(NSMutableDictionary*)data liveVodUpcoming:(EntryLiveVodUpcoming)livVodUpcoming context:(NSManagedObjectContext*)context{
    
    BOOL __block __isSaved = true;
    


    
    Entries *entry = [Entries insertNewObjectIntoContext:context];

    entry.guid = [data objectForKey:@"guid"];
    int timeInteval = [[data objectForKey:@"availableDate"] doubleValue]/1000;
    entry.availableDate = [NSDate dateWithTimeIntervalSince1970:timeInteval];
    int expireTimeInterval = [[data objectForKey:@"expirationDate"] doubleValue]/1000;
    entry.expirationDate = [NSDate dateWithTimeIntervalSince1970:expireTimeInterval];
    entry.entrydescription = [data objectForKey:@"description"];
    entry.title = [data objectForKey:@"title"];
    entry.defaultThumbnailUrl = [data objectForKey:@"defaultThumbnailUrl"];
    entry.livevodupcoming = [NSNumber numberWithInt:(int)livVodUpcoming];
    FICCategoryDataAccess *categoryAccess = [[FICCategoryDataAccess alloc]init];
    
   
    NSArray *cateogriesArray = [data objectForKey:@"categories"];
    
//    for (NSMutableDictionary *categoryDictionary in cateogriesArray) {
//
//        [entry addCategoriesRelationshipObject:[categoryAccess processCategoryData:categoryDictionary context:context]];
//
//
//    }
    
    if (cateogriesArray.count>0) {
        entry.categoriesRelationship = [categoryAccess processCategoryData:cateogriesArray[0] context:context];
    }

    cateogriesArray = nil;
    categoryAccess = nil;

    
    
    FICContentDataAccess *contentDataAccess = [[FICContentDataAccess alloc]init];
   
    NSArray *contentArray = [data objectForKey:@"content"];
  
    
    for (NSMutableDictionary *contentDictionary  in contentArray) {
        [entry addContentRelationshipObject:[contentDataAccess processContentData:contentDictionary context:context]];

    }

    contentArray = nil;
 
    contentDataAccess = nil;
    


    NSError *error;
    if (![context save:&error]) {
        
        __isSaved = false;
        
        return __isSaved;
    }
    
    return __isSaved;
}

@end
