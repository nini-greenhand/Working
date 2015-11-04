//
//  Account.m
//  坏境搭载
//
//  Created by Mac on 15/11/1.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "Account.h"

@implementation Account
+(instancetype)accountWithDict:(NSDictionary *)dict
{
    Account *account = [[Account alloc]init];
    account.access_token = dict[@"access_token"];
    account.uid = dict[@"uid"];
    account.expires_in = dict[@"expires_in"];
    
    return account;
}

@end
