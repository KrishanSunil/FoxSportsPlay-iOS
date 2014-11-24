//
//  FICLanguagesDataAccess.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 30/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FICCommonDataAccess.h"

@interface FICLanguagesDataAccess : FICCommonDataAccess

-(BOOL)saveDataToLanguages:(NSMutableDictionary*)data;
-(NSArray*)retriveLanguagesData;
-(NSArray*)retriveLanguagesData:(NSString*)countryCode;

@end
