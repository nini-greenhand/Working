//
//  NSString+Extension.h
//  weibo
//
//  Created by uplooking on 15/11/19.
//  Copyright © 2015年 nini. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;
@end
