//
//  HDMeVC.m
//  Destination
//
//  Created by 胡勃 on 6/11/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HDMeVC.h"
#import "HBSystemSettingVC.h"
#import "HBMobileCodeAuthenticationVC.h"
#import "HBGetPersonalAuthentificationVC.h"
#import "HDMeModel.h"
#import "HBUpdateToVIPVC.h"
#import "HBTopUpVC.h"
#import "HBPaymentDetailVC.h"

@interface HDMeVC ()<UINavigationControllerDelegate>
{
    IBOutlet UIImageView        *imvHeadBackground;
    IBOutlet UIImageView        *imvHeadPerson;
    IBOutlet UIImageView        *imvOpenMemberArrow;
    IBOutlet UIImageView        *imvIsVIP;
    IBOutlet UIImageView        *imvHeadDotPoint;

    IBOutlet UIButton           *btnOpenMember;//开通UIP
    IBOutlet UIButton           *btnOpenVIP;
    IBOutlet UIButton           *btnRecharge;//充值
    IBOutlet UIButton           *btnWithdrawal;//提现
    IBOutlet UIButton           *btnIncome;//收支明细
    IBOutlet UIButton           *btnShare;//分享得佣金
    IBOutlet UIButton           *btnCutomer;//联系客服
    IBOutlet UIButton           *btnSetting;//系统设置

    IBOutlet UILabel            *lbName;
    IBOutlet UILabel            *lbCommission;//佣金余额
    IBOutlet UILabel            *lbTask;//任务余额
    IBOutlet UILabel            *lbDeposit;//保证金
    IBOutlet UILabel            *lbFrozen;//冻结余额
    IBOutlet UILabel            *lbMemberMark;
    
    IBOutlet UIView             *vNeedCorneradia;
    NSURLSessionTask            *task;
    HDMeModel   *model;
}

@end

@implementation HDMeVC

#pragma mark - life cycle

- (void)viewDidAppear:(BOOL)animated
{
    [self httpGetMeData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    //[self httpGetMeData];
    
}

- (void)dealloc
{
    self.navigationController.delegate = nil;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - UI event

- (IBAction)touchButton:(UIButton *)sender {
    switch (sender.tag) {
        case 0:{//开通会员
            [self.navigationController pushViewController:[HBUpdateToVIPVC new] animated:YES];
            break;
        }
        case 1:{//充值
            if (!model) {
                return;
            }
            HBTopUpVC *ctr = [[HBTopUpVC alloc] initWithModel:model];
            [self.navigationController pushViewController:ctr animated:YES];
            break;
        }
        case 2:{//提现
            
            break;
        }
        case 3:{//收支明细
            [self.navigationController pushViewController:[HBPaymentDetailVC new] animated:YES];
            break;
        }
        case 4:{//分享佣金
            
            break;
        }
        case 5:{//联系客服
            
            break;
        }
        case 6:{//系统设置
            [self.navigationController pushViewController:[HBSystemSettingVC new] animated:YES];
            break;
        }
        case 7:{//个人信息验证
            [self.navigationController pushViewController:[HBGetPersonalAuthentificationVC new] animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - http event

- (void)httpGetMeData //
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [NJProgressHUD show];
    
    task = [helper postPath:@"Act109" object:[HDMeModel new] finished:^(HDError *error, id object, BOOL isLast, id json) {
        
        [NJProgressHUD dismiss];
        
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        Dlog(@"MeMode:%@", object);
        model = object;
        [self reloadUIDate:model];
    }];
}

#pragma mark - setter and getter

- (void)setupUI
{
    self.navigationController.delegate = self;//设置导航控制器的代理为self
    
    [vNeedCorneradia addBorderWidth:0.f color:nil cornerRadius:8.f];
    [btnOpenVIP addBorderWidth:1. color:HDCOLOR_ORANGE cornerRadius:15.f];
    [imvHeadPerson addBorderWidth:.0 color:nil cornerRadius:33.f];
    [imvIsVIP addBorderWidth:0.f color:nil cornerRadius:10.f];
    [lbMemberMark addBorderWidth:.0f color:nil cornerRadius:10.f];
}

- (void)reloadUIDate:(HDMeModel *)object
{
    if (!object) {
        return;
    }
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:HDSTR(model.HeadImg)]]];
    [imvHeadPerson setImage:image];
    
    lbName.text = model.RealName.length > 0? model.RealName : model.MemberNo;
    lbMemberMark.text   = HDSTR(model.AuthStatus);
    
    NSString *strGroup = HDSTR(model.MemberGroup);
    strGroup = [strGroup isEqualToString:@"普通会员"]? HDFORMAT(@"开通VIP"): strGroup;
    [btnOpenVIP setTitle:strGroup forState:UIControlStateNormal];
    
    lbCommission.text   = HDFORMAT(@"￥%.2f", HDSTR(model.Commission).floatValue);
    lbDeposit.text  = HDFORMAT(@"￥%.2f", HDSTR(model.MarginBalance).floatValue);
    lbFrozen.text   = HDFORMAT(@"￥%.2f", HDSTR(model.FreezingAmount).floatValue);
    lbTask.text     = HDFORMAT(@"￥%.2f", HDSTR(model.TaskBalance).floatValue);
}

//to set the status bar be transparent
- (void)setStatusBarBackgroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
@end
