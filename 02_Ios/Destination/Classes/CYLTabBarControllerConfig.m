//
//  CYLTabBarControllerConfig.m
//  CYLTabBarController
//
//  v1.16.0 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//
#import "CYLTabBarControllerConfig.h"
#import <UIKit/UIKit.h>

static CGFloat const CYLTabBarControllerHeight = 49.f;


//View Controllers
#import "HDViewController.h"
#import "NJNavigationController.h"
#import "HDMainVC.h"
#import "HDMissionVC.h"
#import "HDDiscoverVC.h"
#import "HDProfileVC.h"
//#import "NJProfileVC.h"
//#import "HDNearbyVC.h"
//#import "NJHomeVC.h"
//#import "NJDiscoveryFollowVC.h"

@interface CYLTabBarControllerConfig ()<UITabBarControllerDelegate>

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;
/********* 子控制器数据 *********/
@property(nonatomic,strong)NSArray<NSDictionary *> * childVCDatas;
@end

@implementation CYLTabBarControllerConfig

- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(0, -10, 0, 10);//
        UIOffset titlePositionAdjustment = UIOffsetZero;//UIOffsetMake(0, MAXFLOAT);
        UINavigationController *nav_main = [[NJNavigationController alloc] initWithRootViewController:[HDMainVC new]];
        UINavigationController *nav_nearby = [[NJNavigationController alloc] initWithRootViewController:[HDDiscoverVC new]];
        UINavigationController *nav_attention = [[NJNavigationController alloc] initWithRootViewController:[HDMissionVC new]];
        UINavigationController *nav_profile = [[NJNavigationController alloc] initWithRootViewController:[HDProfileVC new]];
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:@[nav_main, nav_nearby, nav_attention, nav_profile] tabBarItemsAttributes:[self getTabBarItemsAttributes] imageInsets:imageInsets titlePositionAdjustment:titlePositionAdjustment context:self.context];
        [self customizeTabBarAppearance:tabBarController];

        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

- (NSArray *)getTabBarItemsAttributes{
    NSDictionary * tabBarItem1Attribute = @{
                                            CYLTabBarItemTitle : @" 首页",
                                            CYLTabBarItemImage : @"tab_main",
                                            CYLTabBarItemSelectedImage : @"tab_mainHi"
                                            };
    NSDictionary * tabBarItem2Attribute = @{
                                            CYLTabBarItemTitle : @"发现",
                                            CYLTabBarItemImage : @"tab_discover",
                                            CYLTabBarItemSelectedImage : @"tab_discoverHi"
                                            };
    NSDictionary * tabBarItem3Attribute = @{
                                            CYLTabBarItemTitle : @"任务",
                                            CYLTabBarItemImage : @"tab_mission",
                                            CYLTabBarItemSelectedImage : @"tab_missionHi"
                                            };
    NSDictionary * tabBarItem4Attribute = @{
                                            CYLTabBarItemTitle : @"我的",
                                            CYLTabBarItemImage : @"tab_me",
                                            CYLTabBarItemSelectedImage : @"tab_meHi"
                                            };
    NSArray * tarBarItemsAttrbutes = @[tabBarItem1Attribute, tabBarItem2Attribute, tabBarItem3Attribute, tabBarItem4Attribute];
    
    return tarBarItemsAttrbutes;
}

///**
// 添加TabBar子控制器
//
// @param childVCName 子控制器类名
// */
- (UIViewController *)addChildViewControllers:(NSString *)childVCName{
    Class childClass = NSClassFromString(childVCName);
    HDViewController * childVC = [[childClass alloc]init];
    childVC.view.backgroundColor = [UIColor whiteColor];
    NJNavigationController * navVC = [[NJNavigationController alloc]init];
    [navVC pushViewController:childVC animated:YES];
    return navVC;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
// CUSTOMIZE YOUR TABBAR APPEARANCE
    // Customize UITabBar height
    // 自定义 TabBar 高度
//    tabBarController.tabBarHeight = CYL_IS_IPHONE_X ? 65 : 49;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    Dlog(@"--customizeTabBarAppearance--");
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
//    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    // set the bar background image
    // 设置背景图片
     UITabBar *tabBarAppearance = [UITabBar appearance];
    
    //FIXED: #196
    
    UIImage *tabBarBackgroundImage = [UIImage imageNamed:@"img_tabbar_bg"];
    CGSize size = [[UIScreen mainScreen] currentMode].size;
    Dlog(@"size = %f, %F", size.width, size.height);
    if (IS_FaceID) {
        Dlog(@"faceid");
        if(IS_IPHONE_Xs_Max){
            
          tabBarBackgroundImage = HDIMAGE(@"is_max_bg");
        }else{
           tabBarBackgroundImage = HDIMAGE(@"img_tabbar_bg_faceid");
        }
       
    }
    if (size.width == 640) {//iPhone5s and iPhone4s等宽度320屏幕
        tabBarBackgroundImage = HDIMAGE(@"img_tabbar_bg_iphone5");
    }
//     UIImage *scanedTabBarBackgroundImage = [[self class] scaleImage:tabBarBackgroundImage toScale:1.0];
    [tabBarAppearance setBackgroundImage:tabBarBackgroundImage];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
//     iOS10 后 需要使用 `-[CYLTabBarController hideTabBadgeBackgroundSeparator]` 见 AppDelegate 类中的演示;
    [tabBarAppearance setShadowImage:[[UIImage alloc] init]];
    [tabBarController.tabBar setShadowImage:[UIImage new]];
    [tabBarController hideTabBadgeBackgroundSeparator];
}

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    CGFloat tabBarHeight = CYLTabBarControllerHeight;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:[[self class] imageWithColor:[UIColor yellowColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width * scaleSize, image.size.height * scaleSize);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 懒加载

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
