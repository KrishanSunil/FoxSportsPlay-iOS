//
//  SubLanguages.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 8/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ModelObject.h"

@class Texts;

@interface SubLanguages : ModelObject

@property (nonatomic, retain) NSNumber * defaultNumber;
@property (nonatomic, retain) NSString * feed_carousel;
@property (nonatomic, retain) NSString * feed_live;
@property (nonatomic, retain) NSString * feed_upcoming;
@property (nonatomic, retain) NSString * languageCode;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Texts *textRelationShip;

@end
