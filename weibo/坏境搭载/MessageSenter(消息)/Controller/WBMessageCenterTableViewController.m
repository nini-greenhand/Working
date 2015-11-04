//
//  WBMessageCenterTableViewController.m
//  坏境搭载
//
//  Created by uplooking on 15/10/24.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "WBMessageCenterTableViewController.h"
#import "Test1ViewController.h"

@interface WBMessageCenterTableViewController ()

@end

@implementation WBMessageCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // style : 这个参数是用来设置背景的，在iOS7之前效果比较明显, iOS7中没有任何效果
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
   // self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)composeMsg {
   NSLog(@"composeMsg");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"test-message%ld",indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Test1ViewController *test1 = [[Test1ViewController alloc]init];
    
    test1.title = @"测试页面";
    [self.navigationController pushViewController:test1 animated:YES];
}
@end
