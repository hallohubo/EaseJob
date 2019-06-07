//
//  NJValidationCodeLoginVC.m
//  Destination
//
//  Created by TouchWorld on 2019/1/9.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "NJLoginVC.h"
#import "NJRegisterVC.h"
#import "UIImage+NJImage.h"
#import "NJWebVC.h"
#import <CYLTabBarController.h>
#import "CYLTabBarControllerConfig.h"
#import "AppDelegate.h"
#import <MJExtension.h>
#import "NJUserItem.h"
#import "NJForgetPwdVC.h"
#import "HLTokenModel.h"

@interface NJLoginVC ()
- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)pwdLoginBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *phoneContentView;
@property (weak, nonatomic) IBOutlet UIView *pwdContentView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)userProtocolBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectBtnClick:(UIButton *)sender;
- (IBAction)readLabelClick:(UITapGestureRecognizer *)sender;
- (IBAction)phoneInput:(UITextField *)sender;
- (IBAction)pwdInput:(UITextField *)sender;
- (IBAction)loginBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *secureBtn;
- (IBAction)secureBtnClick:(UIButton *)sender;

- (IBAction)forgetPwdBtnClick:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIButton *RegisteredBtn;

@property (weak, nonatomic) IBOutlet UIView *PwdContentVIew;
@property (weak, nonatomic) IBOutlet UIButton *forgetPawBtn;

@end

@implementation NJLoginVC

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

#pragma mark - 设置初始化
- (void)setupInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.RegisteredBtn setTitleColor:Btncolor forState:UIControlStateNormal];
    self.phoneContentView.backgroundColor = [UIColor whiteColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.forgetPawBtn.titleLabel.text];
    [self.forgetPawBtn setTitleColor:Btncolor forState:UIControlStateNormal];
    [str addAttribute:NSForegroundColorAttributeName value:TextfieldPlasehoderColor range:NSMakeRange(0,5)];
    self.forgetPawBtn.titleLabel.attributedText = str;
    [self.forgetPawBtn setAttributedTitle:str forState:UIControlStateNormal];
   
    NSDictionary * placeholderDic = @{
                                      NSForegroundColorAttributeName : TextfieldPlasehoderColor,
                                      NSFontAttributeName : [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]
                                      };
    self.phoneNumberTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:placeholderDic];
    self.phoneNumberTextF.textColor = [UIColor blackColor];
    self.pwdTextF.keyboardType = UIKeyboardTypeASCIICapable;
    self.pwdTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入6-12位登录密码 " attributes:placeholderDic];
    //whl 加左视图
//    UIView * view1 = [[UIView alloc]init];
//    view1.frame = CGRectMake(0, 0, (24+37+32)/2, 30);
//    view1.backgroundColor = [UIColor clearColor];
//    UIImageView *  ima = [[UIImageView alloc]initWithFrame:CGRectMake(12, 11, 37/2, 46/2)];
//    ima.image = [UIImage imageNamed:@"icon_heart_praise_selected"];
//    [view1 addSubview:ima];
//    self.pwdTextF.leftView = view1;
//     self.pwdTextF.leftViewMode = UITextFieldViewModeAlways;
//
//    [self.phoneContentView addAllCornerRadius:21.5];
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
    
    [self.loginBtn addAllCornerRadius:20];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.6034] forState:UIControlStateDisabled];
    
    [self.loginBtn setBackgroundImage:[UIImage imageWithColor:NJGreenColor] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageWithColor:NJDisableGreenColor] forState:UIControlStateDisabled];
    
}

#pragma mark - 网络请求
//登录
-(void)loadData{
//    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.phoneNumberTextF.text] forKey:@"username"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.pwdTextF.text] forKey:@"password"];
//    //1密码 2验证码 登录
//    [postParams setValue:[NSString stringWithFormat:@"%@",@"1"] forKey:@"type"];
//
//     [NJProgressHUD show];
//    [[NetAPIManager instance] postWithPath:@"User/login" parameters:postParams finished:^(HDError * _Nullable error, id object, BOOL isLast, id result) {
//      [NJProgressHUD dismiss];
//        if (error) {
//            [HDHelper say:error.desc];
//            return ;
//        }
//        NSDictionary *respons = result;
//        NSDictionary * dataDic = respons[DictionaryKeyData];
//        //字典转模型
//        HLTokenModel * tokenmodel = [HLTokenModel mj_objectWithKeyValues:dataDic];
//        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setValue:tokenmodel.token forKey:NJUserDefaultLoginUserToken];
//        [self DataInit];
//
//    }];
}
//数据初始化
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
//                 [self infoRequest];
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
//    [NetRequest userLoginWithAccount:self.phoneNumberTextF.text pwd:self.pwdTextF.text completedBlock:^(id data, NSError *error) {
//
//        if(!error)
//        {
//
//
//            HDWeakSelf;
//            NSDictionary * dataDic = data[DictionaryKeyData];
//            NJUserItem * userItem = [NJUserItem mj_objectWithKeyValues:dataDic];
//            [NJLoginTool loginWithItem:userItem];
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



#pragma mark - 事件
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pwdLoginBtnClick:(UIButton *)sender {
    NJRegisterVC * registerVC = [[NJRegisterVC alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
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
    
    if(self.pwdTextF.text.length == 0)
    {
        [NJProgressHUD showError:@"密码不能为空"];
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
    [self loadData];
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

- (IBAction)pwdInput:(UITextField *)sender {
    [self checkLoginBtnEnable];
}




- (IBAction)userProtocolBtnClick {
    NJWebVC * webVC = [[NJWebVC alloc] init];
    webVC.titleStr = @"用户协议";
//    webVC.urlStr = [NJProtocolPrefix stringByAppendingPathComponent:@"user_xy.html"];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)secureBtnClick:(UIButton *)sender {
    self.secureBtn.selected = !self.secureBtn.selected;
    self.pwdTextF.secureTextEntry = self.secureBtn.selected;
}

- (IBAction)forgetPwdBtnClick:(UIButton *)sender {
    NJForgetPwdVC * forgetPwdVC = [[NJForgetPwdVC alloc] init];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}

#pragma mark - 其它
- (void)checkLoginBtnEnable
{
    if(self.phoneNumberTextF.text.length == 0 || self.pwdTextF.text.length == 0 || !self.selectBtn.selected)
    {
        self.loginBtn.enabled = NO;
        return;
    }
    
    self.loginBtn.enabled = YES;
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
