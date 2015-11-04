//
//  UIBarButtonItem+Extension.h
//  坏境搭载
//
//  Created by uplooking on 15/10/25.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end
