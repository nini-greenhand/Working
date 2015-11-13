//
//  OAuthViewController.m
//  坏境搭载
//
//  Created by Mac on 15/10/31.
//  Copyright (c) 2015年 nini. All rights reserved.
//

#import "OAuthViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "Account.h"
#import "AccountTool.h"
#import "UIWindow+Extension.h"

#define AuthorizeBaseUrl @"https://api.weibo.com/oauth2/authorize"
#define Client_id     @"3759665480"
#define Redirect_uri  @"http://www.baidu.com"
#define Client_secret @"bb6b98826c3d03052b670d8d5c1f029b"

@interface OAuthViewController ()<UIWebViewDelegate>

@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建一个WebView
    UIWebView *webview = [[UIWebView alloc]init];
    webview.frame = self.view.bounds;
    webview.delegate = self;
    [self.view addSubview:webview];
    
    
    NSString *baseUrl = @"https://api.weibo.com/oauth2/authorize";
    NSString *client_id = @"3759665480";
    NSString *redirect_uri = @"http://www.baidu.com";
    // 拼接URL字符串
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",baseUrl,client_id,redirect_uri];
    
    // 创建URL
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 加载请求
    [webview loadRequest:request];

}

#pragma mark -UIWebView代理
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 提示用户正在加载...
    [MBProgressHUD showMessage:@"正在加载..."];
}

// webview加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

//  webview加载失败的时候调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

// 拦截webView请求
// 当Webview需要加载一个请求的时候，就会调用这个方法，询问下是否请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;
    
    // 获取code(RequestToken)
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length) { // 有code=
        
        // code=81524df3190ea6e58e33c9a0eba1ac56
        // 0 + length
        
        NSString *code = [urlStr substringFromIndex:range.location + range.length];
        // 换取accessToken
        [self accessTokenWithCode:code];
        
        // 不会去加载回调界面
        return NO;
        
    }
    
    return YES;
}
#pragma mark - 换取accessToken
- (void)accessTokenWithCode:(NSString *)code
{
    // 发送Post请求
    
    // 创建请求管理者:请求和解析
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = Client_id;
    params[@"client_secret"] = Client_secret;
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = Redirect_uri;
    
    // 1,发送post请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) { // 请求成功的时候调用
    
    // 2,将返回的账号字典数据 --> 模型，存进沙盒
    Account *account = [Account accountWithDict:responseObject];
    
    //3,存储账号信息
    [AccountTool saveaAccountTool:account];
    
        
    //4.切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window switchRootViewController];

       // NSLog(@"%@",responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败的时候调用
        
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
    }];
}
@end

/*
 必选	类型及范围	说明
 client_id	true	string	申请应用时分配的AppKey。
 client_secret	true	string	申请应用时分配的AppSecret。
 grant_type	true	string	请求的类型，填写authorization_code
 
 grant_type为authorization_code时
 必选	类型及范围	说明
 code	true	string	调用authorize获得的code值。
 redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。
 
 */

