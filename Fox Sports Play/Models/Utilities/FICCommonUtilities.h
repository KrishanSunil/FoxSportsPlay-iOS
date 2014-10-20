//
//  FICCommonUtilities.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 22/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FICCommonUtilities : NSObject


+(NSString*)getNibName:(NSString*)name;
+(BOOL)isInternetConnectionAvailable;
+(void)storeFilesInsideDocuments:(NSString*)folderName fileName:(NSString*)name dataToWrite:(NSData*)data;
+(NSMutableDictionary*)getFileContentFromDirectory:(NSString*)directoryName fileName:(NSString*)fileName;
+(NSString*)formatDate:(NSString*)dateFormat timeZone:(NSString*)timeZone date:(NSDate*)date;
+(BOOL)checkForFileExistance:(NSString*)fileName folderName:(NSString*)folderName;
-(NSDate*)futureDate:(int)days dateFrom:(NSDate*)currentDate;
@end
