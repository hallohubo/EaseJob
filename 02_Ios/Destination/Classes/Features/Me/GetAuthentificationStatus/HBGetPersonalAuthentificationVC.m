//
//  HBGetPersonalAuthentificationVC.m
//  Destination
//
//  Created by 胡勃 on 7/2/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBGetPersonalAuthentificationVC.h"
#import "HBMobileCodeAuthenticationVC.h"
#import "HBRealNameAuthenticationModel.h"

@interface HBGetPersonalAuthentificationVC ()
{
    IBOutlet UIButton   *btnNickName;
    IBOutlet UIButton   *btnGender;
    IBOutlet UIButton   *btnImage;
    IBOutlet UIButton   *btnVertify;
    
    IBOutlet UILabel    *lbNickName;
    IBOutlet UILabel    *lbGender;
    IBOutlet UILabel    *lbName;
    IBOutlet UILabel    *lbIDNumber;
    IBOutlet UILabel    *lbBank;
    IBOutlet UILabel    *lbBankNumber;
    IBOutlet UILabel    *lbRemark;
    
    IBOutlet UIImageView        *imvHead;
    IBOutlet NSLayoutConstraint *lcHeight;
    HBRealNameAuthenticationModel   *model;
    NSURLSessionTask    *task;
}

@end

@implementation HBGetPersonalAuthentificationVC

#pragma mark - life cycle

- (void)viewDidAppear:(BOOL)animated
{
    [self httpGetMeData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
}

#pragma mark - touch event

- (IBAction)jumpToIdentifyAuthentifycation:(UIButton *)sender
{
    [self.navigationController pushViewController:[HBMobileCodeAuthenticationVC new] animated:YES];
}

#pragma mark - http event

- (void)httpGetMeData //
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [NJProgressHUD show];
    
    task = [helper postPath:@"Act110" object:[HBRealNameAuthenticationModel new] finished:^(HDError *error, id object, BOOL isLast, id json) {
        
        [NJProgressHUD dismiss];
        
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        Dlog(@"MeMode:%@", object);
        model = object;
        [self reloadUIDate];
    }];
}
#pragma mark - setter and getter

- (void)setupInit
{
    self.title = @"个人信息";
    
    imvHead.layer.cornerRadius  = 40.f;
    imvHead.layer.masksToBounds = YES;
    imvHead.layer.borderWidth   = 1.f;
    imvHead.layer.borderColor   = HDCOLOR_GRAY.CGColor;
    
    
    btnVertify.layer.cornerRadius = 25.f;
    btnVertify.layer.masksToBounds= YES;
    
    [HDHelper changeColor:btnVertify];
}

- (void)reloadUIDate
{
    lbName.text = HDSTR(model.RealName);
    lbBank.text = HDSTR(model.OpeningBank);
    lbBankNumber.text   = HDSTR(model.BankAccount);
    lbIDNumber.text     = HDSTR(model.IDCard);
    lbNickName.text     = HDSTR(model.NickName);
    lbGender.text       = HDSTR(model.Sex);
    lbRemark.text       = HDSTR(model.AuthRemark);
    
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:HDSTR(model.HeadImg)]]];
    [imvHead setImage:image];
    
    NSString *str   = HDSTR(model.AuthStatus);
    BOOL isHidden   = [str isEqualToString:@"待审核"] || [str isEqualToString:@"已认证"];
    [btnVertify setHidden:!isHidden];
    
    lcHeight.constant = lbRemark.text.length > 0? 30 : 0;
}

@end
