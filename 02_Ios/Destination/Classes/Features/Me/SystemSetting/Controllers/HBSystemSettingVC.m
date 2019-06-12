//
//  HBSystemSettingVC.m
//  Destination
//
//  Created by 胡勃 on 6/11/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBSystemSettingVC.h"
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
    [LBXAlertAction sayWithTitle:@"提示" message:@"确定退出吗？" buttons:@[@"确认", @"取消"] chooseBlock:^(NSInteger buttonIdx) {
        if (0 == buttonIdx) {
            HDGI.loginUser = nil;
            [HDLoginUserModel clearFromLocal];
            [self presentViewController:[HBLoginPageVC new] animated:YES completion:nil];
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

@end
