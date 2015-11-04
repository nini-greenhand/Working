//
//  WBNavigationController.m
//  坏境搭载
//
//  Created by uplooking on 15/10/24.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "WBNavigationController.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"

@interface WBNavigationController ()

@end

@implementation WBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize{
    
     // 设置整个项目所有item的主题样式
    UIBarButtonItem *item =  [UIBarButtonItem appearance];
    //设置普通状态
    NSMutableDictionary *texAttrs = [NSMutableDictionary dictionary];
    texAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    texAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:texAttrs forState:UIControlStateNormal];
    
    //设置不可用状态
    
    NSMutableDictionary *disabletexAttrs = [NSMutableDictionary dictionary];
    disabletexAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.6];
    
    disabletexAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:disabletexAttrs forState:UIControlStateDisabled];
//
   
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
    
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more"  highImage:@"navigationbar_more_highlighted"];
    }
    
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
#warning 这里要用self，不是self.navigationController
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

@end
