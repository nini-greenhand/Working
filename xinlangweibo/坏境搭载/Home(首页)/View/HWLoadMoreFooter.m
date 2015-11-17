//
//  HWLoadMoreFooter.m
//  Created by uplooking on 15/10/24.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "HWLoadMoreFooter.h"

@implementation HWLoadMoreFooter
+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HWLoadMoreFooter" owner:nil options:nil] lastObject];
}

@end
