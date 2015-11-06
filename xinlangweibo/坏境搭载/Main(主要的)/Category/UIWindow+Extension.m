//
//  UIWindow+Extension.m
//  坏境搭载
//
//  Created by uplooking on 15/11/6.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "WBNewfeatureController.h"
#import "WBMainViewController.h"
@implementation UIWindow (Extension)
- (void)switchRootViewController
{
    NSString * key  = @"CFBundleVersion";
    
    //上一个版本
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //当前的版本号
    NSString *curentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([curentVersion isEqualToString:lastVersion]) {// 版本号相同：这次打开和上次打开的是同一个版本
        
        self.rootViewController = [[WBMainViewController alloc]init];
        
    }else{// 这次打开的版本和上一次不一样，显示新特性
        self.rootViewController = [[WBNewfeatureController alloc]init];
    }
    
    //存储在沙盒内
    [[NSUserDefaults standardUserDefaults] setObject:curentVersion forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
