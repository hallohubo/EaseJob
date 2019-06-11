//
//  HBSystemSettingVC.m
//  Destination
//
//  Created by 胡勃 on 6/11/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBSystemSettingVC.h"

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
    if (sender.tag == 0) {
        Dlog(@"touch clean cach button");
    }else {
        [self logout];
    }
}

- (void)logout {
//    HDHelper *help  = [HDHelper instance];
//    [help say:@"确定退出吗？" confirm:@"确定" cancel:@"取消" finished:^(UIAlertView *alertView, int index) {
//        Dlog(@"resultIndex = %d", index);
//        if (index == 1) {
//            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"firstInsurePersonID"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            HDGI.loginUser = nil;
//            [HDLoginUserModel clearFromLocal];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        return ;
//    }];
}

#pragma mark - Setter and Getter

- (void)setupUI
{
    self.title = @"系统设置";
    
    [btnQuit addBorderWidth:0.0f color:nil cornerRadius:25.f];
    [HDHelper changeColor:btnQuit];
}

@end
