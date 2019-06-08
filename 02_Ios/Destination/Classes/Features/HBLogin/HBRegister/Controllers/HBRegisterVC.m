//
//  HBRegisterVC.m
//  Destination
//
//  Created by 胡勃 on 6/6/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBRegisterVC.h"

#import "UIImage+NJImage.h"
#import <SVProgressHUD.h>
#import "NJWebVC.h"
#import "NJUserItem.h"
#import <MJExtension.h>
#import <SafariServices/SafariServices.h>
#import <CYLTabBarController.h>
#import "CYLTabBarControllerConfig.h"
#import "AppDelegate.h"
#import "RSAUtil.h"


@interface HBRegisterVC ()
{
    IBOutlet UITextField    *tfPhone;
    IBOutlet UITextField    *tfPassword;
    IBOutlet UITextField    *tfValidation;
    IBOutlet UITextField    *tfInvite;
    IBOutlet UIButton       *btnValidation;
    IBOutlet UIButton       *btnRegister;
    IBOutlet UIButton       *btnSecure;
    IBOutlet UILabel        *lbAgreement;
    IBOutlet UIButton       *btnSelect;
    CAGradientLayer         *gradientLayer;
    NSURLSessionDataTask    *task;
}

/********* 定时器 *********/
@property(nonatomic, strong) dispatch_source_t timer;

@end

@implementation HBRegisterVC


#pragma mark - lifeCycle

- (void)viewWillDisappear:(BOOL)animated {
    task = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self changeColor];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 设置定时器
- (void)setupTimer
{
    UIApplication * app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

//启动定时器
- (void)startTime
{
    __block int timeout = 60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    self.timer = _timer;
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0) { //倒计时结束，关闭
            [self stopTimer];
        }
        else {
            NSLog(@"时间 = %d",timeout);
            NSString *strTime = [NSString stringWithFormat:@"发送验证码(%dS)",timeout];
            NSLog(@"strTime = %@",strTime);
            dispatch_async(dispatch_get_main_queue(), ^{
                btnValidation.userInteractionEnabled = NO;
                [btnValidation setTitleColor:HDCOLOR_RED forState:UIControlStateNormal];
                NSString * titleStr = [[NSString alloc] initWithFormat:@"剩余%dS", timeout];
                [btnValidation setTitle:titleStr forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (void)stopTimer   //取消定时器
{
    if(self.timer != nil)
    {
        HDLog(@"取消定时器");
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            btnValidation.selected = NO;
            [btnValidation setTitleColor:HDCOLOR_ORANGE forState:UIControlStateNormal];
            [btnValidation setTitle:@"发送验证码" forState:UIControlStateNormal];
            btnValidation.userInteractionEnabled = YES;
        });
    }
}

#pragma mark - Http request

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
        str = [self URLDecodedString:json[@"PublicKey"]];
        Dlog(@"RSA:%@", str);
        finishBlock(str);
    }];
}

- (void)getPhoneVeriCode //获取验证码
{
    [LBXAlertAction sayWithTitle:@"提示" message:HDFORMAT(@"我们将下发短信验证码，请确认手机号：%@", tfPhone.text) buttons:@[@"取消", @"确认"] chooseBlock:^(NSInteger buttonIdx) {
        if (buttonIdx == 0) {
            return ;
        }
        NSDictionary *dic = @{@"mobile": HDSTR(tfPhone.text), @"flag": @"1"};
        [self httpGetCode:dic];
    }];
}

- (void)httpGetCode:(NSDictionary *)dicParam
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:dicParam];
    [NJProgressHUD show];
    task = [helper postPath:@"Act103" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        [tfValidation becomeFirstResponder];
        [NJProgressHUD showSuccess:@"验证码下发成功，请注意查收短信！"];
        [NJProgressHUD dismissWithDelay:1.2];
        [self startTime];
    }];
}

- (void)HttpPostRegisterRequest:(NSDictionary *)dicParam
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
        [self goToTabBarVC];
    }];
}


