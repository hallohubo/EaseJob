//
//  AppDelegate.m
//  Destination
//
//  Created by TouchWorld on 2018/9/25.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "AppDelegate.h"
#import "HDViewController.h"
#import "NJNavigationController.h"
#import "CYLPlusButtonSubclass.h"
#import "CYLTabBarControllerConfig.h"
#import <IQKeyboardManager.h>
#import "UIImage+NJImage.h"
//#import <AMapFoundationKit/AMapFoundationKit.h>
#import "FileCacheTool.h"
//#import <AMapLocationKit/AMapLocationKit.h>
#import "NJCommonTool.h"
#import "NJSelectLoginMethodVC.h"
#import "NJLoginTool.h"
#import <ShareSDK/ShareSDK.h>
#import <WXApi.h>
#import "NJPayTool.h"
#import <UMPush/UMessage.h>
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMCommonLog/UMCommonLogManager.h>
#import <UserNotifications/UserNotifications.h>
#import "HDLaunchAdVC.h"

#define AmapApiKey @"e0fea2f98787ad18f09bd070a3ccbdd1"
//微信
#define WeChatAppID @"wx7b6b6511b1eeca1f"
#define WeChatAppSecret @"e04cf764ec954d3c04238937f9f63897"

//QQ
#define QQAppID @"1107916934"
#define QQAppKey @"Lqgli7AKCQAacKFs"

//微博
#define WeiboAppKey @"2817052073"
#define WeiboAppSecret @"da3a055563d1d5472f39e6fec546d7b5"

//友盟
#define UPushAppKey @"5c259275f1f5563368000025"

@interface AppDelegate () <UNUserNotificationCenterDelegate, UITabBarControllerDelegate>
/********* <#注释#> *********/
@property(nonatomic,strong)CYLTabBarController * tabBarController;
/********* 定位管理者 *********/
//@property(nonatomic,strong)AMapLocationManager * locationManager;
/********* 是否首次定位 *********/
@property(nonatomic,assign)BOOL isFirstLocation;

@end

@implementation AppDelegate
//12345

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //1、首先需要再info.plist中添加一项View controller-based status bar appearance为no
    //2、在需要的地方添加代码
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    CYLTabBarController * vc  = [[CYLTabBarController alloc] init];
    [vc hideTabBadgeBackgroundSeparator];
    [self setupInit:launchOptions];
   
    return YES;
}

#pragma mark - 设置初始化
- (void)setupInit:(NSDictionary *)launchOptions
{
    self.isFirstLocation = YES;
    self.oldSelectedIndex = 0;
    
    //设置友盟
    [self setupUMC:launchOptions];
    
    //设置键盘
    [self setupIQKeyboardManager];
    
    //社交分享
    [self setupShareSDK];
    
    //注册微信
    [self setupWeiXin];
    
    //高德地图
//    [self setupAmapKit];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //注册中间按钮
    [CYLPlusButtonSubclass registerPlusButton];
    
//    HDLaunchAdVC * launchAdVC = [[HDLaunchAdVC alloc] init];
//    [self.window setRootViewController:launchAdVC];
//    [self.window makeKeyAndVisible];
    
    if([NJLoginTool isLogin]){
        CYLTabBarControllerConfig * tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
        CYLTabBarController * tabBarController = tabBarControllerConfig.tabBarController;
        tabBarController.delegate = self;
        [self.window setRootViewController:tabBarController];
        [self.window makeKeyAndVisible];
    }else{
        NJSelectLoginMethodVC * selectLoginMethodVC = [[NJSelectLoginMethodVC alloc] init];
        NJNavigationController * naviVC = [[NJNavigationController alloc] initWithRootViewController:selectLoginMethodVC];
        [self.window setRootViewController:naviVC];
        [self.window makeKeyAndVisible];
    }
}
#pragma mark - 设置友盟
- (void)setupUMC:(NSDictionary *)launchOptions
{
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
      //whl
    //友盟调试
    //默认NO(不输出log); 设置为YES, 输出可供调试参考的log信息. 发布产品时必须设置为NO.
    #ifdef DEBUG // 调试
    [UMConfigure setLogEnabled:NO];
    #else // 发布
    [UMConfigure setLogEnabled:NO];
    #endif
    [UMConfigure initWithAppkey:UPushAppKey channel:@"App Store"];
    
    //设置友盟推送
    [self setupUMessage:launchOptions];
    
    //设置友盟统计
    [self setupUAnalytics];
}

