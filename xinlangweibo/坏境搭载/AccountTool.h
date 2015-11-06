//
//  AccountTool.h
//  坏境搭载
//
//  Created by uplooking on 15/11/6.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;
@interface AccountTool : NSObject
/**
 *  存储账号信息
 */

+ (void)saveaAccountTool :(Account *)account;


/**
 *  返回账号信息
 * @return 账号模型（如果账号过期，返回nil）
 */
+(Account *)account;

@end
