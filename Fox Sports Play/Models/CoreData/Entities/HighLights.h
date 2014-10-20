//
//  HighLights.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 8/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ModelObject.h"
@class Entries;

@interface HighLights : ModelObject

@property (nonatomic, retain) NSNumber * entryCount;
@property (nonatomic, retain) NSNumber * itemsPerPage;
@property (nonatomic, retain) NSNumber * startIndex;
@property (nonatomic, retain) NSNumber * totalResults;
@property (nonatomic, retain) Entries *entriesRelationShip;

@end
