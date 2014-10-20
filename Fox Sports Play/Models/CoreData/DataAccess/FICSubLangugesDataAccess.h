//
//  FICSubLangugesDataAccess.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 30/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubLanguages.h"
#import "FICCommonDataAccess.h"

@interface FICSubLangugesDataAccess : FICCommonDataAccess


-(SubLanguages*)processSubLanguagesData:(NSMutableDictionary*)data managedObjectContext:(NSManagedObjectContext*)context;

@end
