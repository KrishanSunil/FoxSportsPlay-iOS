//
//  FICBackgroundProcess.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 27/8/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICBackgroundProcess.h"
#import "FICCommonUtilities.h"
#import "FICLanguagesDataAccess.h"
#import "Languages.h"
#import "SubLanguages.h"
#import "AFHTTPRequestOperationManager.h"
#import "FICMpx.h"
#import "FICConfig.h"
#import "NetworkClock.h"

@implementation FICBackgroundProcess




-(void)downloadImage:(NSString*)imageUrl imageName:(NSString*)imageName folderImageName:(NSString*)folderName{

   
    
    BOOL isExistingFile = [FICCommonUtilities checkForFileExistance:imageName folderName:folderName];
    
    if (isExistingFile) {
        return;
    }

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    
    
    [FICCommonUtilities storeFilesInsideDocuments:folderName fileName:imageName dataToWrite:data];
    
    data = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });

    
}


#pragma mark - Get Feed Block

-(void)getHighlights:(void(^)(NSMutableDictionary *results))success failure:(void(^)(NSError *error))failure liveVodUpcoming:(EntryLiveVodUpcoming)liveVodUpcoming minRange:(int)minRange maxRange:(int)maxRange {
    
    
    //    NSMutableDictionary *existingDictionary = [FICCommonUtilities getFileContentFromDirectory:@"Language" fileName:@"language"];
    //    NSMutableDictionary *languageDictionary = [[existingDictionary objectForKey:@"lang"] objectAtIndex:0];
    NSString *url = nil;//[languageDictionary objectForKey:@"feed_carousel"];
    
    switch (liveVodUpcoming) {
        case VOD:
            url = [[NSUserDefaults standardUserDefaults]valueForKey:@"VOD"];
            break;
        case LIVE:
            url = [[NSUserDefaults standardUserDefaults]valueForKey:@"LIVE"];
            break;
        case UPCOMING:
            url = [[NSUserDefaults standardUserDefaults]valueForKey:@"UPCOMING"];
            break;
            
        default:
            break;
    }
    

    
//    FICLanguagesDataAccess *languagesDataAccess = [[FICLanguagesDataAccess alloc]init];
//    NSArray *languageArray = [languagesDataAccess retriveLanguagesData:[[NSUserDefaults standardUserDefaults] objectForKey:@"CountryCode"]];
//    
//    if (languageArray && [languageArray count]>0) {
//        Languages *language = [languageArray objectAtIndex:0];
//        
//        for (SubLanguages *subLanguages in language.subLanguageRelationShip) {
//            
//            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageCode"] isEqualToString:@""]||[[[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageCode"] isKindOfClass:[NSNull class]]||[subLanguages.languageCode isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageCode"]]) {
//                switch (liveVodUpcoming) {
//                    case VOD:
//                        url = subLanguages.feed_carousel;
//                        break;
//                    case LIVE:
//                        url = subLanguages.feed_live;
//                        break;
//                    case UPCOMING:
//                        url = subLanguages.feed_upcoming;
//                        break;
//                    default:
//                        break;
//                }
////                url = subLanguages.feed_carousel;
//               
//            }
//            
////            if ([subLanguages.languageCode isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageCode"]]) {
////                vodUrl = subLanguages.feed_carousel;
////                
////                break;
////            }
//            
//        }
//        
//    }
    
    FICCommonUtilities *commonUtilities = [[FICCommonUtilities alloc]init];
    
    NSString *fianlUrl = nil;
    
    switch (liveVodUpcoming) {
        case VOD:
            fianlUrl =  [FICMpx getHighlightsFeed:url minRange:1 maxRange:maxRange countryCode:[[NSUserDefaults standardUserDefaults] objectForKey:@"CountryCode"]];
            break;
        case LIVE:
            fianlUrl =  [FICMpx getLiveFeed:url minRange:1 maxRange:13 availableDate:[NetworkClock sharedNetworkClock].networkTime countryCode:[[NSUserDefaults standardUserDefaults] objectForKey:@"CountryCode"]];
            break;
        case UPCOMING:
            fianlUrl = [FICMpx getUpComingFeed:url minRange:1 maxRange:13 fromDate:[NetworkClock sharedNetworkClock].networkTime toDate:[commonUtilities futureDate:10 dateFrom:[NetworkClock sharedNetworkClock].networkTime] countryCode:[[NSUserDefaults standardUserDefaults] objectForKey:@"CountryCode"]];
            break;
        default:
            break;
    }
    
    
    commonUtilities = nil;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:fianlUrl
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
//             DLog(@"JSON: %@", responseObject);
             
             
             [[FICConfig sharedManager] setLastUpdatedDate:[NSDate date]];
             success(responseObject);
//             [self performSelectorInBackground:@selector(success) withObject:responseObject];
             
             
             return;
             
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             DLog(@"Error: %@", error);
             
             failure(error);
             
          
             
             return ;
         }];
}








@end
