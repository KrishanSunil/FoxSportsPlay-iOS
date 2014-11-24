//
//  FICLanguagesDataAccess.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 30/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICLanguagesDataAccess.h"
#import "FICAppDelegate.h"
#import "Languages.h"
#import "FICSubLangugesDataAccess.h"

@implementation FICLanguagesDataAccess

-(BOOL)saveDataToLanguages:(NSMutableDictionary*)data{
    
    BOOL isSaved = true;
    
    FICAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *_managedObjectContext = delegate.persistentStack.managedObjectContext;
//    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    
//    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    NSManagedObjectContext *_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
//    [_managedObjectContext setParentContext:context];
    
//    Languages *languages = [NSEntityDescription
//                      insertNewObjectForEntityForName:@"Languages"
//                      inManagedObjectContext:_managedObjectContext];
    
    Languages *languages = [Languages insertNewObjectIntoContext:_managedObjectContext];
    
    languages.version = [NSNumber numberWithInt:(int)[data objectForKey:@"version"]];
    languages.countryCode = [data objectForKey:@"countryCode"];
    

    
    FICSubLangugesDataAccess *subLanguagesAccess = [[FICSubLangugesDataAccess alloc]init];
    
    NSMutableSet *subLanguageSet = [[NSMutableSet alloc]init];
    NSArray *subLanguagesArray = [data objectForKey:@"lang"];
    
    for (NSMutableDictionary *subLanguageDictionary in subLanguagesArray) {
        [subLanguageSet addObject:[subLanguagesAccess processSubLanguagesData:subLanguageDictionary managedObjectContext:_managedObjectContext]];
    }
    
    
    
    languages.subLanguageRelationShip = subLanguageSet;//[NSSet setWithObjects:categoriesSet, nil];
    subLanguagesArray = nil;
    subLanguagesAccess = nil;
    subLanguageSet = nil;
    
    
    
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        
        isSaved = false;
        
        return isSaved;
    }
    
//    NSError *error;
//    if (![_managedObjectContext save:&error])
//    {
//        isSaved = false;
//       return isSaved;
//    }
//    [context performBlock:^{
//        NSError *e = nil;
//        if (![context save:&e])
//        {
//           
//        }
//    }];
//    
//
//    context = nil;
    
    
    return isSaved;
}


-(NSArray*)retriveLanguagesData{
    
    FICAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.persistentStack.managedObjectContext;//[delegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Languages" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObject = [context executeFetchRequest:fetchRequest error:&error];
    
    
    delegate = nil;
    context = nil;
    fetchRequest = nil;
    entity = nil;

    return fetchedObject;
}

-(NSArray*)retriveLanguagesData:(NSString*)countryCode {
    
    FICAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.persistentStack.managedObjectContext;//[delegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Languages" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"countryCode == %@", countryCode];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObject = [context executeFetchRequest:fetchRequest error:&error];
    
    
    delegate = nil;
    context = nil;
    fetchRequest = nil;
    predicate = nil;
    entity = nil;
    
    return fetchedObject;
    
}


@end
