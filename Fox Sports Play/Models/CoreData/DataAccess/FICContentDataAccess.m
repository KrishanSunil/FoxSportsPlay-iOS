//
//  FICContentDataAccess.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 29/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICContentDataAccess.h"
#import "FICAppDelegate.h"
#import "Content.h"

@implementation FICContentDataAccess

-(Content*)processContentData:(NSMutableDictionary*)data context:(NSManagedObjectContext*)context{
    
    
//    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    NSManagedObjectContext *_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
//    [_managedObjectContext setParentContext:context];
    
//    FICAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    
//    Content *contentObject = [NSEntityDescription
//                                  insertNewObjectForEntityForName:@"Content"
//                                  inManagedObjectContext:context];
    
    Content *contentObject = [Content insertNewObjectIntoContext:context];
    
    contentObject.audioSampleRate = [NSNumber numberWithInt:(int)[data objectForKey:@"audioSampleRate"]];
    contentObject.audoChannels = [NSNumber numberWithInt:(int)[data objectForKey:@"audioChannels"]];
    contentObject.bitrate = [NSNumber numberWithInt:(int)[data objectForKey:@"bitrate"]];
    contentObject.checksums = [NSKeyedArchiver archivedDataWithRootObject:[data objectForKey:@"checksums"]];
    contentObject.contentType = [data objectForKey:@"contentType"];
    contentObject.displayAspectRatio = [data objectForKey:@"displayAspectRatio"];
    contentObject.duration = [NSNumber numberWithInt:(int)[data objectForKey:@"duration"]];
    contentObject.expression = [data objectForKey:@"expression"];
    contentObject.filesize = [NSNumber numberWithInt:(int)[data objectForKey:@"fileSize"]];
    contentObject.format = [data objectForKey:@"format"];
    contentObject.framRate = [NSNumber numberWithInt:(int)[data objectForKey:@"frameRate"]];
    contentObject.height = [NSNumber numberWithInt:(int)[data objectForKey:@"height"]];
    contentObject.isDefault = [NSNumber numberWithInt:(int)[data objectForKey:@"isDefault"]];
    contentObject.language = [data objectForKey:@"language"];
    contentObject.sourceTime = [NSNumber numberWithInt:(int)[data objectForKey:@"sourceTime"]];
    contentObject.url = [data objectForKey:@"url"];
    contentObject.width = [NSNumber numberWithInt:(int)[data objectForKey:@"width"]];
    
    return contentObject;
}
@end
