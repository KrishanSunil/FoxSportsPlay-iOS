//
//  Constants.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 23/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#ifndef Fox_Sports_Play_Constants_h
#define Fox_Sports_Play_Constants_h

#define FOX_LOCATION_SERVICE        @"http://apps.foxsportsasia.com/geo-lookup/getGeoByIPJson.php"
#define FOX_LANGUAGE_PATH_LIVE      @"http://apps.foxsportsasia.com/android/config/"
#define FOX_LANGUAGE_PATH_DEBUG     @"http://122.248.203.231/fic/foxsports/languages/"
#define FOX_HIGHLIGHTS_FEED         @"?form=cjson&byApproved=true&count=true&range=%i-%i&fields=plmedia:defaultThumbnailUrl,guid,title,description,media:category,content,thumbnails,categories,availableDate,expirationDate&defaultThumbnailAssetType=home_HL"
#define FOX_HIGHLIGHTS_FEED_EMPTY @"http://feed.theplatform.com/f/ZwuVLC/%@_vod%@"

#define FOX_LIVE_FEED_EMPTY         @"http://feed.theplatform.com/f/ZwuVLC/%@_live%@"

#define FOX_LIVE_FEED               @"?form=cjson&byApproved=true&count=true&range=%i-%i&sort=availableDate|ASC&fields=plmedia:defaultThumbnailUrl,guid,title,description,media:category,content,thumbnails,categories,availableDate&defaultThumbnailAssetType=home_Thumb&byAvailableDate=~%@"


#define FOX_UPCOMING_FEED           @"?form=cjson&byApproved=true&count=true&range=%i-%i&sort=availableDate|ASC&fields=plmedia:defaultThumbnailUrl,guid,title,description,media:category,content,thumbnails,categories,availableDate&defaultThumbnailAssetType=home_Thumb&byAvailableDate=%@~%@"

#define FOX_UPCOMING_FEED_EMPTY     @"http://feed.theplatform.com/f/ZwuVLC/%@_all_media%@"
#endif
