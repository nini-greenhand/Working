//
//  WBTabBar.h
//  坏境搭载
//
//  Created by uplooking on 15/10/27.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBTabBar;
#warning 因为HWTabBar继承自UITabBar，所以称为HWTabBar的代理，也必须实现UITabBar的代理协议
@protocol WBTabBarDelegate  <UITabBarDelegate>

- (void)tabBarDidClickPlusButton: (WBTabBar *)tabBar;
@end

@interface WBTabBar : UITabBar
@property (nonatomic,weak) id <WBTabBarDelegate> delagate;
@end
