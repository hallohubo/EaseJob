//
//  NJNavigationController.m
//  SmartCity
//
//  Created by TouchWorld on 2018/3/30.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "NJNavigationController.h"
#import "UIImage+NJImage.h"
#import "UIBarButtonItem+NJItem.h"

@interface NJNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation NJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationBar.translucent = NO;
    
    //设置背景图片和阴影
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //标题属性
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSForegroundColorAttributeName : NJColor(31, 40, 51),
                                                 NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold]
                                                 }];

    //按钮标题颜色
    [self.navigationBar setTintColor:NJGreenColor];
    
    //设置返回按钮图片
    UIImage * backImage = [UIImage imageNamed:@"back-blacknew"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationBar.backIndicatorImage = backImage;
    self.navigationBar.backIndicatorTransitionMaskImage = backImage;
    
    //隐藏返回按钮的文字
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.1], NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.1], NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateHighlighted];
    
   
    self.interactivePopGestureRecognizer.delegate = self;
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //为下一个界面统一设置返回按钮样式
    //判断是否是根控制器
    if(self.childViewControllers.count > 0)
    {
        //为下一个界面统一设置返回按钮样式
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNormalImage:[UIImage imageNamed:@"icon_back_black"] highLightImage:[UIImage imageNamed:@"icon_back_black"] target:self action:@selector(back)];
        
        //隐藏底部TabBar（跳转前才有效）
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //跳转界面
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //不是根控制器，才有左划返回
    return self.childViewControllers.count > 1;
}

@end
