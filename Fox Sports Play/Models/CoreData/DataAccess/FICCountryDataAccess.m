//
//  FICCountryDataAccess.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 23/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICCountryDataAccess.h"
#import "FICAppDelegate.h"
#import "Country.h"

@implementation FICCountryDataAccess



-(BOOL)saveDataToCountry:(NSMutableDictionary*)data{
    
    BOOL isSaved = true;
    
    FICAppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    NSManagedObjectContext *context = [delegate managedObjectContext];
    
//    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    NSManagedObjectContext *_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
//    [_managedObjectContext setParentContext:context];
    
    Country *countyObject = [Country insertNewObjectIntoContext:delegate.persistentStack.managedObjectContext];
    
//    Country *countyObject = [NSEntityDescription
//                        insertNewObjectForEntityForName:@"Country"
//                        inManagedObjectContext:context];
    countyObject.countryCode = [[data objectForKey:@"countryCode"] lowercaseString];
    countyObject.countryName = [data objectForKey:@"countryName"];
    
    
    NSError *error;
    if (![delegate.persistentStack.managedObjectContext save:&error]) {
        
        isSaved = false;
        
        return isSaved;
    }
    
//    NSError *error;
//    if (![context save:&error])
//    {
//        isSaved = false;
//        return isSaved;
//    }
    

//    context = nil;
    countyObject = nil;
    
    return isSaved;
}

-(NSArray*)retriveCountryData:(NSString*)countryCode{
    
    FICAppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSManagedObjectContext *context = delegate.persistentStack.managedObjectContext;
//    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    NSManagedObjectContext *_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
//    [_managedObjectContext setParentContext:context];
    
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Country" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"countryCode == %@", countryCode];
    [fetchRequest setPredicate:predicate];
    
    
    
    NSArray *fetchedObject = [context executeFetchRequest:fetchRequest error:&error];
    
    
 
    context = nil;
    fetchRequest = nil;
    entity = nil;
    predicate = nil;
    return fetchedObject;
}

-(void)deleteCountry {
    
//    FICAppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSManagedObjectContext *_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [_managedObjectContext setParentContext:context];
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Country" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];

    NSArray *fetchedObject = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *country in fetchedObject) {
        [_managedObjectContext deleteObject:country];
        DLog(@"All Countries Deleted");
    }
    
 
    
    

    if (![_managedObjectContext save:&error])
    {
       
    }
    [context performBlock:^{
        NSError *e = nil;
        if (![context save:&e])
        {
            
        }
    }];
    
  
    context = nil;
    fetchRequest = nil;
    entity = nil;
    
    
}

@end
