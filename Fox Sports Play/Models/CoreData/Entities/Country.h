//
//  Country.h
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 8/9/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ModelObject.h"

@interface Country : ModelObject   

@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSString * countryName;

@end
