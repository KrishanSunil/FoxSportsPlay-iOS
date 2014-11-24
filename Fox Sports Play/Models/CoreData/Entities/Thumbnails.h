//
//  Thumbnails.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 8/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ModelObject.h"

@class Entries;

@interface Thumbnails : ModelObject

@property (nonatomic, retain) NSNumber * audioSampleRate;
@property (nonatomic, retain) NSNumber * audoChannels;
@property (nonatomic, retain) NSNumber * bitrate;
@property (nonatomic, retain) NSData * checksums;
@property (nonatomic, retain) NSString * contentType;
@property (nonatomic, retain) NSString * displayAspectRatio;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * expression;
@property (nonatomic, retain) NSNumber * filesize;
@property (nonatomic, retain) NSString * format;
@property (nonatomic, retain) NSNumber * framRate;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * isDefault;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSNumber * sourceTime;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) Entries *entriesRelationShip;

@end
