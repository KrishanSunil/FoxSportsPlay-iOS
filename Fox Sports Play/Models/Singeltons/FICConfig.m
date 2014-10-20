//
//  FICConfig.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 23/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICConfig.h"

@implementation FICConfig

@synthesize isDebugMode;
@synthesize lastUpdatedDate;

#pragma mark Singleton Methods

+ (id)sharedManager {
   
    static FICConfig *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.isDebugMode = NO;
        self.languageDictionary = [[NSMutableDictionary alloc]init];
        self.lastUpdatedDate = nil;
    }
    return self;
}

-(void)processLanguageDictioany {
    
}


    

@end
