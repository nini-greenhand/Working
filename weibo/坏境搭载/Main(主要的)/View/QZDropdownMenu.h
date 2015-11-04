//
//  QZDropdownMenu.h
//  坏境搭载
//
//  Created by uplooking on 15/10/27.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QZDropdownMenu;

@protocol  QZDropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(QZDropdownMenu *)menu;
- (void)dropdownMenuDidshow:(QZDropdownMenu *)menu;
@end

@interface QZDropdownMenu : UIView

@property (nonatomic,weak) id <QZDropdownMenuDelegate> delegate;
+ (instancetype)menu;
/**
 *  显示
 *
 *  @param from <#from description#>
 */
- (void)showFrom:(UIView *)from;


/**
 *  销毁
 */
- (void)dismiss;
/**
 *  内容
 */
@property (nonatomic,strong) UIView *content;
/**
 *  内容控制器
 */

@property (nonatomic,strong) UIViewController *contentController;
@end