#pragma mark - 设置友盟推送
- (void)setupUMessage:(NSDictionary *)launchOptions
{
    [UMessage openDebugMode:NO];
    
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    } else {
        // Fallback on earlier versions
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
        }else{
            
        }
    }];
}

#pragma mark - 友盟统计
- (void)setupUAnalytics
{
    [MobClick setScenarioType:E_UM_NORMAL];
    
    //开启CrashReport收集, 默认YES(开启状态).
    [MobClick setCrashReportEnabled:YES];
}

#pragma mark - 设置键盘
- (void)setupIQKeyboardManager
{
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
}

#pragma mark - 社交分享
- (void)setupShareSDK
{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupWeChatWithAppId:WeChatAppID appSecret:WeChatAppSecret];
        [platformsRegister setupQQWithAppId:QQAppID appkey:QQAppKey];
        [platformsRegister setupSinaWeiboWithAppkey:WeiboAppKey appSecret:WeiboAppKey redirectUrl:@"http://www.sharesdk.cn"];
        
    }];
}

#pragma mark - 注册微信
- (void)setupWeiXin
{
    [WXApi registerApp:WeChatAppID];
}

#pragma mark - 高德地图
//- (void)setupAmapKit
//{
////    cc54d5ddfc847ca03a8188e71419ecae //whl的key
//    [AMapServices sharedServices].apiKey = AmapApiKey;
//    [AMapServices sharedServices].apiKey = @"cc54d5ddfc847ca03a8188e71419ecae";
    
    //定位授权
//    [self requestLocationServicesAuthorization];
    
//}

//- (void)startLocation
//{
//    //定位授权
//    [self requestLocationServicesAuthorization];
//}

#pragma mark - 获取定位授权

//- (void)requestLocationServicesAuthorization
//{
//    [self.locationManager startUpdatingLocation];
//}
//
//- (void)reportLocationServicesAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    if(status == kCLAuthorizationStatusNotDetermined)
//    {
//        //未决定，继续请求授权
//        [self requestLocationServicesAuthorization];
//
//    }
//    else if(status == kCLAuthorizationStatusRestricted)
//    {
//        //受限制，尝试提示然后进入设置页面进行处理（根据API说明一般不会返回该值）
//        [self guideUserOpenAuth];
//
//    }
//    else if(status == kCLAuthorizationStatusDenied)
//    {
//        //拒绝使用，提示是否进入设置页面进行修改
//        [self guideUserOpenAuth];
//
//    }
//    else if(status == kCLAuthorizationStatusAuthorizedWhenInUse)
//    {
//        //授权使用，不做处理
//        [self requestLocationServicesAuthorization];
//    }
//    else if(status == kCLAuthorizationStatusAuthorizedAlways)
//    {
//        //始终使用，不做处理
//        [self requestLocationServicesAuthorization];
//    }
//
//}

- (void)guideUserOpenAuth {
    [LBXAlertAction sayWithTitle:@"定位服务未开启" message:@"请在系统设置中开启服务" buttons:@[@"暂不", @"去设置"] chooseBlock:^(NSInteger buttonIdx) {
        if (buttonIdx == 0)
        {
            
        }
        else
        {
            //进入系统设置页面，APP本身的权限管理页面
            [[NJCommonTool shareInstance] openAppSetting];
        }
    }];
    
}

