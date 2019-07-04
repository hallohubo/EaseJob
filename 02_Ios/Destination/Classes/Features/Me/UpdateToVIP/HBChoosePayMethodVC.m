//
//  HBChoosePayMethodVC.m
//  Destination
//
//  Created by 胡勃 on 7/4/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBChoosePayMethodVC.h"

@interface HBChoosePayMethodVC ()
{
    IBOutlet UIView     *vPayMethod;
    IBOutlet UIButton   *btnSelectMonthPay;
    IBOutlet UIButton   *btnSelectForeverVIP;
    IBOutlet UIButton   *btnAlipay;
    IBOutlet UIButton   *btnWechat;
    IBOutlet UIImageView    *imvMonthFee;
    IBOutlet UIImageView    *imvForeverFee;
    IBOutlet UIImageView    *imvAlipay;
    IBOutlet UIImageView    *imvWechat;
    IBOutlet UILabel        *lbMonthFee;
    IBOutlet UILabel        *lbForeverFee;
    IBOutlet UIButton       *btnConfirmPay;
}

@end

@implementation HBChoosePayMethodVC

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
