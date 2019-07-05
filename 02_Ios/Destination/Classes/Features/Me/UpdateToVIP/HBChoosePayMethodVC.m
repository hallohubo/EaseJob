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
    [self setupInit];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - setter

- (void)setupInit
{
    self.title = @"选择方式";
    
    btnConfirmPay.layer.cornerRadius = 25.f;
    btnConfirmPay.layer.masksToBounds= YES;
    [HDHelper changeColor:btnConfirmPay];
    
    btnAlipay.selected = NO;
    btnWechat.selected = NO;
    btnSelectMonthPay.selected  = NO;
    btnSelectForeverVIP.selected= NO;
    [self setImageWhenTouchButton];
}

- (IBAction)setImageWhenTouchButton:(UIButton *)sender
{
    
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        
        case 0:{
            btnSelectForeverVIP.selected = !sender.selected;
            break;
        }
        case 1:{
            btnSelectMonthPay.selected  = !sender.selected;;
            break;
        }
        case 2:{
            btnWechat.selected = !sender.selected;;
            break;
        }
        case 3:{
            btnAlipay.selected  = !sender.selected;;
            break;
        }
        default:
            break;
    }
    [self setImageWhenTouchButton];
}

- (void)setImageWhenTouchButton
{
    [imvAlipay setImage:(btnAlipay.selected? HDIMAGE(@"me_selected") : HDIMAGE(@"me_select"))];
    [imvWechat setImage:(btnWechat.selected? HDIMAGE(@"me_selected") : HDIMAGE(@"me_select"))];
    [imvMonthFee setImage:(btnSelectMonthPay.selected? HDIMAGE(@"me_selected") : HDIMAGE(@"me_select"))];
    [imvForeverFee setImage:(btnSelectForeverVIP.selected? HDIMAGE(@"me_selected") : HDIMAGE(@"me_select"))];

}

@end
