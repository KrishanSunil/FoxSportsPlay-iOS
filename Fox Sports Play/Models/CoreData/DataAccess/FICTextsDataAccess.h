//
//  FICTextsDataAccess.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 30/7/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texts.h"
#import "FICCommonDataAccess.h"

@interface FICTextsDataAccess : FICCommonDataAccess

-(Texts*)processTextData:(NSMutableDictionary*)data inManagedObjectContext:(NSManagedObjectContext*)context;
@end
