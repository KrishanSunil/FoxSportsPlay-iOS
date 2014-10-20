//
//  Entries.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 14/10/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ModelObject.h"
#import "Content.h"
#import "Categories.h"
@class   Thumbnails;

@interface Entries : ModelObject

@property (nonatomic, retain) NSDate * availableDate;
@property (nonatomic, retain) NSString * defaultThumbnailUrl;
@property (nonatomic, retain) NSString * entrydescription;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSNumber * livevodupcoming;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * expirationDate;
@property (nonatomic, retain) Categories *categoriesRelationship;
@property (nonatomic, retain) NSSet *contentRelationship;
@property (nonatomic, retain) NSSet *thumbnailsRelationship;
@end

@interface Entries (CoreDataGeneratedAccessors)

- (void)addContentRelationshipObject:(Content *)value;
- (void)removeContentRelationshipObject:(Content *)value;
- (void)addContentRelationship:(NSSet *)values;
- (void)removeContentRelationship:(NSSet *)values;

- (void)addThumbnailsRelationshipObject:(Thumbnails *)value;
- (void)removeThumbnailsRelationshipObject:(Thumbnails *)value;
- (void)addThumbnailsRelationship:(NSSet *)values;
- (void)removeThumbnailsRelationship:(NSSet *)values;

@end
