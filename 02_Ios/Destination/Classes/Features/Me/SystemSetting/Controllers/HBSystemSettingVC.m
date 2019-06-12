//
//  HBSystemSettingVC.m
//  Destination
//
//  Created by 胡勃 on 6/11/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBSystemSettingVC.h"
#import "NJNavigationController.h"
#import "HBLoginPageVC.h"

@interface HBSystemSettingVC ()
{
    IBOutlet UIButton   *btnCleanCach;
    IBOutlet UIButton   *btnAboutUS;
    IBOutlet UIButton   *btnQuit;
}

@end

@implementation HBSystemSettingVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UI Event

- (IBAction)touchButton:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:{
            
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            [self logout];
            break;
        }

        default:
            break;
    }
}

- (void)logout {
    [LBXAlertAction sayWithTitle:@"提示" message:@"确定退出吗？" buttons:@[@"取消", @"确定"] chooseBlock:^(NSInteger buttonIdx) {
        if (1 == buttonIdx) {
            HDGI.loginUser = nil;
            [HDLoginUserModel clearFromLocal];
            
            [self recomeToLogin];
        }
        return;
    }];
}

#pragma mark - Setter and Getter

- (void)setupUI
{
    self.title = @"系统设置";
    
    [btnQuit addBorderWidth:0.0f color:nil cornerRadius:25.f];
    [HDHelper changeColor:btnQuit];
}

- (void)recomeToLogin
{
    NJNavigationController * naviVC = [[NJNavigationController alloc] initWithRootViewController:[HBLoginPageVC new]];
    [[UIApplication sharedApplication].keyWindow setRootViewController:naviVC];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

@end
