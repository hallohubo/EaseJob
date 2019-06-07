//
//  NJValidationCodeLoginVC.m
//  Destination
//
//  Created by TouchWorld on 2019/1/9.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "NJValidationCodeLoginVC.h"
#import "NJLoginVC.h"
#import "UIImage+NJImage.h"
#import "NJWebVC.h"
#import <CYLTabBarController.h>
#import "CYLTabBarControllerConfig.h"
#import "AppDelegate.h"
#import <MJExtension.h>
#import "NJUserItem.h"
#import <ShareSDK/ShareSDK.h>
#import <WXApi.h>
#import "NJForceBindPhoneNumberVC.h"

@interface NJValidationCodeLoginVC ()
- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)pwdLoginBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *phoneContentView;
@property (weak, nonatomic) IBOutlet UIView *validateContentView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextF;
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *getVeriCodeBtn;
- (IBAction)getVeriCodeBtnClick:(UIButton *)sender;

- (IBAction)userProtocolBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectBtnClick:(UIButton *)sender;
- (IBAction)readLabelClick:(UITapGestureRecognizer *)sender;
- (IBAction)phoneInput:(UITextField *)sender;
- (IBAction)codeInput:(UITextField *)sender;
- (IBAction)loginBtnClick:(UIButton *)sender;
/********* 定时器 *********/
@property(nonatomic,strong)dispatch_source_t timer;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *pawdLoginBtnClick;
@property (weak, nonatomic) IBOutlet UIView *PwdContentVIew;


@property(nonatomic,strong)UIView * otherloginlinview;

@property(nonatomic,strong)UILabel * otherloginLab;

@property(nonatomic,strong)UIButton * otherloginBtn;


@end

@implementation NJValidationCodeLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupInit];
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //停止定时器
    [self stopTimer];
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
    
//    [self.phoneContentView addAllCornerRadius:21.5];
//    [self.validateContentView addAllCornerRadius:21.5];
    
    UIView * lineview =  [[UIView alloc]init];
    lineview.backgroundColor = LineViewColor;
    [self.phoneContentView addSubview:lineview];
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
    
    [self.loginBtn addAllCornerRadius:20];
    self.loginBtn.hidden =YES;
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.6034] forState:UIControlStateDisabled];
    
    [self.loginBtn setBackgroundImage:[UIImage imageWithColor:NJGreenColor] forState:UIControlStateNormal];
//    [self.loginBtn setBackgroundImage:[UIImage imageWithColor:NJDisableGreenColor] forState:UIControlStateDisabled];
    
    
    [self otherLoginview];
    
    [self.pawdLoginBtnClick setTitle:@"密码登录" forState:UIControlStateNormal];
    [self.pawdLoginBtnClick setTitleColor:Btncolor forState:UIControlStateNormal];
    [self setupTimer];
    
}



-(void)otherLoginview{
    
    _otherloginlinview = [[UIView alloc]init];
    _otherloginlinview.backgroundColor = TextfieldPlasehoderColor;
    [self.view addSubview:_otherloginlinview];
    
    _otherloginLab = [[UILabel alloc]init];
    _otherloginLab.backgroundColor = [UIColor whiteColor];
    _otherloginLab.textColor = TextfieldPlasehoderColor;
    _otherloginLab.font = [UIFont systemFontOfSize:12];
    _otherloginLab.textAlignment = NSTextAlignmentCenter;
    _otherloginLab.textColor =TextfieldPlasehoderColor;
    _otherloginLab.text = @"其他登录方式";
    [self.view addSubview:_otherloginLab];
    
    _otherloginBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [_otherloginBtn setBackgroundImage:[UIImage imageNamed:@"微信登录按钮"] forState:UIControlStateNormal];
    [self.view addSubview:_otherloginBtn];
    
    [_otherloginBtn addTarget:self action:@selector(otherloginBtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    [_otherloginlinview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self->_PwdContentVIew.mas_bottom).offset(28.5);
      
        make.left.mas_equalTo(52.5);
        make.right.mas_equalTo(-52.5);
        make.height.mas_equalTo(0.5);
        
    }];
    [_otherloginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self->_otherloginlinview.mas_centerX).offset(0);
        make.centerY.equalTo(self->_otherloginlinview.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(120, 12));
        
    }];
    
    [_otherloginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self->_otherloginLab.mas_centerX).offset(0);
        make.centerY.equalTo(self->_otherloginLab.mas_centerY).offset(45);
         make.size.mas_equalTo(CGSizeMake(45, 45));
        
    }];
    
    
    
}

