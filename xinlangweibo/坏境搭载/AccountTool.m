//
//  AccountTool.m
//  坏境搭载
//
//  Created by uplooking on 15/11/6.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "AccountTool.h"
#import "Account.h"
//沙盒路径:
#define Accountpath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation AccountTool
/**
 *  存储账号信息
 */
+ (void)saveaAccountTool:(Account *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
  [NSKeyedArchiver archiveRootObject:account toFile:Accountpath];
}
/**
 *  返回账号信息
 * @return 账号模型（如果账号过期，返回nil）
 */
+(Account *)account
{   //加载模型
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:Accountpath];
    /*验证账号是否过期*/
    
    //过期的秒数
     long long expires_in = [account.expires_in longLongValue];
    //获得过期的时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    //获取当前的时
    NSDate *now = [NSDate date];
    
    NSComparisonResult result = [expiresTime compare:now];
    //NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
    // 如果expiresTime <= now，过期
    /**
     NSOrderedAscending = -1L, 升序，右边 > 左边
     NSOrderedSame, 一样
     NSOrderedDescending 降序，右边 < 左边
     */
    if (result != NSOrderedDescending) {
        return nil;
    }
    return account;
}
@end
