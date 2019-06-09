//
//  HBLoginPageVC.m
//  Destination
//
//  Created by 胡勃 on 6/9/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBLoginPageVC.h"
#import "RSAUtil.h"

@interface HBLoginPageVC ()<UINavigationControllerDelegate>
{
    IBOutlet UITextField    *tfPassword;
    IBOutlet UITextField    *tfPhone;
    IBOutlet UIButton       *btnLogin;
    IBOutlet UIButton       *btnForget;
    IBOutlet UIButton       *btnRegiste;
    IBOutlet UIImageView    *imvLogo;
    CAGradientLayer         *gradientLayer;
    NSURLSessionDataTask    *task;
}

@end

@implementation HBLoginPageVC

#pragma mark - lifeCycle

- (void)viewWillDisappear:(BOOL)animated {
    task = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc
{
    self.navigationController.delegate = nil;
    
    HDLog(@"%s", __func__);

}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - http request event

- (void)getPublicKey:(void(^)(NSString *key))finishBlock //获取公钥
{    __block NSString *str = [[NSString alloc] init];
    HDHttpHelper *helper = [HDHttpHelper instance];
    [NJProgressHUD show];
    [helper postPath:@"Act102" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [HDHelper say:error.desc];
            return ;
        }
        //str = [self URLDecodedString:json[@"PublicKey"]];
        str = [HDHelper decodeString:json[@"PublicKey"]];
        Dlog(@"RSA:%@", str);
        finishBlock(str);
    }];
}

//- (void)getPhoneVeriCode //获取验证码
//{
//    [LBXAlertAction sayWithTitle:@"提示" message:HDFORMAT(@"我们将下发短信验证码，请确认手机号：%@", tfPhone.text) buttons:@[@"取消", @"确认"] chooseBlock:^(NSInteger buttonIdx) {
//        if (buttonIdx == 0) {
//            return ;
//        }
//        NSDictionary *dic = @{@"mobile": HDSTR(tfPhone.text), @"flag": @"1"};
//        [self httpGetCode:dic];
//    }];
//}
//
//- (void)httpGetCode:(NSDictionary *)dicParam
//{
//    HDHttpHelper *helper = [HDHttpHelper instance];
//    [helper.parameters addEntriesFromDictionary:dicParam];
//    [NJProgressHUD show];
//    task = [helper postPath:@"Act103" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
//        [NJProgressHUD dismiss];
//        if (error) {
//            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
//            return ;
//        }
//        [tfValidation becomeFirstResponder];
//        [NJProgressHUD showSuccess:@"验证码下发成功，请注意查收短信！"];
//        [NJProgressHUD dismissWithDelay:1.2];
//        [self startTime];
//    }];
//}

- (void)HttpPostLoginRequest:(NSDictionary *)dicParam
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:dicParam];
    [NJProgressHUD show];
    task = [helper postPath:@"Act104" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        Dlog(@"json:%@",json);
        NSDictionary *respons = json;
        Dlog(@"jsonResponse:%@",respons);
        //字典转模型
        HDLoginUserModel * model = [HDLoginUserModel mj_objectWithKeyValues:respons];
        [model saveToLocal];
        HDGI.loginUser = model;
    }];
}
#pragma mark - UI event

- (IBAction)btnLoginClick:(UIButton *)sender
{
    if(tfPhone.text.length == 0) {
        [NJProgressHUD showError:@"手机号不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(tfPhone.text.length != 11) {
        [NJProgressHUD showError:@"手机号格式不正确"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(tfPassword.text.length == 0) {
        [NJProgressHUD showError:@"密码不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(tfPassword.text.length < 6) {
        [NJProgressHUD showError:@"密码不能小于6位"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(tfPassword.text.length > 12) {
        [NJProgressHUD showError:@"密码不能大于12位"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self getPublicKey:^(NSString *key) {
        NSString *strPasswordKey  =[RSAUtil encryptString:tfPassword.text publicKey:key];
        Dlog(@"resultLogin=%@",strPasswordKey);
        
        NSDictionary *dic = @{@"mobile":HDSTR(tfPhone.text),@"pwd":HDSTR(strPasswordKey)};
        
        [self HttpPostLoginRequest:dic];
    }];
}


- (void)phoneInput:(UITextField *)textF
{
    [self checkLoginBtnEnable];
}
- (void)codeInput:(UITextField *)textF
{
    [self checkLoginBtnEnable];
}
- (void)pwdInput:(UITextField *)textF
{
    [self checkLoginBtnEnable];
}

#pragma mark - setter and getter

- (void)setupInit
{
    self.navigationController.delegate = self;
    
    [HDHelper changeColor:btnLogin];
    
    tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
    [tfPhone addTarget:self action:@selector(phoneInput:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark - other method

- (NSString *)URLDecodedString:(NSString*)str
{
    NSString *decodedString = (__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (void)checkLoginBtnEnable
{
    if(tfPhone.text.length == 0 || tfPassword.text.length == 0) {
        btnLogin.enabled = NO;
        return;
    }
    
    btnLogin.enabled = YES;
}

@end
