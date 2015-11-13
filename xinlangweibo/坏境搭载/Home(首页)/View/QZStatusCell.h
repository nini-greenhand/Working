//
//  QZStatusCell.h
//  坏境搭载
//
//  Created by uplooking on 15/11/11.
//  Copyright © 2015年 nini. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QZStatusFrame;
@interface QZStatusCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) QZStatusFrame *statusFrame;
@end
