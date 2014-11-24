//
//  UIView+BlurView.m
//  Fox Sports Play
//
//  Created by Krishantha Sunil on 14/10/14.
//  Copyright (c) 2014 FICSG. All rights reserved.
//

#import "UIView+BlurView.h"

@implementation UIView (BlurView)

-(UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