//注册
//- (void)postRegisterRequest
//{
//
//
//        NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
//        [postParams setValue:[NSString stringWithFormat:@"%@",self.phoneNumberTextF.text] forKey:@"username"];
//        [postParams setValue:[NSString stringWithFormat:@"%@",self.pwdTextF.text] forKey:@"password"];
//        [postParams setValue:[NSString stringWithFormat:@"%@",self.codeTextF.text] forKey:@"code"];
//        [NJProgressHUD show];
//        [[NetAPIManager instance] postWithPath:@"User/register" parameters:postParams finished:^(HDError * _Nullable error, id object, BOOL isLast, id result) {
//            [NJProgressHUD dismiss];
//            if (error) {
//                [HDHelper say:error.desc];
//                return ;
//            }
//            NSDictionary *respons = result;
//            NSDictionary * dataDic = respons[DictionaryKeyData];
//            字典转模型
//            HLTokenModel * tokenmodel = [HLTokenModel mj_objectWithKeyValues:dataDic];
//            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setValue:tokenmodel.token forKey:NJUserDefaultLoginUserToken];
//            [self DataInit];
//
//        }];
//
//
//    //
//    //    [NJProgressHUD show];
//    //    [NetRequest userRegisterWithPhoneNumber:self.phoneNumberTextF.text code:self.codeTextF.text pwd:self.pwdTextF.text completedBlock:^(id data, NSError *error) {
//    //        [NJProgressHUD dismiss];
//    //        if(!error)
//    //        {
//    //            HDWeakSelf;
//    //            NSDictionary * dataDic = data[DictionaryKeyData];
//    //            NJUserItem * userItem = [NJUserItem mj_objectWithKeyValues:dataDic];
//    //            [NJLoginTool loginWithItem:userItem];
//    //
//    //            NSString * msgStr = data[DictionaryKeyMsg];
//    //            [NJProgressHUD showSuccess:msgStr];
//    //            [NJProgressHUD dismissWithDelay:1.2 completion:^{
//    //                [weakSelf goToTabBarVC];
//    //            }];
//    //
//    //        }
//    //        else
//    //        {
//    //            HDLog(@"%@", error);
//    //        }
//    //    }];
//}
-(void)DataInit{
    
    //    NSString * deviceToken = (NSString *)[FileCacheTool unCacheObjectWithKey:NJUserDefaultDeviceToken];
    //    if([NSString isEmptyString:deviceToken])
    //    {
    //        NSLog(@"数据初始化失败");
    //        [self infoRequest];
    //    }else{
    //
    //        [[NetAPIManager instance] postWithPath:@"changtour/Index/init" parameters:@{deviceToken:@"device_token",@"0":@"device_type"} finished:^(HDError * _Nullable error, id object, BOOL isLast, id result) {
    //
    //            if (!error) {
    //                [self infoRequest];
    //                NSLog(@"数据初始化成功");
    //            }else{
    //                NSLog(@"数据初始化失败");
    //
    //            }
    //
    //
    //        }];
    //    }
}
//用户的信息
- (void)infoRequest
{
    
    //    NSString * token = [NJLoginTool getUserToken];
    //    @{@"token":token}
    //    [[NetAPIManager instance] postWithPath:@"changtour/User/info" parameters:nil finished:^(HDError * _Nullable error, id object, BOOL isLast, id result) {
    //        [NJProgressHUD dismiss];
    //        if (error) {
    //            [HDHelper say:error.desc];
    //            return ;
    //        }
    //        NSDictionary *respons = result;
    //        NSDictionary * dataDic = respons[DictionaryKeyData];
    //        HDWeakSelf;
    //        NJUserItem * userItem = [NJUserItem mj_objectWithKeyValues:dataDic];
    //        [NJLoginTool loginWithItem:userItem];
    //        NSString * msgStr = dataDic[DictionaryKeyMsg];
    //        [NJProgressHUD showSuccess:msgStr];
    //        [NJProgressHUD dismissWithDelay:1.2 completion:^{
    //            [weakSelf goToTabBarVC];
    //        }];
    //
    //    }];
}

#pragma mark - evert

- (void)readClick
{
    btnSelect.selected = !btnSelect.selected;
    [self checkLoginBtnEnable];
}


