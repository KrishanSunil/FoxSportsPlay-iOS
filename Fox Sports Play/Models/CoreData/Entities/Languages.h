//
//  Languages.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 8/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ModelObject.h"

@class SubLanguages;

@interface Languages : ModelObject  

@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSSet *subLanguageRelationShip;
@end

@interface Languages (CoreDataGeneratedAccessors)

- (void)addSubLanguageRelationShipObject:(SubLanguages *)value;
- (void)removeSubLanguageRelationShipObject:(SubLanguages *)value;
- (void)addSubLanguageRelationShip:(NSSet *)values;
- (void)removeSubLanguageRelationShip:(NSSet *)values;

@end