//#pragma mark - AMapLocationManagerDelegate方法
////定位失败
//- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
//}
//
////连续定位回调函数
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
//{
////    HDLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
////
////    NSString * addressDetail = [NSString stringWithFormat:@"%@.%@", reGeocode.city, reGeocode.POIName];
////    HDLog(@"%@", addressDetail);
//
////    HDLog(@"详细地址：%@", reGeocode.formattedAddress);
//    NSString * city = reGeocode.city;
//    NSString * province = reGeocode.province;
//    if(city != nil && city.length > 0)
//    {
//        //纬度
//        [FileCacheTool cacheObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:NJUserDefaultLocationLatitute];
//
//        //经度
//        [FileCacheTool cacheObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:NJUserDefaultLocationLongitute];
//
//        //地址
//        [FileCacheTool cacheObject:reGeocode.formattedAddress forKey:NJUserDefaultLocationAddress];
//
//        //省份
//        [FileCacheTool cacheObject:province forKey:NJUserDefaultLocationProvince];
//
//        //城市
//        [FileCacheTool cacheObject:city forKey:NJUserDefaultLocationCity];
//    }
//
//    if(city != nil && city > 0)
//    {
//        NSString * userSelectedCity = (NSString *)[FileCacheTool unCacheObjectWithKey:NJUserDefaultUserSelectedCity];
//        if(userSelectedCity != nil && userSelectedCity.length > 0 && ![userSelectedCity isEqualToString:city] && self.isFirstLocation)
//        {
//            self.isFirstLocation = NO;
//            NSString * alertTitle = [NSString stringWithFormat:@"千途定位到您在%@,是否切换?", reGeocode.city];
//            NSString * confirmTitle = [NSString stringWithFormat:@"切换到%@", reGeocode.city];
//            [LBXAlertAction sayWithTitle:alertTitle message:nil buttons:@[@"取消", confirmTitle] chooseBlock:^(NSInteger buttonIdx) {
////                HDLog(@"%ld", buttonIdx);
//                if(buttonIdx == 1){
//                    [FileCacheTool removeCacheObjectWithKey:NJUserDefaultUserSelectedCity];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLocationChange object:nil];
//                }
//            }];
//
//            return;
//        }
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLocationChange object:nil];
//
//}
//
////定位权限状态改变时回调函数
//-(void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    //定位授权
//    [self reportLocationServicesAuthorizationStatus:status];
//}

#pragma mark - UITabBarControllerDelegate方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger currentIndex = [tabBarController.viewControllers indexOfObject:viewController];
    if(currentIndex != self.oldSelectedIndex){
        self.oldSelectedIndex = currentIndex;
        return;
    }
    
    UIViewController * vc = viewController;
    
    //UINavigationController
    if([viewController isKindOfClass:[UINavigationController class]]){
        UINavigationController * naviVC = (UINavigationController *)viewController;
        vc = naviVC.viewControllers.firstObject;
    }
    
    //UITabBarController
    if([vc conformsToProtocol:@protocol(HDViewControllerRefreshProtocol)] && [vc respondsToSelector:@selector(tabBarSelectedVCrefreshView)])
    {
        [vc performSelector:@selector(tabBarSelectedVCrefreshView)];
    }
    
//    HDLog(@"didSelectViewController:%ld", [tabBarController.viewControllers indexOfObject:viewController]);
}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers changed:(BOOL)changed{
    
    
}

#pragma mark - 懒加载
//- (AMapLocationManager *)locationManager
//{
//    if(_locationManager == nil){
//        AMapLocationManager * locationManager = [[AMapLocationManager alloc] init];
//        locationManager.delegate = self;
//        locationManager.locatingWithReGeocode = YES;
//        //定位更新距离
//        locationManager.distanceFilter = 10;
//        _locationManager = locationManager;
//    }
//    return _locationManager;
//}

#pragma mark - 其他
//接收到内存警告
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                                 stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"deviceToken:%@", deviceTokenStr);
    if(![NSString isEmptyString:deviceTokenStr])
    {
        [FileCacheTool cacheObject:deviceTokenStr forKey:NJUserDefaultDeviceToken];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveDeviceToken object:nil];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    HDLog(@"注册DeviceToken失败:%@", error);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    //处理微信通过URL启动App时传递的数据
    return  [WXApi handleOpenURL:url delegate:[NJPayTool shareInstance]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS10之前
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage setAutoAlert:NO];
}

//iOS10之后：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10之后：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台x时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}


@end
