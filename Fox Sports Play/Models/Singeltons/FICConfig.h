//
//  FICConfig.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 23/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FICConfig : NSObject{
    
}

@property(nonatomic,assign) BOOL isDebugMode;
@property(nonatomic,strong) NSMutableDictionary *languageDictionary;
@property (nonatomic,strong) NSDate *lastUpdatedDate;
@property (nonatomic,strong) NSDate *vodLastUpdatedTime;
@property (nonatomic,strong) NSDate *liveUpComingLastUpdatedTime;

+ (id)sharedManager;

@end
