//
//  NJRegisterVC.m
//  SmartCity
//
//  Created by TouchWorld on 2018/4/9.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "NJRegisterVC.h"
#import "UIImage+NJImage.h"
#import <SVProgressHUD.h>
#import "NJWebVC.h"
#import "NJUserItem.h"
#import <MJExtension.h>
#import <SafariServices/SafariServices.h>
#import <CYLTabBarController.h>
#import "CYLTabBarControllerConfig.h"
#import "AppDelegate.h"

@interface NJRegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextF;
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
- (IBAction)okBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *getVeriCodeBtn;
- (IBAction)getVeriCodeBtnClick:(UIButton *)sender;

- (IBAction)userProtocolBtnClick;
- (IBAction)securityBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet UIView *phoneContentView;
@property (weak, nonatomic) IBOutlet UIView *validateContentView;
@property (weak, nonatomic) IBOutlet UIView *pwdContentView;
- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)secureBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *secureBtn;

@property (weak, nonatomic) IBOutlet UIView *PwdContentVIew;
@property (weak, nonatomic) IBOutlet UIView *PawdcodeView;
/********* 定时器 *********/
@property(nonatomic,strong)dispatch_source_t timer;
@end

@implementation NJRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupInit];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //停止定时器
    [self stopTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(![self.phoneNumberTextF isFirstResponder])
    {
        [self.phoneNumberTextF becomeFirstResponder];
    }
}

#pragma mark - 设置初始化
- (void)setupInit
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    //    [self.RegisteredBtn setTitleColor:Btncolor forState:UIControlStateNormal];
    self.phoneContentView.backgroundColor = [UIColor whiteColor];
    self.getVeriCodeBtn.backgroundColor =Btncolor;
    [self.getVeriCodeBtn addAllCornerRadius:12.5];
    
    NSDictionary * placeholderDic = @{
                                      NSForegroundColorAttributeName : TextfieldPlasehoderColor,
                                      NSFontAttributeName : [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
                                      };
    self.phoneNumberTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:placeholderDic];
    self.codeTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:placeholderDic];
    self.pwdTextF.keyboardType = UIKeyboardTypeASCIICapable;
    self.pwdTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入6-12位登录密码 " attributes:placeholderDic];
    [self.phoneNumberTextF addTarget:self action:@selector(phoneInput:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTextF addTarget:self action:@selector(codeInput:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextF addTarget:self action:@selector(pwdInput:) forControlEvents:UIControlEventEditingChanged];
    
//    [self.phoneContentView addAllCornerRadius:21.5];
//    [self.validateContentView addAllCornerRadius:21.5];
//    [self.pwdContentView addAllCornerRadius:21.5];
    
    UIView * lineview =  [[UIView alloc]init];
    lineview.backgroundColor = LineViewColor;
    [self.self.phoneContentView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneContentView.mas_bottom).offset(-0.5);
        
        make.left.mas_equalTo(37.5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];
    
    UIView * lineview2 =  [[UIView alloc]init];
    lineview2.backgroundColor = LineViewColor;
    [self.PwdContentVIew addSubview:lineview2];
    [lineview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PwdContentVIew.mas_bottom).offset(-0.5);
        
        make.left.mas_equalTo(37.5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        
    }];

    UIView * lineview3 =  [[UIView alloc]init];
    lineview3.backgroundColor = LineViewColor;
    [self.PawdcodeView addSubview:lineview3];
    [lineview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PawdcodeView.mas_bottom).offset(-0.5);

        make.left.mas_equalTo(37.5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);

    }];
    
    [self.okBtn addAllCornerRadius:20];
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.6034] forState:UIControlStateDisabled];
    
    [self.okBtn setBackgroundImage:[UIImage imageWithColor:NJGreenColor] forState:UIControlStateNormal];
    [self.okBtn setBackgroundImage:[UIImage imageWithColor:NJDisableGreenColor] forState:UIControlStateDisabled];
    
    [self setupTimer];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readClick)];
    [self.readLabel addGestureRecognizer:tapGesture];
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
        
        if(timeout <= 0)
        { //倒计时结束，关闭
            [self stopTimer];
        }
        else
        {
            NSLog(@"时间 = %d",timeout);
            NSString *strTime = [NSString stringWithFormat:@"发送验证码(%dS)",timeout];
            NSLog(@"strTime = %@",strTime);
            dispatch_async(dispatch_get_main_queue(), ^{
                //定时过程中的UI处理
                self.getVeriCodeBtn.selected = YES;
                self.getVeriCodeBtn.userInteractionEnabled = NO;
                
                [self.getVeriCodeBtn setTitleColor:Btncolor forState:UIControlStateNormal];
                self.getVeriCodeBtn.backgroundColor = ERWUWUColor;
                self.getVeriCodeBtn.layer.borderWidth = 0.5;
                self.getVeriCodeBtn.layer.borderColor = Btncolor.CGColor;
                NSString * titleStr = [[NSString alloc] initWithFormat:@"剩余%dS", timeout];
                [self.getVeriCodeBtn setTitle:titleStr forState:UIControlStateNormal];
            });
            
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

//取消定时器
- (void)stopTimer
{
    if(self.timer != nil)
    {
        HDLog(@"取消定时器");
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            //定时结束后的UI处理
            self.getVeriCodeBtn.selected = NO;
            
            [self.getVeriCodeBtn setTitleColor:ERWUWUColor forState:UIControlStateNormal];
            self.getVeriCodeBtn.backgroundColor = Btncolor;
            [self.getVeriCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            self.getVeriCodeBtn.userInteractionEnabled = YES;
        });
    }
}

