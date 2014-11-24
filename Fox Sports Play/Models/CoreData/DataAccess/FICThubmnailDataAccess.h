//
//  FICThubmnailDataAccess.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 29/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Thumbnails.h"
#import "FICCommonDataAccess.h"
@interface FICThubmnailDataAccess : FICCommonDataAccess
-(Thumbnails*)processThumbnailData:(NSMutableDictionary*)data context:(NSManagedObjectContext*)context;
@end
