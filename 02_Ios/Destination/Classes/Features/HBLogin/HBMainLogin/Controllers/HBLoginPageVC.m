//
//  HBLoginPageVC.m
//  Destination
//
//  Created by 胡勃 on 6/9/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBLoginPageVC.h"
#import "HBRegisterVC.h"
#import "HBForgetPasswordVC.h"
#import "CYLTabBarControllerConfig.h"
#import "CYLTabBarController.h"
#import "AppDelegate.h"
#import "RSAUtil.h"

@interface HBLoginPageVC ()<UINavigationControllerDelegate>
{
    IBOutlet UITextField    *tfPassword;
    IBOutlet UITextField    *tfPhone;
    IBOutlet UIButton       *btnLogin;
    IBOutlet UIButton       *btnForget;
    IBOutlet UIButton       *btnSecure;
    IBOutlet UIButton       *btnRegiste;
    IBOutlet UIImageView    *imvLogo;
    NSURLSessionDataTask    *task;
}

@end

@implementation HBLoginPageVC

#pragma mark - lifeCycle

- (void)viewDidAppear:(BOOL)animated
{
//    if(![tfPhone isFirstResponder])
//    {
//        [tfPhone becomeFirstResponder];
//    }
}

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
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        str = [HDHelper decodeString:json[@"PublicKey"]];
        Dlog(@"login password with RSA:%@", str);
        finishBlock(str);
    }];
}

- (void)HttpPostLoginRequest:(NSDictionary *)dicParam   //登录
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:dicParam];
    [NJProgressHUD show];
    task = [helper postPath:@"Act105" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
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
        if (self.loginFinishedBlock) {
            self.loginFinishedBlock(model);
        }else {
            [self goToTabBarVC];
        }
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
        Dlog(@"-----resultLogin=%@",strPasswordKey);
        
        NSDictionary *dic = @{@"mobile":HDSTR(tfPhone.text),@"pwd":HDSTR(strPasswordKey)};
        
        [self HttpPostLoginRequest:dic];
    }];
}

- (IBAction)btnSecureClick:(UIButton *)sender
{
    btnSecure.selected = !btnSecure.selected;
    tfPassword.secureTextEntry = btnSecure.selected;
}

- (IBAction)btnForgetClick:(UIButton *)sender
{
    [self.navigationController pushViewController:[HBForgetPasswordVC new] animated:YES];
}

- (IBAction)btnRegisterClick:(UIButton *)sender
{
    [self.navigationController pushViewController:[HBRegisterVC new] animated:YES];
}

#pragma mark - setter and getter

- (void)setupInit
{
    self.navigationController.delegate = self;
    
    [btnLogin addBorderWidth:.0 color:nil cornerRadius:25.];
    [HDHelper changeColor:btnLogin];
    
    tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
}

#pragma mark - other method

- (void)goToTabBarVC
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CYLTabBarControllerConfig * tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    CYLTabBarController * tabBarController = tabBarControllerConfig.tabBarController;
    
    tabBarController.delegate = appDelegate;
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    
}

@end
