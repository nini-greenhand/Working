//
//  User.m
//  坏境搭载
//
//  Created by Mac on 15/11/7.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "User.h"

@implementation User

//判断用户的等级
- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}
@end