//微信登录点击shi jian事件
-(void)otherloginBtnclick{
    
    
    
    [NJProgressHUD show];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        [NJProgressHUD dismiss];
        if(state == SSDKResponseStateSuccess)
        {
            HDLog(@"user:%@", user.rawData);
            [self weChatLogin:user.rawData];
            
        }
        else if(state == SSDKResponseStateFail)
        {
            [NJProgressHUD showError:@"授权失败"];
            [NJProgressHUD dismissWithDelay:1.2];
        }
        else
        {
            HDLog(@"%@", error);
        }
    }];
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
//验证码登录
- (void)validationCodeLoginRequest
{
//    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.phoneNumberTextF.text] forKey:@"username"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",@"2"] forKey:@"type"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.codeTextF.text] forKey:@"password"];
//    [NJProgressHUD show];
//    [[NetAPIManager instance] postWithPath:@"User/login" parameters:postParams finished:^(HDError * _Nullable error, id object, BOOL isLast, id result) {
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
    
//    [NJProgressHUD show];
//    [NetRequest userLoginWithPhoneNumber:self.phoneNumberTextF.text code:self.codeTextF.text completedBlock:^(id data, NSError *error) {
//        [NJProgressHUD dismiss];
//        if(!error)
//        {
//            HDWeakSelf;
//            NSDictionary * dataDic = data[DictionaryKeyData];
//            NJUserItem * userItem = [NJUserItem mj_objectWithKeyValues:dataDic];
//            [NJLoginTool loginWithItem:userItem];
//            
//            NSString * msgStr = data[DictionaryKeyMsg];
//        
//            [NJProgressHUD showSuccess:msgStr];
//            [NJProgressHUD dismissWithDelay:1.2 completion:^{
//                [weakSelf goToTabBarVC];
//            }];
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
//
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
//        [NJProgressHUD showSuccess:@"登录成功"];
//        [NJProgressHUD dismissWithDelay:1.2 completion:^{
//            [weakSelf goToTabBarVC];
//        }];
//
//    }];
}
//获取验证码
- (void)getVeriCode
{
//    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.phoneNumberTextF.text] forKey:@"username"];
//    //4登录2注册(含微信注册) 1找回密码
//    [postParams setValue:[NSString stringWithFormat:@"%@",@"4"] forKey:@"type"];
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
    
//    [NetRequest getValidateCodeWithPhoneNumber:self.phoneNumberTextF.text    type:@"5" completedBlock:^(id data, NSError *error) {
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




#pragma mark - 事件
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pwdLoginBtnClick:(UIButton *)sender {
    
    NJLoginVC * loginVC = [[NJLoginVC alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)loginBtnClick:(UIButton *)sender {
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
    
    if(!self.selectBtn.selected)
    {
        [NJProgressHUD showError:@"请阅读并同意用户协议"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self validationCodeLoginRequest];
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
  
    sender.enabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
        
    });
    [self getVeriCode];
}

- (IBAction)selectBtnClick:(UIButton *)sender {
    [self readLabelClick:nil];
}

- (IBAction)readLabelClick:(UITapGestureRecognizer *)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
    [self checkLoginBtnEnable];
    
}

- (IBAction)phoneInput:(UITextField *)sender {
    [self checkLoginBtnEnable];
}

- (IBAction)codeInput:(UITextField *)sender {
    [self checkLoginBtnEnable];
}




- (IBAction)userProtocolBtnClick {
    NJWebVC * webVC = [[NJWebVC alloc] init];
    webVC.titleStr = @"用户协议";
//    webVC.urlStr = [NJProtocolPrefix stringByAppendingPathComponent:@"user_xy.html"];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 其它
- (void)checkLoginBtnEnable
{
    if(self.phoneNumberTextF.text.length == 0 || self.codeTextF.text.length == 0 || !self.selectBtn.selected)
    {
        self.loginBtn.hidden = YES;
        self.otherloginBtn.hidden = NO;
        self.otherloginLab.hidden = NO;
        self.otherloginlinview.hidden= NO;
        return;
    }
    self.otherloginBtn.hidden = YES;
    self.otherloginLab.hidden = YES;
    self.otherloginlinview.hidden= YES;
    self.loginBtn.hidden = NO;
    self.loginBtn.enabled = YES;
}

#pragma mark - 其他
- (void)dealloc
{
    HDLog(@"%s", __func__);
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

//微信登录
- (void)weChatLogin:(NSDictionary *)userInfo
{
    
//    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
//    [postParams setValue:[NSString stringWithFormat:@"%@",userInfo[@"headimgurl"]] forKey:@"avatar"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",userInfo[@"openid"]] forKey:@"open_id"];
//    
//    [NJProgressHUD show];
//    [[NetAPIManager instance] postWithPath:@"User/wxlogin" parameters:postParams finished:^(HDError * _Nullable error, id object, BOOL isLast, id result) {
//        [NJProgressHUD dismiss];
//        
//        if (error) {
//            if(error.code ==1004){
//                
//                
//                NJForceBindPhoneNumberVC * forceBindPhoneNumberVC = [[NJForceBindPhoneNumberVC alloc] init];
//                forceBindPhoneNumberVC.userInfos =userInfo;
//                [self.navigationController pushViewController:forceBindPhoneNumberVC animated:YES];
//                return;
//                
//            }else{
//                
//                [HDHelper say:error.desc];
//                return ;
//                
//            }
//            
//        }
//        NSDictionary *respons = result;
//        NSDictionary * dataDic = respons[DictionaryKeyData];
////        //字典转模型
////        HLTokenModel * tokenmodel = [HLTokenModel mj_objectWithKeyValues:dataDic];
////        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
////        [userDefaults setValue:tokenmodel.token forKey:NJUserDefaultLoginUserToken];
//        [self infoRequest];
//
//     }];
    
    
    
    
    
//    [NJProgressHUD show];
//    [NetRequest weixinLoginWithOpenID:userInfo[@"openid"] nickname:userInfo[@"nickname"] gender:[userInfo[@"sex"] stringValue] country:userInfo[@"country"] province:userInfo[@"province"] city:userInfo[@"city"] headimgurl:userInfo[@"headimgurl"] completedBlock:^(id data, NSError *error) {
//        [NJProgressHUD dismiss];
//        if(!error)
//        {
//            HDWeakSelf;
//            NSDictionary * dataDic = data[DictionaryKeyData];
//            NJUserItem * userItem = [NJUserItem mj_objectWithKeyValues:dataDic];
//            NSLog(@"----------------------------------------%@",dataDic);
//            //判断是否绑定了手机号
//            if([NSString isEmptyString:userItem.mobile])
//            {
//                NJForceBindPhoneNumberVC * forceBindPhoneNumberVC = [[NJForceBindPhoneNumberVC alloc] init];
//                forceBindPhoneNumberVC.userItem = userItem;
//                [self.navigationController pushViewController:forceBindPhoneNumberVC animated:YES];
//                return;
//            }
//
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

@end