#pragma mark - 网络请求
//获取验证码
- (void)getVeriCode
{
    
//    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.phoneNumberTextF.text] forKey:@"username"];
//    //4登录2注册(含微信注册) 1找回密码
//    [postParams setValue:[NSString stringWithFormat:@"%@",@"2"] forKey:@"type"];
//    [[NetAPIManager instance] postWithPath:@"User/getCode" parameters:postParams finished:^(HDError * _Nullable error, id object, BOOL isLast, id result) {
//        [NJProgressHUD dismiss];
//        if (error) {
//            [HDHelper say:error.desc];
//            return ;
//        }
//        [self startTime];
//
//
//    }];
//
//    [NetRequest getValidateCodeWithPhoneNumber:self.phoneNumberTextF.text    type:@"0" completedBlock:^(id data, NSError *error) {
//        if(!error)
//        {
//            [self startTime];
//        }
//        else
//        {
//            HDLog(@"%@", error);
//        }
//
//    }];
    
    
}

//注册
- (void)postRegisterRequest
{
    
    
//    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.phoneNumberTextF.text] forKey:@"username"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.pwdTextF.text] forKey:@"password"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.codeTextF.text] forKey:@"code"];
//    [NJProgressHUD show];
//    [[NetAPIManager instance] postWithPath:@"User/register" parameters:postParams finished:^(HDError * _Nullable error, id object, BOOL isLast, id result) {
//        [NJProgressHUD dismiss];
//        if (error) {
//            [HDHelper say:error.desc];
//            return ;
//        }
//        NSDictionary *respons = result;
//        NSDictionary * dataDic = respons[DictionaryKeyData];
//        //字典转模型
////        HLTokenModel * tokenmodel = [HLTokenModel mj_objectWithKeyValues:dataDic];
////        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
////        [userDefaults setValue:tokenmodel.token forKey:NJUserDefaultLoginUserToken];
//        [self DataInit];
//
//    }];
    
    
//
//    [NJProgressHUD show];
//    [NetRequest userRegisterWithPhoneNumber:self.phoneNumberTextF.text code:self.codeTextF.text pwd:self.pwdTextF.text completedBlock:^(id data, NSError *error) {
//        [NJProgressHUD dismiss];
//        if(!error)
//        {
//            HDWeakSelf;
//            NSDictionary * dataDic = data[DictionaryKeyData];
//            NJUserItem * userItem = [NJUserItem mj_objectWithKeyValues:dataDic];
//            [NJLoginTool loginWithItem:userItem];
//
//            NSString * msgStr = data[DictionaryKeyMsg];
//            [NJProgressHUD showSuccess:msgStr];
//            [NJProgressHUD dismissWithDelay:1.2 completion:^{
//                [weakSelf goToTabBarVC];
//            }];
//
//        }
//        else
//        {
//            HDLog(@"%@", error);
//        }
//    }];
}
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
#pragma mark - 事件
- (IBAction)okBtnClick:(UIButton *)sender {
    if(self.phoneNumberTextF.text.length == 0)
    {
        [NJProgressHUD showError:@"手机号不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(self.phoneNumberTextF.text.length != 11)
    {
        [NJProgressHUD showError:@"手机号格式不正确"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(self.codeTextF.text.length == 0)
    {
        [NJProgressHUD showError:@"验证码不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(self.pwdTextF.text.length == 0)
    {
        [NJProgressHUD showError:@"密码不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(self.pwdTextF.text.length < 6)
    {
        [NJProgressHUD showError:@"密码不能小于6位"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(self.pwdTextF.text.length > 12)
    {
        [NJProgressHUD showError:@"密码不能大于12位"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    
    if(!self.selectBtn.selected)
    {
        [NJProgressHUD showError:@"请阅读并同意用户协议和隐私政策"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self postRegisterRequest];
    
}
- (IBAction)getVeriCodeBtnClick:(UIButton *)sender {
    
    if(self.phoneNumberTextF.text.length == 0)
    {
        [NJProgressHUD showError:@"手机号不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(self.phoneNumberTextF.text.length != 11)
    {
        [NJProgressHUD showError:@"手机号格式不正确"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [self.codeTextF becomeFirstResponder];
    [self getVeriCode];
}
- (IBAction)userProtocolBtnClick {
    NJWebVC * webVC = [[NJWebVC alloc] init];
    webVC.titleStr = @"用户协议";
//    webVC.urlStr = [NJProtocolPrefix stringByAppendingPathComponent:@"user_xy.html"];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)securityBtnClick:(id)sender {
    NJWebVC * webVC = [[NJWebVC alloc] init];
    webVC.titleStr = @"隐私政策";
//    webVC.urlStr = [NJProtocolPrefix stringByAppendingPathComponent:@"user_privacy_policy.html"];
    [self.navigationController pushViewController:webVC animated:YES];
}
- (IBAction)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self checkLoginBtnEnable];
}

- (void)readClick
{
    self.selectBtn.selected = !self.selectBtn.selected;
    [self checkLoginBtnEnable];
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)secureBtnClick:(UIButton *)sender {
    self.secureBtn.selected = !self.secureBtn.selected;
    self.pwdTextF.secureTextEntry = self.secureBtn.selected;
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

#pragma mark - 其它
- (void)dealloc
{
    HDLog(@"%s", __func__);
}

- (void)checkLoginBtnEnable
{
    if(self.phoneNumberTextF.text.length == 0 || self.codeTextF.text.length == 0 || self.pwdTextF.text.length == 0 || !self.selectBtn.selected)
    {
        self.okBtn.enabled = NO;
        return;
    }
    
    self.okBtn.enabled = YES;
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
@end
