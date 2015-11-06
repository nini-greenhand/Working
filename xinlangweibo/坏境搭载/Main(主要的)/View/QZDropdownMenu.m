//
//  QZDropdownMenu.m
//  坏境搭载
//
//  Created by uplooking on 15/10/27.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "QZDropdownMenu.h"
#import "UIView+Extension.h"
@interface QZDropdownMenu ()
/**
 *  用来显示具体内容的容器
 */
@property (nonatomic,strong) UIImageView *containerView;

@end
@implementation QZDropdownMenu


- (UIImageView *)containerView
{
    
    if (!_containerView) {
        UIImageView *containerView  = [[UIImageView alloc]init];
        containerView.image = [UIImage imageNamed:@"popover_background"];
        containerView.userInteractionEnabled = YES;
        [self addSubview:containerView];
        self.containerView = containerView;
        
    }
    return _containerView;
}


+ (instancetype)menu
{
    return [[self alloc] init];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //清除颜色
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setContent:(UIView *)content
{
    _content = content;
    // 调整内容的位置
    content.x = 10;
    content.y = 15;
    //设置灰色的宽度
    self.containerView.width = CGRectGetMaxX(content.frame) + 8   ;
    // 设置灰色的高度
    self.containerView.height = CGRectGetMaxY(content.frame) + 10;
     // 添加内容到灰色图片中
    [self.containerView addSubview:content];
   
}
- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    
    self.content = contentController.view;
}
/**
 *  显示
 */
- (void)showFrom:(UIView *)from
{
    //1.获取最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //2.添加自己到窗口上
    [window addSubview:self];
    //3.设置尺寸
    self.frame = window.bounds;
    // 4.调整灰色图片的位置
    // 默认情况下，frame是以父控件左上角为坐标原点
    // 转换坐标系
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    //通知外界自己被被显示了
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidshow:)]) {
        [self.delegate dropdownMenuDidshow:self];
    }
}
/**
 *  销毁
 */  
- (void)dismiss
{
    [self removeFromSuperview];
    
    //通知外界 自己被销毁了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];    
}
@end
