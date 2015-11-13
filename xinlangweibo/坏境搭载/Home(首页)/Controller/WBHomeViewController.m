 //
//  WBHomeViewController.m
//  坏境搭载
//
//  Created by uplooking on 15/10/24.
//  Copyright (c) 2015年 nini. All rights reserved.
//
#import "UIView+Extension.h"
#import "WBHomeViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "QZDropdownMenu.h"
#import "HWTitleMenuViewController.h"
#import "AFNetworking.h"
#import "Account.h"
#import "AccountTool.h"
#import "QZTitleButton.h"
#import "Status.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "HWLoadMoreFooter.h"
#import "QZStatusCell.h"
#import "QZStatusFrame.h"

#ifdef DEBUG // 处于开发阶段
#define HWLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define HWLog(...)
#endif

// cell之间的间距
#define HWStatusCellMargin 15
// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface WBHomeViewController () <QZDropdownMenuDelegate>
/**
 *  微博数组（里面放的都是QZStatusFrame，一个QZStatusFrame对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;

@end

@implementation WBHomeViewController


- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = HWColor(211, 211, 211);
    
    //self.tableView.contentInset = UIEdgeInsetsMake(HWStatusCellMargin, 0, 0, 0);
     /* 设置导航栏上面的内容 */
    [self setupNav];
    
    /* 获取用户的昵称*/
    [self setupUserInfo];
    
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    //集成上拉刷新控件
    [self setupUPRefresh];
    
    //获得未读数
    
     NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60
 target:self selector:@selector(setUPreadCount) userInfo:nil repeats:YES];
    
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
}

/**
 *  获得未读数
 */

- (void)setUPreadCount
{
    HWLog(@"setupUnreadCount");
    //    return;
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 微博的未读数
        //        int status = [responseObject[@"status"] intValue];
        // 设置提醒数字
        //        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", status];
        
        // @20 --> @"20"
        // NSNumber --> NSString
        // 设置提醒数字(微博的未读数)
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            //应用图标显示微博数量
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
           
            
        } else { // 非0情况
            self.tabBarItem.badgeValue = status;
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.integerValue;
            HWLog(@"应用图标显示%ld",(long)status.integerValue);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HWLog(@"请求失败-%@", error);
    }];
}


/**
 *  集成上拉刷新控件
 */
- (void)setupUPRefresh
{
    HWLoadMoreFooter *footer = [HWLoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}


/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    // 1.添加刷新控件
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    // 只有用户通过手动下拉刷新，才会触发UIControlEventValueChanged事件
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:control];
    // 2.马上进入刷新状态(仅仅是显示刷新状态，并不会触发UIControlEventValueChanged事件)
    [control beginRefreshing];
    
    // 3.马上加载数据
    [self refreshStateChange:control];
}

/**
 *  将HWStatus模型转为HWStatusFrame模型
 */
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (Status *status in statuses) {
        QZStatusFrame *f = [[QZStatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}


/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
- (void)refreshStateChange:(UIRefreshControl *)control
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    //    params[@"count"] = @10;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    QZStatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        HWLog(@"微博数据");
      
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [Status objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将 Status数组 转为 QZStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
       
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
       [self.statusFrames insertObjects:newFrames atIndexes:set];
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新刷新
        [control endRefreshing];
        
        // 显示最新微博的数量

        [self showNewStatusCount:newStatuses.count];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HWLog(@"请求失败-%@", error);
        // 结束刷新刷新
        [control endRefreshing];
    }];
}


/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    QZStatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [Status objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将 Status数组 转为 StatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HWLog(@"请求失败-%@", error);
        
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];
}


/**
 *  显示最新微博的数量
 *
 *  @param count 最新微博的数量
 */
- (void)showNewStatusCount:(NSUInteger)count
{
    // 刷新成功(清空图标数字)
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    // 2.设置其他属性
    if (count == 0) {
        label.text = @"没有新的微博数据，稍后再试";
    } else {
        label.text = [NSString stringWithFormat:@"共有%lu条新的微博数据", (unsigned long)count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 3.添加
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 1.0; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        //        label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            //            label.y -= label.height;
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}


/**
 *  获得用户信息（昵称）
 */
- (void)setupUserInfo
{
    //https://api.weibo.com/2/users/show.json
    //access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    //uid	  false	 int64	需要查询的用户ID。
    
    //1、创建发送中心
    AFHTTPRequestOperationManager *mager = [AFHTTPRequestOperationManager manager];

    //2.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
        [mager GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HWLog(@"获取昵称success");
        //设置标题
            UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        //设置名字
            NSString *name = responseObject[@"name"];
            [titleButton setTitle:name forState:UIControlStateNormal];
        //存储到沙盒中
            account.name = name;
            [AccountTool saveaAccountTool:account];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        HWLog(@"请求失败");
    }];
    
}

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    //中间的按钮的标题
    QZTitleButton *titleButton = [[QZTitleButton alloc]init];
    
    //设置标题的文字
    NSString *name = [AccountTool account].name;
    
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    //标题点击
     [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.titleView = titleButton;
    

}

/**
 *  标题点击
 */
- (void)titleClick:(UIButton *)titleButton
{    //创建菜单
    QZDropdownMenu *menu = [QZDropdownMenu menu];
    // 设置内容
    HWTitleMenuViewController *vc = [[HWTitleMenuViewController alloc] init];
    //遵循代理
    menu.delegate = self;
    vc.view.height = 200;
    vc.view.width = 150;
    menu.contentController = vc;
    //显示
    [menu showFrom:titleButton];
    
}
- (void)friendSearch
{
    HWLog(@"friendSearch");
}

- (void)pop
{
    HWLog(@"pop");
}

#pragma mark - HWDropdownMenuDelegate
- (void)dropdownMenuDidDismiss:(QZDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
    // 让箭头向下
    //    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}

- (void)dropdownMenuDidshow:(QZDropdownMenu *)menu
{
    //其中的一种方法，另一种方式是获取 titleButton的属性来操作
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//     QZDropdownMenu *menu = [QZDropdownMenu menu];
//    [menu dismiss];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   //获得cell
    QZStatusCell *cell = [QZStatusCell cellWithTableView:tableView];
    
    // 给cell传递模型数据
    cell.statusFrame = self.statusFrames[indexPath.row];
    // 取出这条微博的作者（用户）
    //    NSDictionary *user = status[@"user"];
    //    cell.textLabel.text = user[@"name"];
    
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0|| self.tableView.tableFooterView.isHidden == NO) return;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        
        // 加载更多的微博数据
        [self loadMoreStatus];
    }
    
    /*
     contentInset：除具体内容以外的边框尺寸
     contentSize: 里面的具体内容（header、cell、footer），除掉contentInset以外的尺寸
     contentOffset:
     1.它可以用来判断scrollView滚动到什么位置
     2.指scrollView的内容超出了scrollView顶部的距离（除掉contentInset以外的尺寸）
     */

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QZStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
