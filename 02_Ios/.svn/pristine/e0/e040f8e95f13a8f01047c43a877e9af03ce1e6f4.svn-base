//
//  NJWebVC.m
//  SmartCity
//
//  Created by TouchWorld on 2018/5/6.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "NJWebVC.h"
#import <WebKit/WebKit.h>

@interface NJWebVC () <WKUIDelegate>

@end

@implementation NJWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置初始化
    [self setupInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - 设置初始化
- (void)setupInit
{
    [self setupNaviBar];
    
    [self setupWebView];
}
#pragma mark - 导航条
- (void)setupNaviBar
{
    self.navigationItem.title = self.titleStr;
}

#pragma mark - webView
- (void)setupWebView
{
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
    WKWebView * webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    webView.UIDelegate = self;
    
    NSURL * url = [NSURL URLWithString:self.urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    
    
}

#pragma mark - WKNavigationDelegate方法
//发送请求前决定是否跳转，并在此拦截拨打电话的URL
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
}
//收到响应后决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    
}

//内容开始加载
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    //无网络(APP第一次启动并且没有得到网络授权时可能也会报错)
    if(error.code == NSURLErrorNotConnectedToInternet)
    {
        
    }
    else if(error.code == NSURLErrorCancelled)
    {
        //-999 上一页面还没加载完，就加载当下一页面，就会报这个错。
    }
    HDLog(@"webView加载失败：%@", error);
}

#pragma mark - WKUIDelegate方法
// 在JS端调用alert函数时(警告弹窗)，会触发此代理方法。
// 通过completionHandler()回调JS
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
}

// JS端调用confirm函数时(确认、取消式弹窗)，会触发此方法
// completionHandler(true)返回结果
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    
}

// JS调用prompt函数(输入框)时回调，
//completionHandler回调结果
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    
}


@end
