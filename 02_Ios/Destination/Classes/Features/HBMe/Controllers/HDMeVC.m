//
//  HDMeVC.m
//  Destination
//
//  Created by 胡勃 on 6/11/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HDMeVC.h"

@interface HDMeVC ()
{
    IBOutlet UIImageView        *imvHeadBackground;
    IBOutlet UIImageView        *imvHeadPerson;
    IBOutlet UIImageView        *imvOpenMemberArrow;
    IBOutlet UIImageView        *imvIsVIP;
    IBOutlet UIImageView        *imvHeadDotPoint;

    IBOutlet UIButton           *btnOpenMember;//开通会员
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
}

@end

@implementation HDMeVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - setter and getter

- (void)setupUI
{
    [vNeedCorneradia addBorderWidth:0.f color:nil cornerRadius:8.f];
    [btnOpenMember addBorderWidth:1. color:HDCOLOR_ORANGE cornerRadius:15.f];
    [imvHeadPerson addBorderWidth:.0 color:nil cornerRadius:33.f];
    [imvIsVIP addBorderWidth:0.f color:nil cornerRadius:10.f];
    [lbMemberMark addBorderWidth:.0f color:nil cornerRadius:10.f];
    [imvHeadDotPoint addDottedBorderWithLineWidth:1.f lineColor:RGB(90, 90, 90)];
    [imvHeadBackground addDottedBorderWithLineWidth:1.f lineColor:RGB(90, 90, 90)];
}

@end
