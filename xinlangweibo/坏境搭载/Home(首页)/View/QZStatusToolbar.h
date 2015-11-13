//
//  QZStatusToolbar.h
//  坏境搭载
//
//  Created by uplooking on 15/11/12.
//  Copyright © 2015年 nini. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;
@interface QZStatusToolbar : UIView
+ (instancetype)toolbar;
@property (nonatomic, strong) Status *status;
@end
