//
//  HBResetPasswordVC.m
//  Destination
//
//  Created by 胡勃 on 6/12/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBResetPasswordVC.h"
#import "NJNavigationController.h"
#import "HBLoginPageVC.h"
#import "RSAUtil.h"

@interface HBResetPasswordVC ()
{
    IBOutlet UITextField        *tfPasswordFirst;
    IBOutlet UITextField        *tfPasswordSecond;
    IBOutlet UIButton           *btnConfirmSubmit;
    IBOutlet UIButton           *btnHidePWFirst;
    IBOutlet UIButton           *btnHidePWSecond;
    
    NSString        *strIsValid;
    NSString        *strPhone;
    NSURLSessionDataTask    *task;
}

@end

@implementation HBResetPasswordVC

#pragma mark - life cycle

- (instancetype)initWithPhone:(NSString *)phoneNumber specifiedCode:(NSString *)sCode
{
    if (self = [super init]) {
        strIsValid  = sCode;
        strPhone    = phoneNumber;
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    if(![tfPasswordFirst isFirstResponder]) {
        [tfPasswordFirst becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    task = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UI event

- (IBAction)btnSecureClick:(UIButton *)sender
{
    if (0 == sender.tag) {
        btnHidePWFirst.selected = !btnHidePWFirst.selected;
        tfPasswordFirst.secureTextEntry = btnHidePWFirst.selected;
    }else {
        btnHidePWSecond.selected = !btnHidePWSecond.selected;
        tfPasswordSecond.secureTextEntry = btnHidePWSecond.selected;
    }
    
}

- (IBAction)btnSubmit:(UIButton *)sender
{
    if(tfPasswordFirst.text.length == 0 || tfPasswordSecond.text.length == 0) {
        [NJProgressHUD showError:@"密码不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(tfPasswordFirst.text.length < 6 || tfPasswordSecond.text.length < 6) {
        [NJProgressHUD showError:@"密码不能小于6位"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(tfPasswordFirst.text.length > 12 || tfPasswordSecond.text.length > 12) {
        [NJProgressHUD showError:@"密码不能大于12位"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(![tfPasswordFirst.text isEqualToString:tfPasswordSecond.text]) {
        [NJProgressHUD showError:@"两次输入的密码不一样, 请重新输入"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }

    [self.view endEditing:YES];
    
    [self getPublicKey:^(NSString *key) {
        NSString *strPasswordKey  =[RSAUtil encryptString:tfPasswordSecond.text publicKey:key];
        Dlog(@"-----resultLogin=%@",strPasswordKey);
        
        NSDictionary *dic = @{@"isValid": HDSTR(strIsValid), @"newPwd": HDSTR(strPasswordKey), @"mobile": HDSTR(strPhone)};
        
        [self HttpSubmitModefication:dic];
    }];
}

#pragma mark - http event

- (void)getPublicKey:(void(^)(NSString *key))finishBlock //获取公钥
{    __block NSString *str = [[NSString alloc] init];
    HDHttpHelper *helper = [HDHttpHelper instance];
    [NJProgressHUD show];
    [helper postPath:@"Act102" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        str = [HDHelper decodeString:json[@"PublicKey"]];
        Dlog(@"login password with RSA:%@", str);
        finishBlock(str);
    }];
}

- (void)HttpSubmitModefication:(NSDictionary *)dicParam   //登录
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:dicParam];
    Dlog(@"dicParam:%@", dicParam);
    [NJProgressHUD show];
    task = [helper postPath:@"Act107" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
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
        [self recomeToLogin];
    }];
}

#pragma mark - setter and getter

- (void)setupUI
{
    self.title = @"忘记密码";
    
    [btnConfirmSubmit addBorderWidth:.0f color:nil cornerRadius:25.f];
    [HDHelper changeColor:btnConfirmSubmit];
}

- (void)recomeToLogin
{
    NJNavigationController * naviVC = [[NJNavigationController alloc] initWithRootViewController:[HBLoginPageVC new]];
    [[UIApplication sharedApplication].keyWindow setRootViewController:naviVC];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}
@end
