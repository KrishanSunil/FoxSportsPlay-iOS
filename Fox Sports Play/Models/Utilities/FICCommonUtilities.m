//
//  FICCommonUtilities.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 22/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICCommonUtilities.h"
#import "Reachability.h"

@implementation FICCommonUtilities


// Get the nib name based on the device.
+(NSString*)getNibName:(NSString*)name{
    
    NSString *nibName = nil;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        
        nibName = [NSString stringWithFormat:@"%@_iPad",name];
    }else{
    
    nibName = [NSString stringWithFormat:@"%@_iPhone",name];
    }
    
    DLog(@"Class Name : %@ -> MethodName : %@ -> Line No : %d -> NibName : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd),__LINE__,nibName);
    
    return nibName;
}

#pragma mark - Check Internet Connection Availability

+(BOOL)isInternetConnectionAvailable {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    DLog(@"Class Name : %@ -> MethodName : %@ -> Line No : %d -> isInternetRechble : %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd),__LINE__,networkStatus==NotReachable?@"NO":@"YES");
    
    if (networkStatus == NotReachable) {
        
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - Create Folder inside Documents Directory

+(NSString*)createDirectoryInsideDocumentsDirectory:(NSString*)folderName {
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:folderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    return dataPath;
    
    
}

+(void)storeFilesInsideDocuments:(NSString*)folderName fileName:(NSString*)name dataToWrite:(NSData*)data {
    
    NSString* folderPath = [self createDirectoryInsideDocumentsDirectory:folderName];
    
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:name]; //Add the file name
    [data writeToFile:filePath atomically:YES];
    
    filePath = nil;
    folderPath = nil;
    
}

//+(void)storeFilesInsideDocuments:(NSString*)folderName name:(NSString*)name imageData:(NSData*)imageData {
//    
//    NSString* folderPath = [self createDirectoryInsideDocumentsDirectory:folderName];
//    
//    
//    NSString *filePath = [folderPath stringByAppendingPathComponent:name]; //Add the file name
//    [imageData writeToFile:filePath atomically:YES];
//    
//}

+(NSMutableDictionary*)getFileContentFromDirectory:(NSString*)directoryName fileName:(NSString*)fileName {
    
    NSString* folderPath = [self createDirectoryInsideDocumentsDirectory:directoryName];
    
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary *fileData = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    filePath = nil;
    folderPath = nil;
    
    return fileData;
}

+(NSString*)formatDate:(NSString*)dateFormat timeZone:(NSString*)timeZone date:(NSDate*)date{
    
    NSString *returnDate = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timeZone]];
    [dateFormatter setDateFormat:dateFormat];
    
    returnDate = [dateFormatter stringFromDate:date];
    
    dateFormatter = nil;
    
    return returnDate;
}

#pragma mark - Check File Existance

+(BOOL)checkForFileExistance:(NSString*)fileName folderName:(NSString*)folderName {
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:folderName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        return NO;
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return NO;
    
    return YES;
}


#pragma mark - Date Manipulation

-(NSDate*)futureDate:(int)days dateFrom:(NSDate*)currentDate{
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    
    dayComponent = nil;
    theCalendar = nil;
    
    return nextDate;
}

//#pragma mark - calculate date based on time interval
//-()



@end
