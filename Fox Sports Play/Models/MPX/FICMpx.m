//
//  FICMpx.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 23/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICMpx.h"
#import "FICCommonUtilities.h"
#import "NetworkClock.h"

#define dateFormate @"yyyy-MM-dd'T'HH:mm:ss"

@interface FICMpx() {
    
}

@end

@implementation FICMpx

//Get VOD Feed Url
+(NSString*)getHighlightsFeed:(NSString*)url minRange:(int)minRange maxRange:(int)maxRange countryCode:(NSString*)countryCode {
    
    NSString *highlightsFeedUrl = nil;
    NSString *urlWithRange = [NSString stringWithFormat:FOX_HIGHLIGHTS_FEED,minRange,maxRange];
    if ([url length]>0 && ![url isKindOfClass:[NSNull class]]) {
        
        highlightsFeedUrl = [NSString stringWithFormat:@"%@%@",url,urlWithRange];
    }else{
        highlightsFeedUrl = [NSString stringWithFormat:FOX_HIGHLIGHTS_FEED_EMPTY,[countryCode lowercaseString],urlWithRange];
    }
    
    urlWithRange = nil;
    
    DLog(@"HIGHLIGHTS FEED Url : %@",highlightsFeedUrl);
    
    NSString *returnUrl=[highlightsFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    highlightsFeedUrl = nil;
    
    return returnUrl;
}


//Get Live Feed Url
+(NSString*)getLiveFeed:(NSString*)url minRange:(int)minRange maxRange:(int)maxRange availableDate:(NSDate*)availableDate countryCode:(NSString*)countryCode {
    
    NSString *liveFeedUrl = nil;
    
    
    NSString *urlWithParameters  = [NSString stringWithFormat:FOX_LIVE_FEED,minRange,maxRange,[FICCommonUtilities formatDate:dateFormate timeZone:@"UTC" date:availableDate]];
    
    if ([url length]>0 && [url isKindOfClass:[NSNull class]]) {
        
        liveFeedUrl =  [NSString stringWithFormat:@"%@%@",url,urlWithParameters];
    }else {
        liveFeedUrl =  [NSString stringWithFormat:FOX_LIVE_FEED_EMPTY,[countryCode lowercaseString],urlWithParameters];
    }
    
    urlWithParameters = nil;

    
    DLog(@"Live Feed Url : %@",liveFeedUrl);
    
    NSString *returnUrl=[liveFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    liveFeedUrl = nil;
    
    DLog(@"Live Feed Url : %@",returnUrl);
    
    return returnUrl;
    
    
}



//Get Upcoming Feed Url
+(NSString*)getUpComingFeed:(NSString*)url minRange:(int)minRange maxRange:(int)maxRange fromDate:(NSDate*)fromDate toDate:(NSDate*)toDate countryCode:(NSString*)countryCode {
    
    NSString *upComingFeedUrl = nil;
    
   
    
    NSString *urlWithParameters  = [NSString stringWithFormat:FOX_UPCOMING_FEED,minRange,maxRange,[FICCommonUtilities formatDate:dateFormate timeZone:@"UTC" date:fromDate],[FICCommonUtilities formatDate:dateFormate timeZone:@"UTC" date:toDate]];
    
    if ([url length]>0 && [url isKindOfClass:[NSNull class]]) {
        
        upComingFeedUrl =  [NSString stringWithFormat:@"%@%@",url,urlWithParameters];
    }else {
        upComingFeedUrl =  [NSString stringWithFormat:FOX_UPCOMING_FEED_EMPTY,[countryCode lowercaseString],urlWithParameters];
    }
    
    urlWithParameters = nil;
    
    
    DLog(@"upComing Feed Url : %@",upComingFeedUrl);
    
   
    
    NSString *returnUrl=[upComingFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    upComingFeedUrl = nil;
    
    DLog(@"upComing Feed Url : %@",returnUrl);
    
    return returnUrl;
    
    
}







@end
