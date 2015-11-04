//
//  WBNewfeatureController.m
//  坏境搭载
//
//  Created by uplooking on 15/10/28.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "WBNewfeatureController.h"
#import "WBMainViewController.h"
#import "UIView+Extension.h"
#define ImageCount 4
// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface WBNewfeatureController () <UIScrollViewDelegate>
@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pagecontrol;
@property (nonatomic,weak) UIImageView *imageView;
@end

@implementation WBNewfeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.imageView.userInteractionEnabled = YES;
    //1.创建一个scrollView:显示所有的图片
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    //scrollView.backgroundColor = [UIColor redColor];
   [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    //2.把图片添加到scrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    
    for (int i = 0; i < ImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        self.imageView = imageView;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        if (i == ImageCount -1) {
            [self setupLastImageView:imageView];
        }
    }
    
#warning 默认情况下，scrollView一创建出来，它里面可能就存在一些子控件了
#warning 就算不主动添加子控件到scrollView中，scrollView内部还是可能会有一些子控件
    //3.设置scrollView其他属性
    scrollView.contentSize = CGSizeMake(scrollW * ImageCount, 0);
    scrollView.bounces = NO;// 去除弹簧效果
    scrollView.pagingEnabled = YES;//分页显示
    scrollView.showsHorizontalScrollIndicator = NO;//底部滑动不显示
    scrollView.delegate = self;
    //4.添加分页
    UIPageControl *pagecontrol = [[UIPageControl alloc]init];
    pagecontrol.numberOfPages = ImageCount;
    pagecontrol.currentPageIndicatorTintColor = HWColor(253, 98, 42);
    pagecontrol.pageIndicatorTintColor = HWColor(189, 189, 189);
    pagecontrol.centerX = scrollW *0.5;
    pagecontrol.centerY = scrollH - 50;
    [self.view addSubview:pagecontrol];
    self.pagecontrol = pagecontrol;
}

#pragma -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page =(scrollView.contentOffset.x) / (scrollView.width);
    //四舍五入
    self.pagecontrol.currentPage = (int) (page + 0.5);
}

- (void)setupLastImageView:(UIImageView *) image
{
    //开交互
    self.imageView.userInteractionEnabled = YES;
    //1.分享给大家
    UIButton *shareBtn = [[UIButton alloc]init];
    shareBtn.width = 200;
    shareBtn.height = 30;
    shareBtn.centerY = self.imageView.height * 0.65;
    shareBtn.centerX = self.imageView.width * 0.5;
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0,0,0, 0);
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:shareBtn];
    
    // imageEdgeInsets:只影响按钮内部的imageView
    //    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 50);
    
    
    
    //    shareBtn.titleEdgeInsets
    //    shareBtn.imageEdgeInsets
    //    shareBtn.contentEdgeInsets
    // EdgeInsets: 自切
    // contentEdgeInsets:会影响按钮内部的所有内容（里面的imageView和titleLabel）
    //    shareBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 100, 0, 0);
    
    // titleEdgeInsets:只影响按钮内部的titleLabel
    
    //2.开始微博
    UIButton *starBtn = [[UIButton alloc]init];
    [starBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [starBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [starBtn setTitle:@"开始微博" forState:UIControlStateNormal];
     starBtn.size = starBtn.currentBackgroundImage.size;
    starBtn.centerX = shareBtn.centerX;
    starBtn.centerY = self.imageView.height * 0.73;
    [starBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:starBtn];
    
}

- (void)shareBtnClick:(UIButton *)shareBtn
{   // 状态取反
    shareBtn.selected = !shareBtn.isSelected;
}

- (void)startClick
{ // 切换到HWTabBarController
    /*
     切换控制器的手段
     1.push：依赖于UINavigationController，控制器的切换是可逆的，比如A切换到B，B又可以回到A
     2.modal：控制器的切换是可逆的，比如A切换到B，B又可以回到A
     3.切换window的rootViewController
     */
    UIWindow *window = [UIApplication sharedApplication].keyWindow ;
    window.rootViewController = [[WBMainViewController alloc]init];
    // modal方式，不建议采取：新特性控制器不会销毁
    //    HWTabBarViewController *main = [[HWTabBarViewController alloc] init];
    //    [self presentViewController:main animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
