//
//  FICCountryDataAccess.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 23/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FICCommonDataAccess.h"

@interface FICCountryDataAccess : FICCommonDataAccess



-(BOOL)saveDataToCountry:(NSMutableDictionary*)data;
-(NSArray*)retriveCountryData:(NSString*)countryCode;
-(void)deleteCountry;


@end
