//
//  HBTopUpVC.m
//  Destination
//
//  Created by 胡勃 on 7/5/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBTopUpVC.h"
#import "HDMeModel.h"

@interface HBTopUpVC ()
{
    IBOutlet UITextView *tvExplain;
    
    IBOutlet UIView     *vTopup;
    IBOutlet UIView     *vWithdrawl;
    
    IBOutlet UILabel    *lbBank;
    IBOutlet UILabel    *lbBankAddress;
    IBOutlet UILabel    *lbBankCard;
    IBOutlet UILabel    *lbTopupMount;
    IBOutlet UILabel    *lbTaskBalance;
    IBOutlet UILabel    *lbTaskMargin;
    
    IBOutlet UIButton   *btnTopup;
    IBOutlet UIButton   *btnTaskBalancd;
    IBOutlet UIButton   *btnTaskMarbin;
    
    IBOutlet UIView     *vLineContain;
    IBOutlet UIView     *vNeedCorner;
    IBOutlet UIView     *vBankContain;
    IBOutlet UIView     *vBankInsideContain;
    IBOutlet NSLayoutConstraint *lcDistanceInRoll;
    
    NSURLSessionTask    *task;
    HDMeModel   *model;
}

@end

@implementation HBTopUpVC

- (instancetype)initWithModel:(HDMeModel *)IModel
{
    self = [super init];
    if (self) {
        model = IModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitUI];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - touch button event

- (IBAction)touchBalanceOrMarbin:(UIButton *)sender
{
    lcDistanceInRoll.constant = HDDeviceSize.width * 0.5 * sender.tag;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
   
    sender.selected = !sender.selected;
    if ([sender isEqual:btnTaskBalancd]) {
        btnTaskMarbin.selected = btnTaskBalancd.selected;
       
    }else {
        btnTaskBalancd.selected = btnTaskMarbin.selected;
    }
    
    vBankContain.hidden = !btnTaskMarbin.selected;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];

}

#pragma mark - http event

//- (void)httpGetParam
//{
//    HDHttpHelper *helper = [HDHttpHelper instance];
//    [NJProgressHUD show];
//
//    task = [helper postPath:@"Act117" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
//
//        [NJProgressHUD dismiss];
//
//        if (error) {
//            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
//            return ;
//        }
//        Dlog(@"MeMode:%@", object);
//
//    }];
//}

#pragma mark - setter and getter

- (void)setInitUI
{
    self.title = @"充值";
    lcDistanceInRoll.constant = 0.f;
    vBankContain.hidden = YES;
    
    btnTopup.layer.cornerRadius = 20.f;
    btnTopup.layer.masksToBounds= YES;
    
    vBankInsideContain.layer.cornerRadius = 8.f;
    vBankInsideContain.layer.masksToBounds= YES;
    
    vNeedCorner.layer.cornerRadius  = 8.f;
    vNeedCorner.layer.masksToBounds = YES;
    
    [HDHelper changeColor:btnTopup];
    [HDHelper changeViewColor:vBankInsideContain];
    
    lbTaskBalance.text = model.TaskBalance.length > 0 ? model.TaskBalance : @"--";
    lbTaskMargin.text = model.MarginBalance.length > 0 ? model.MarginBalance : @"--";
}


@end
