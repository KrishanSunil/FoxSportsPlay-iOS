//
//  FICCategoryDataAccess.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 29/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICCategoryDataAccess.h"
#import "FICAppDelegate.h"
#import "Categories.h"

@implementation FICCategoryDataAccess

-(Categories*)processCategoryData:(NSMutableDictionary*)data context:(NSManagedObjectContext*)context{

    Categories *categoryObject  = [Categories insertNewObjectIntoContext:context];
    

   
    categoryObject.label = [data objectForKey:@"label"];
    categoryObject.name = [data objectForKey:@"name"];
    categoryObject.scheme = [data objectForKey:@"scheme"];
    
    NSMutableArray *mainSubCategories = [[NSMutableArray alloc]initWithArray:[categoryObject.name componentsSeparatedByString:@"/"]];
    
    if (mainSubCategories.count==0||!mainSubCategories) {
        categoryObject.mainCategory = @"";
        categoryObject.subCategory = @"";
        mainSubCategories = nil;
        return categoryObject;
    }
    
    if (mainSubCategories.count>1) {
        categoryObject.mainCategory = mainSubCategories[0];
        categoryObject.subCategory = mainSubCategories[1];
        mainSubCategories = nil;
        return categoryObject;
    }
    
    categoryObject.mainCategory = mainSubCategories[0];
    categoryObject.subCategory = @"";
    
    mainSubCategories = nil;

    
    return categoryObject;
}

-(NSArray*)getDiffrentMainCategories:(NSManagedObjectContext*)context{
    
    
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Categories" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"mainCategory"]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"entriesRelationShip.livevodupcoming == %@ ", [NSNumber numberWithInt:VOD]];
     NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mainCategory" ascending:YES];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    //    [fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"Categories",nil]];
    [fetchRequest setIncludesSubentities:YES];
    
    
    
    
    NSArray *fetchedObject = [context executeFetchRequest:fetchRequest error:&error];
    
    
    
    context = nil;
    fetchRequest = nil;
    entity = nil;
    predicate = nil;
    sortDescriptor = nil;
    return fetchedObject;

    
}

@end
