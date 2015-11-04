//
//  UIBarButtonItem+Extension.m
//  坏境搭载
//
//  Created by uplooking on 15/10/25.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage{
    
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [Btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [Btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [Btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    Btn.size = Btn.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc]initWithCustomView:Btn];
}
@end
