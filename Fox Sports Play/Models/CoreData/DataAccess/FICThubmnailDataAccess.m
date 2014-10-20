//
//  FICThubmnailDataAccess.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 29/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICThubmnailDataAccess.h"
#import "FICAppDelegate.h"
#import "Thumbnails.h"

@implementation FICThubmnailDataAccess

-(Thumbnails*)processThumbnailData:(NSMutableDictionary*)data context:(NSManagedObjectContext*)context{
    
    
//    FICAppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
//    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    NSManagedObjectContext *_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
//    [_managedObjectContext setParentContext:context];
    
    
//    Thumbnails *thumbnailObject = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"Thumbnails"
//                              inManagedObjectContext:context];
    
    Thumbnails *thumbnailObject = [Thumbnails insertNewObjectIntoContext:context];
    
    thumbnailObject.audioSampleRate = [NSNumber numberWithInt:(int)[data objectForKey:@"audioSampleRate"]];
    thumbnailObject.audoChannels = [NSNumber numberWithInt:(int)[data objectForKey:@"audioChannels"]];
    thumbnailObject.bitrate = [NSNumber numberWithInt:(int)[data objectForKey:@"bitrate"]];
    thumbnailObject.checksums = [NSKeyedArchiver archivedDataWithRootObject:[data objectForKey:@"checksums"]];
    thumbnailObject.contentType = [data objectForKey:@"contentType"];
    thumbnailObject.displayAspectRatio = [data objectForKey:@"displayAspectRatio"];
    thumbnailObject.duration = [NSNumber numberWithInt:(int)[data objectForKey:@"duration"]];
    thumbnailObject.expression = [data objectForKey:@"expression"];
    thumbnailObject.filesize = [NSNumber numberWithInt:(int)[data objectForKey:@"fileSize"]];
    thumbnailObject.format = [data objectForKey:@"format"];
    thumbnailObject.framRate = [NSNumber numberWithInt:(int)[data objectForKey:@"frameRate"]];
    thumbnailObject.height = [NSNumber numberWithInt:(int)[data objectForKey:@"height"]];
    thumbnailObject.isDefault = [NSNumber numberWithInt:(int)[data objectForKey:@"isDefault"]];
    thumbnailObject.language = [data objectForKey:@"language"];
    thumbnailObject.sourceTime = [NSNumber numberWithInt:(int)[data objectForKey:@"sourceTime"]];
    thumbnailObject.url = [data objectForKey:@"url"];
    thumbnailObject.width = [NSNumber numberWithInt:(int)[data objectForKey:@"width"]];
    

    
    return thumbnailObject;
}
@end
