//
//  FICBackgroundProcess.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 27/8/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FICCommonDataAccess.h"
@interface FICBackgroundProcess : NSObject

-(void)getHighlights:(void(^)(NSMutableDictionary *results))success failure:(void(^)(NSError *error))failure liveVodUpcoming:(EntryLiveVodUpcoming)liveVodUpcoming minRange:(int)minRange maxRange:(int)maxRange ;
@end
