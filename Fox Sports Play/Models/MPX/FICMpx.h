//
//  FICMpx.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 23/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FICMpx : NSObject{
   

}

+(NSString*)getHighlightsFeed:(NSString*)url minRange:(int)minRange maxRange:(int)maxRange countryCode:(NSString*)countryCode;
+(NSString*)getLiveFeed:(NSString*)url minRange:(int)minRange maxRange:(int)maxRange availableDate:(NSDate*)availableDate countryCode:(NSString*)countryCode;
+(NSString*)getUpComingFeed:(NSString*)url minRange:(int)minRange maxRange:(int)maxRange fromDate:(NSDate*)fromDate toDate:(NSDate*)toDate countryCode:(NSString*)countryCode ;
@end