- (IBAction)btnRegisterClick:(UIButton *)sender
{
        [self goToTabBarVC];
    return;
    
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
    
    if(tfValidation.text.length == 0) {
        [NJProgressHUD showError:@"验证码不能为空"];
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
    
    if(!btnSelect.selected) {
        [NJProgressHUD showError:@"请阅读并同意用户协议和隐私政策"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [self.view endEditing:YES];
    [self goToTabBarVC];

    [self getPublicKey:^(NSString *key) {
        NSString *strPasswordKey  =[RSAUtil encryptString:tfPassword.text publicKey:key];
        Dlog(@"resultLogin=%@",strPasswordKey);

        NSDictionary *dic = @{@"mobile":HDSTR(tfPhone.text),@"pwd":HDSTR(strPasswordKey), @"validCode":HDSTR(tfValidation.text), @"inviteCode":HDSTR(tfInvite.text)};

        [self HttpPostRegisterRequest:dic];
    }];
}

- (IBAction)getVeriCodeBtnClick:(UIButton *)sender
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
    
    [self getPhoneVeriCode];
}

- (IBAction)userProtocolBtnClick
{
    NJWebVC * webVC = [[NJWebVC alloc] init];
    webVC.titleStr = @"用户协议";
    //    webVC.urlStr = [NJProtocolPrefix stringByAppendingPathComponent:@"user_xy.html"];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)securityBtnClick:(id)sender
{
    NJWebVC * webVC = [[NJWebVC alloc] init];
    webVC.titleStr = @"隐私政策";
    //    webVC.urlStr = [NJProtocolPrefix stringByAppendingPathComponent:@"user_privacy_policy.html"];
    [self.navigationController pushViewController:webVC animated:YES];
}
- (IBAction)selectBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self checkLoginBtnEnable];
}

- (IBAction)secureBtnClick:(UIButton *)sender {
    btnSecure.selected = !btnSecure.selected;
    tfPassword.secureTextEntry = btnSecure.selected;
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

- (void)setup
{
    self.title = @"注册";
    [btnRegister addBorderWidth:0.0 color:nil cornerRadius:20.];
    
    tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
    [tfPhone addTarget:self action:@selector(phoneInput:) forControlEvents:UIControlEventEditingChanged];
    [tfValidation addTarget:self action:@selector(codeInput:) forControlEvents:UIControlEventEditingChanged];
    [tfPassword addTarget:self action:@selector(pwdInput:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readClick)];
    [lbAgreement addGestureRecognizer:tapGesture];
}

- (void)changeColor
{
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = btnRegister.bounds;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [btnRegister.layer addSublayer:gradientLayer];
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)[ssRGBHexAlpha(0xFFF152, 0.8) CGColor],
                             (__bridge id)[ssRGBHexAlpha(0xFD8533, 0.5) CGColor]];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.2f), @(1.0f)];
}

#pragma mark - 其它
- (void)dealloc
{
    HDLog(@"%s", __func__);
}

- (NSString *)URLDecodedString:(NSString*)str
{
    NSString *decodedString = (__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (void)checkLoginBtnEnable
{
    if(tfPhone.text.length == 0 || tfValidation.text.length == 0 || tfPassword.text.length == 0 || !btnSelect.selected || tfInvite.text.length == 0) {
        btnRegister.enabled = NO;
        return;
    }
    
    btnRegister.enabled = YES;
}

- (void)goToTabBarVC
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    CYLTabBarControllerConfig * tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    CYLTabBarController * tabBarController = tabBarControllerConfig.tabBarController;

    tabBarController.delegate = appDelegate;
    
    
    [UIView transitionFromView:self.navigationController.view toView:tabBarController.view duration:UIViewAnimationTrantitionTime options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionCurveEaseInOut completion:^(BOOL finished) {
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
    }];
}

+(CYLTabBarController *)tabbarController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *tabbarController = window.rootViewController;
    if ([tabbarController isKindOfClass:[CYLTabBarController class]]) {
        return (CYLTabBarController *)tabbarController;
    }
    return nil;
    
}

- (void)setNavigationBarStyle{
    [self.navigationController.navigationBar setBackgroundImage:HDIMAGE(@"theme") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:14.0f], NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:dic];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
@end
