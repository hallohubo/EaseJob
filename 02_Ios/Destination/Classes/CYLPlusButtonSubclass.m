//
//  CYLPlusButtonSubclass.m
//  CYLTabBarControllerDemo
//
//  v1.16.0 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 15/10/24.
//  Copyright (c) 2015年 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLPlusButtonSubclass.h"
#import "CYLTabBarController.h"
#import "NJNavigationController.h"
//#import "NJPostVC.h"
//#import "NJDiscoveryItem.h"
#import "NSDate+NJCommonDate.h"
//#import "NJPostTool.h"


//#import "HLShootPopView.h"
#import "SPAlertController.h"
//#import "CYLMineViewController.h"

@interface CYLPlusButtonSubclass ()<UIActionSheetDelegate> {
    CGFloat _buttonImageHeight;
    
}

/********* postTool *********/
//@property(nonatomic,strong)NJPostTool * postTool;

@end

@implementation CYLPlusButtonSubclass

#pragma mark -
#pragma mark - Life Cycle

+ (void)load {
    //请在 `-[AppDelegate application:didFinishLaunchingWithOptions:]` 中进行注册，否则iOS10系统下存在Crash风险。
    //[super registerPlusButton];
}



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

//上下结构的 button
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 控件大小,间距大小
    // 注意：一定要根据项目中的图片去调整下面的0.7和0.9，Demo之所以这么设置，因为demo中的 plusButton 的 icon 不是正方形。
    CGFloat const imageViewEdgeWidth   = self.bounds.size.width * 0.7;
    CGFloat const imageViewEdgeHeight  = imageViewEdgeWidth * 0.9;
    
    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMargin  = (self.bounds.size.height - labelLineHeight - imageViewEdgeHeight) * 0.5;
    
    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdgeHeight * 0.5;
    CGFloat const centerOfTitleLabel = imageViewEdgeHeight  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;
    
    //imageView position 位置
    self.imageView.bounds = CGRectMake(0,0, imageViewEdgeWidth, imageViewEdgeHeight);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    
    //title position 位置
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
}

#pragma mark -
#pragma mark - CYLPlusButtonSubclassing delegate Methods

/*
 *
 Create a custom UIButton with title and add it to the center of our tab bar
 *
 */
//+ (id)plusButton {
//    CYLPlusButtonSubclass *button = [[CYLPlusButtonSubclass alloc] init];
//    UIImage *buttonImage = [UIImage imageNamed:@"icon_home_page_add"];
//    [button setImage:buttonImage forState:UIControlStateNormal];
////    [button setTitle:@"发布" forState:UIControlStateNormal];
////    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
////
////    [button setTitle:@"发布" forState:UIControlStateSelected];
////    [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//
//    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
////    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
//    button.frame = CGRectMake(0.0, 0.0, 94, 108);
////    button.backgroundColor = [UIColor redColor];
//
//    // if you use `+plusChildViewController` , do not addTarget to plusButton.
//    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
/*
 *
 Create a custom UIButton without title and add it to the center of our tab bar
 *
 */
+ (id)plusButton
{

    UIImage *buttonImage = [UIImage imageNamed:@"tab_plus"];
    UIImage *highlightImage = [UIImage imageNamed:@"tab_plus"];

    CYLPlusButtonSubclass* button = [CYLPlusButtonSubclass buttonWithType:UIButtonTypeCustom];
    
//    UIEdgeInsetsMake(CGFloat top , CGFloat left , CGFloat bottom , CGFloat right )
   
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0, 20, buttonImage.size.width, buttonImage.size.height);
//    [button setImageEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setImage:buttonImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

#pragma mark -
#pragma mark - Event Response

- (void)clickPublish {
    
//    HLShootPopView *popView = [[HLShootPopView alloc] initWithTitle:@"" titleList:@[@"发布游记",@"摄影作品"] callBack:^(NSInteger index) {
////        UIResponder * objct = self.nextResponder;
////        while (objct != nil && ![objct isKindOfClass:[UIViewController class]]) {
////            objct = objct.nextResponder;
////        }
////        UIViewController * viewController = (UIViewController *)objct;
//        CYLTabBarController *tabBarController = [self cyl_tabBarController];
//        UIViewController *viewController = tabBarController.selectedViewController;
//        if(index == 1){
//
//                SPAlertController *alertController = [SPAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:SPAlertControllerStyleActionSheet];
//                SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"拍一张" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
//                    CYLTabBarController *tabBarController = [self cyl_tabBarController];
//                    UIViewController *viewController = tabBarController.selectedViewController;
//                    self.postTool.type = 1;
//                 [self.postTool modalPostVC:viewController];
//                }];
//                SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"相册选择" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
//
//                    CYLTabBarController *tabBarController = [self cyl_tabBarController];
//                    UIViewController *viewController = tabBarController.selectedViewController;
//
//                     self.postTool.type = 2;
//                    [self.postTool modalPostVC:viewController];
//                }];
//
//
//                SPAlertAction *action3 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
//
//
//                }];
//            action3.titleColor = YILINGERCOLOR;
//            [alertController addAction:action1];
//            [alertController addAction:action2];
//            [alertController addAction:action3];
//
//
//            [viewController presentViewController:alertController animated:YES completion:^{}];
//
//        }else{
//
//
//            SPAlertController *alertController = [SPAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:SPAlertControllerStyleActionSheet];
//            SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"拍一张" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
//                CYLTabBarController *tabBarController = [self cyl_tabBarController];
//                UIViewController *viewController = tabBarController.selectedViewController;
//            self.postTool.type = 3;
//             [self.postTool modalPostVC:viewController];
//
//            }];
//            SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"相册选择" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
//                    CYLTabBarController *tabBarController = [self cyl_tabBarController];
//                    UIViewController *viewController = tabBarController.selectedViewController;
//
//                    self.postTool.type = 4;
//                    [self.postTool modalPostVC:viewController];
//
//
//            }];
//            SPAlertAction *action3 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
//
//
//            }];
//            action3.titleColor = YILINGERCOLOR;
//            [alertController addAction:action1];
//            [alertController addAction:action2];
//            [alertController addAction:action3];
//             [viewController presentViewController:alertController animated:YES completion:^{}];
//
//        }
//        }];
//    [popView show];
    
    
    
//    CYLTabBarController *tabBarController = [self cyl_tabBarController];
//    UIViewController *viewController = tabBarController.selectedViewController;
//
//    [self.postTool modalPostVC:viewController];
}


#pragma mark - CYLPlusButtonSubclassing

//+ (UIViewController *)plusChildViewController {
//    UIViewController *plusChildViewController = [[UIViewController alloc] init];
//    plusChildViewController.view.backgroundColor = [UIColor redColor];
//    plusChildViewController.navigationItem.title = @"PlusChildViewController";
//    UIViewController *plusChildNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:plusChildViewController];
//    return plusChildNavigationController;
//}
//
+ (NSUInteger)indexOfPlusButtonInTabBar {
    return 2;
}
//
//+ (BOOL)shouldSelectPlusChildViewController {
//    BOOL isSelected = CYLExternPlusButton.selected;
//    if (isSelected) {
//        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"PlusButton is selected");
//    } else {
//        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"PlusButton is not selected");
//    }
//    return YES;
//}

+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
    return  0;
}

+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
    return  17;
}

//+ (NSString *)tabBarContext {
//    return NSStringFromClass([self class]);
//}


#pragma mark - 懒加载
//- (NJPostTool *)postTool
//{
//    if(_postTool == nil)
//    {
//        _postTool = [[NJPostTool alloc] init];
//    }
//    return _postTool;
//}
@end