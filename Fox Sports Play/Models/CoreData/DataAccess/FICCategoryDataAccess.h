//
//  FICCategoryDataAccess.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 29/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Categories.h"
#import "FICCommonDataAccess.h"

@interface FICCategoryDataAccess : FICCommonDataAccess

-(Categories*)processCategoryData:(NSMutableDictionary*)data context:(NSManagedObjectContext*)context;
-(NSArray*)getDiffrentMainCategories:(NSManagedObjectContext*)context;
@end
