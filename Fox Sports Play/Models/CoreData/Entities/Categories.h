//
//  Categories.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 29/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ModelObject.h"

@class Entries;

@interface Categories : ModelObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * mainCategory;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * scheme;
@property (nonatomic, retain) NSString * subCategory;
@property (nonatomic, retain) Entries *entriesRelationShip;

@end
