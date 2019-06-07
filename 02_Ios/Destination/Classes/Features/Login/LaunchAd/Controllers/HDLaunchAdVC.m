//
//  NJLaunchAdVC.m
//  Destination
//
//  Created by TouchWorld on 2019/1/18.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HDLaunchAdVC.h"
#import "CYLTabBarControllerConfig.h"
#import "AppDelegate.h"
#import "NJSelectLoginMethodVC.h"
#import "NJNavigationController.h"
#import "NJWebVC.h"
#import "NJLaunchAdItem.h"
#import <MJExtension.h>
#import "CYLPlusButtonSubclass.h"
//#import "HLGuiDangHelper.h"

#define TimeOut 5
@interface HDLaunchAdVC ()
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
- (IBAction)jumpBtnClick:(UIButton *)sender;
/********* 定时器 *********/
@property(nonatomic,strong)dispatch_source_t timer;
- (IBAction)adTapGesture:(UITapGestureRecognizer *)sender;
/********* <#注释#> *********/
@property(nonatomic,strong)NJLaunchAdItem * adItem;
@property (weak, nonatomic) IBOutlet UIImageView *adImageV;


@end

@implementation HDLaunchAdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupInit];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //停止定时器
    [self stopTimer];
}

#pragma mark - 设置初始化
- (void)setupInit{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.jumpBtn addBorderWidth:1.0 color:NJGrayColor(151.0) cornerRadius:15.0];
    [self setupTimer];
//    [self launchAdRequest];
}

#pragma mark - 网络请求
- (void)launchAdRequest{
//    [[NetAPIManager instance] postWithPath:@"changtour/Index/initInfo" parameters:@{@"type":@"2"} finished:^(HDError * _Nullable error, id object, BOOL isLast, id result) {
//
//        if(!error){
//            NSDictionary * dataDic = result[DictionaryKeyData];
//            self.adItem = [NJLaunchAdItem mj_objectWithKeyValues:dataDic];
//            [self.adImageV sd_setImageWithURL:[NSURL URLWithString:self.adItem.img_url]];
//            //储存动态的分享地址
//            [[NSUserDefaults standardUserDefaults] setObject:self.adItem.share_site forKey:@"HLSHAREDONGTAIYUMING"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSDictionary * guidangDiac = self.adItem.version;
//            //归档
////            [HLGuiDangHelper archiverWithObject:guidangDiac fileName:@"guidang"];
//            //解档
////            NSDictionary * jiedangDiac =[HLGuiDangHelper unarchiverWithFileName:@"guidang"];
////            NSLog(@"%@--%@",guidangDiac,jiedangDiac);
//
//        }else{
//
//            HDLog(@"%@", error);
//        }
//        [self startTime];
//    }];
}

#pragma mark - 设置定时器
- (void)setupTimer{
    UIApplication * app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

//启动定时器
- (void)startTime{
    __block int timeout = TimeOut; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    self.timer = _timer;
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self jumpBtnClick:nil];
            });
        }else{
            Dlog(@"时间 = %d", timeout);
//            NSString *strTime = [NSString stringWithFormat:@"发送验证码(%dS)",timeout];
//            NSLog(@"strTime = %@",strTime);
            dispatch_async(dispatch_get_main_queue(), ^{
                //定时过程中的UI处理
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//取消定时器
- (void)stopTimer{
    if(self.timer != nil){
        HDLog(@"取消定时器");
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

#pragma mark - 事件
- (IBAction)jumpBtnClick:(UIButton *)sender {
    Dlog(@"-----------jumpBtnClick------------");
    [self goToNextVC];
}

//跳转到测试页面
- (IBAction)adTapGesture:(UITapGestureRecognizer *)sender {
    if(self.adItem == nil){
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    //广告界面
    NJWebVC * webVC = [[NJWebVC alloc] init];
    webVC.titleStr = self.adItem.title;
    webVC.urlStr = self.adItem.link_url;
    if([NJLoginTool isLogin]){
        [CYLPlusButtonSubclass registerPlusButton];
        CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
        CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
        tabBarController.delegate = appDelegate;
        NJNavigationController *naviVC = (NJNavigationController*)tabBarController.viewControllers.firstObject;
        [naviVC pushViewController:webVC animated:NO];
        [UIView transitionFromView:self.view toView:naviVC.view duration:UIViewAnimationTrantitionTime options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
        }];
    }else{
        NJSelectLoginMethodVC * selectLoginMethodVC = [[NJSelectLoginMethodVC alloc] init];
        NJNavigationController * naviVC = [[NJNavigationController alloc] initWithRootViewController:selectLoginMethodVC];
        [naviVC pushViewController:webVC animated:NO];
        [UIView transitionFromView:self.view toView:naviVC.view duration:UIViewAnimationTrantitionTime options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [UIApplication sharedApplication].keyWindow.rootViewController = naviVC;
        }];
    }
}

#pragma mark - 其他
- (void)dealloc
{
    HDLog(@"%s", __func__);
}

- (void)goToNextVC
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
//    if([NJLoginTool isLogin])
    NSString * token = @"123";//[NJLoginTool getUserToken];
    if(token.length >= 1){
        CYLTabBarControllerConfig * tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
        CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
        tabBarController.delegate = appDelegate;
        [UIView transitionFromView:self.view toView:tabBarController.view duration:UIViewAnimationTrantitionTime options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionCurveEaseInOut completion:^(BOOL finished) {
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
        }];
    }else{
        NJSelectLoginMethodVC * selectLoginMethodVC = [[NJSelectLoginMethodVC alloc] init];
        NJNavigationController * naviVC = [[NJNavigationController alloc] initWithRootViewController:selectLoginMethodVC];
        
        [UIView transitionFromView:self.view toView:naviVC.view duration:UIViewAnimationTrantitionTime options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [UIApplication sharedApplication].keyWindow.rootViewController = naviVC;
        }];
    }
}

@end
