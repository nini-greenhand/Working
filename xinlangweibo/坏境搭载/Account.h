//
//  Account.h
//  坏境搭载
//
//  Created by Mac on 15/11/1.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

/**　string	用于调用access_token，接口获取授权后的access token。*/

@property (nonatomic,copy) NSString *access_token;

/**　string	access_token的生命周期，单位是秒数。*/

@property (nonatomic,copy) NSNumber *expires_in;

/**　string	当前授权用户的UID。*/
@property (nonatomic,copy) NSString * uid;

/**　获取asston的时间 */
@property (nonatomic,strong) NSDate * created_time;

/**　用户的昵称 */
@property (nonatomic,copy) NSString *name;
+(instancetype)accountWithDict:(NSDictionary *)dict;
@end
