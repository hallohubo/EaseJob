//
//  HBKindsCardsAuthenticationVC.m
//  Destination
//
//  Created by 胡勃 on 7/1/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBKindsCardsAuthenticationVC.h"

@interface HBKindsCardsAuthenticationVC ()
{
    IBOutlet UIButton       *btnNextStep;
    IBOutlet UIImageView    *imvCard;
    IBOutlet UITextField    *tfName;
    IBOutlet UITextField    *tfIdentifyCode;
    IBOutlet UITextField    *tfBank;
    IBOutlet UITextField    *tfBankCode;
    
     NSURLSessionDataTask    *task;
}

@end

@implementation HBKindsCardsAuthenticationVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UI touch event

- (IBAction)btnNextClick:(UIButton *)sender
{
    if(tfName.text.length == 0) {
        [NJProgressHUD showError:@"姓名为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(![HDHelper isValideteIdentityCard:tfIdentifyCode.text]) {
        [NJProgressHUD showError:@"身份证号码不正确"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(tfBank.text.length == 0) {
        [NJProgressHUD showError:@"开户行不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(tfBankCode.text.length == 0) {
        [NJProgressHUD showError:@"开户行不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if([HDHelper isValidateBandCard:tfBankCode.text]) {
        [NJProgressHUD showError:@"银行卡号不正确!"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSDictionary *dic = @{@"name":HDSTR(tfName.text),
                          @"idCard":HDSTR(tfIdentifyCode.text),
                          @"bankAccount":HDSTR(tfBankCode.text),
                          @"openingBank":HDSTR(tfBank.text),
                          @"openingBank":HDSTR(tfBank.text),
                          @"isValid":HDSTR(tfBank.text),    //Act113接口返回的IsValid参数值原样回传
                          @"photoPath":HDSTR(tfBank.text),  //请求接口Act112上传后返回的图片地址
                          };
    
    [self HttpPostMobileAuthentication:dic];
}

#pragma mark - http event

- (void)HttpPostMobileAuthentication:(NSDictionary *)dicParam //request authentication
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:dicParam];
    [NJProgressHUD show];
    task = [helper postPath:@"Act115" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        Dlog(@"json:%@",json);
        NSDictionary *respons = json;
        NSString *strIsvalid = JSON(json[@"IsValid"]);
        Dlog(@"isvalid:%@",strIsvalid);
        [LBXAlertAction sayWithTitle:@"提示" message:@"短信验证成功" buttons:@[ @"确认"] chooseBlock:nil];
        //        HBResetPasswordVC *ctr = [[HBResetPasswordVC alloc] initWithPhone:tfPhone.text specifiedCode:strIsvalid];
        //        [self.navigationController pushViewController:ctr animated:YES];
        
    }];
}



#pragma mark - setter and getter

- (void)setupInit
{
    self.title = @"实名认证";
    
    [btnNextStep addBorderWidth:.0 color:nil cornerRadius:25.];
    [HDHelper changeColor:btnNextStep];
    
}

@end
