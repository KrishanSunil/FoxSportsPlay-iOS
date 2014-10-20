//
//  FICSubLangugesDataAccess.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 30/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICSubLangugesDataAccess.h"
#import "SubLanguages.h"
#import "FICAppDelegate.h"
#import "FICTextsDataAccess.h"

@implementation FICSubLangugesDataAccess

-(SubLanguages*)processSubLanguagesData:(NSMutableDictionary*)data managedObjectContext:(NSManagedObjectContext*)context{
    
    
//    FICAppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    

    SubLanguages *subLanguagesObject = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"SubLanguages"
                                   inManagedObjectContext:context];
    
    subLanguagesObject.languageCode = [data objectForKey:@"languageCode"];
    subLanguagesObject.title = [data objectForKey:@"title"];
    subLanguagesObject.defaultNumber = [NSNumber numberWithInt:(int)[data objectForKey:@"default"]];
    subLanguagesObject.feed_carousel = [data objectForKey:@"feed_carousel"];
    
    [[NSUserDefaults standardUserDefaults] setValue:[data objectForKey:@"feed_carousel"] forKey:@"VOD"];
    subLanguagesObject.feed_live = [data objectForKey:@"feed_live"];
    
    [[NSUserDefaults standardUserDefaults] setValue:[data objectForKey:@"feed_live"] forKey:@"LIVE"];
   
    subLanguagesObject.feed_upcoming = [data objectForKey:@"feed_upcoming"];
    [[NSUserDefaults standardUserDefaults] setValue:[data objectForKey:@"feed_upcoming"] forKey:@"UPCOMING"];
    
    NSMutableDictionary *textDictionary = [data objectForKey:@"lang"];
    
    FICTextsDataAccess *textDataAccess  = [[FICTextsDataAccess  alloc]init];
    
    subLanguagesObject.textRelationShip = [textDataAccess processTextData:textDictionary inManagedObjectContext:context];
    
    

    return subLanguagesObject;
}


@end
