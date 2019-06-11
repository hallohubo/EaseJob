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
    
    IBOutlet UIView             *vNeedCorneradia;
}

@end

@implementation HDMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
