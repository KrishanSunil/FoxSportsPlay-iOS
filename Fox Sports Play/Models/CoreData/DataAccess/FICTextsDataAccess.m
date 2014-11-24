//
//  FICTextsDataAccess.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 30/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "FICTextsDataAccess.h"
#import "FICAppDelegate.h"

@implementation FICTextsDataAccess


-(Texts*)processTextData:(NSMutableDictionary*)data inManagedObjectContext:(NSManagedObjectContext*)context{
    
    

    

    Texts *textObject = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"Texts"
                                        inManagedObjectContext:context];
    
    textObject.txt_menu_home = [data objectForKey:@"txt_menu_home"];
    textObject.txt_menu_live = [data objectForKey:@"txt_menu_live"];
    textObject.txt_menu_sports_vod = [data objectForKey:@"txt_menu_sports_vod"];
    textObject.txt_menu_login = [data objectForKey:@"txt_menu_login"];
    textObject.txt_menu_language = [data objectForKey:@"txt_menu_language"];
    textObject.txt_menu_help = [data objectForKey:@"txt_menu_help"];
    textObject.txt_menu_t_and_c = [data objectForKey:@"txt_menu_t_and_c"];
    textObject.txt_menu_logout = [data objectForKey:@"txt_menu_logout"];
    textObject.txt_logging_out = [data objectForKey:@"txt_logging_out"];
    textObject.txt_video_advertisement_loading = [data objectForKey:@"txt_video_advertisement_loading"];
    textObject.txt_video_advertisement_seconds = [data objectForKey:@"txt_video_advertisement_seconds"];
    textObject.txt_video_advertisement_second = [data objectForKey:@"txt_video_advertisement_second"];
    textObject.txt_other_videos = [data objectForKey:@"txt_other_videos"];
    textObject.txt_ok = [data objectForKey:@"txt_ok"];
    textObject.txt_stop = [data objectForKey:@"txt_stop"];
    textObject.txt_retry = [data objectForKey:@"txt_retry"];
    
    textObject.txt_exit = [data objectForKey:@"txt_exit"];
    textObject.txt_exit_due_to_network = [data objectForKey:@"txt_exit_due_to_network"];
    textObject.txt_exit_due_to_geo_block = [data objectForKey:@"txt_exit_due_to_geo_block"];
    textObject.txt_url_problem = [data objectForKey:@"txt_url_problem"];
    textObject.txt_network_problem = [data objectForKey:@"txt_network_problem"];
    textObject.txt_live_not_ready = [data objectForKey:@"txt_live_not_ready"];
    textObject.txt_no_content = [data objectForKey:@"txt_no_content"];
    textObject.txt_dialog_language = [data objectForKey:@"txt_dialog_language"];
    textObject.txt_url_missing = [data objectForKey:@"txt_url_missing"];

    
    return textObject;
}


@end
