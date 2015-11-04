//
//  AppDelegate.m
//  坏境搭载
//
//  Created by uplooking on 15/10/23.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "AppDelegate.h"
#import "WBMainViewController.h"
#import "WBNewfeatureController.h"
#import "OAuthViewController.h"
#define RandonColor [UIColor colorWithRed: arc4random_uniform(256)/255.0 green: arc4random_uniform(256)/255.0 blue: arc4random_uniform(256)/255.0 alpha:1.0];
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1.新建窗口
    self.window = [[UIWindow alloc]init];
    self.window.frame = [[UIScreen mainScreen]bounds];
    
    self.window.rootViewController = [[OAuthViewController alloc]init];
    
//    NSString * key  = @"CFBundleVersion";
//    
//    //上一个版本
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    
//    //当前的版本号
//    NSString *curentVersion = [NSBundle mainBundle].infoDictionary[key];
//    if ([curentVersion isEqualToString:lastVersion]) {
//        self.window.rootViewController = [[WBMainViewController alloc]init];
//        
//    }else{
//    
//        self.window.rootViewController = [[WBNewfeatureController alloc]init];
//    }
//    
//    //存储在沙盒内
//    [[NSUserDefaults standardUserDefaults] setObject:curentVersion forKey:key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //显示窗口
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
