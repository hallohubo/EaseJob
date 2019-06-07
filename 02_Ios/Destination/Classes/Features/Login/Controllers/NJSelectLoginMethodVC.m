//
//  NJSelectLoginMethodVC.m
//  Destination
//
//  Created by TouchWorld on 2018/12/5.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJSelectLoginMethodVC.h"
#import "NJValidationCodeLoginVC.h"
#import "NJLoginCarouseImageItem.h"
#import <MJExtension.h>
#import <ShareSDK/ShareSDK.h>
#import <WXApi.h>
#import <CYLTabBarController.h>
#import "CYLTabBarControllerConfig.h"
#import "NJUserItem.h"
#import "AppDelegate.h"
#import "NJWebVC.h"
#import "NJForceBindPhoneNumberVC.h"
#import "NJCarouseView.h"

@interface NJSelectLoginMethodVC ()
@property (weak, nonatomic) IBOutlet UIButton *changeUrlBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginBtn;
- (IBAction)phoneLoginBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *weixinLoginBtn;
- (IBAction)weixinLoginBtnClick:(id)sender;
- (IBAction)userProtocolBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

/********* <#注释#> *********/
@property(nonatomic,strong)NSArray<NJLoginCarouseImageItem *> *    leftImageArr;
/********* <#注释#> *********/
@property(nonatomic,strong)NSArray<NJLoginCarouseImageItem *> *    rightImageArr;
/********* <#注释#> *********/
@property(nonatomic,weak)NJCarouseView * leftCarouseView;
/********* <#注释#> *********/
@property(nonatomic,weak)NJCarouseView * rightCarouseView;

@end

@implementation NJSelectLoginMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //whl 上线打开注视
    if (debugMode) {
//        self.changeUrlBtn.hidden = YES;
    }
    [self setupInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - 设置初始化
- (void)setupInit{
    if(![WXApi isWXAppInstalled]){
        [self.weixinLoginBtn removeFromSuperview];
    }
    
    [self.phoneLoginBtn addBorderWidth:1.0 color:[UIColor whiteColor] cornerRadius:21.5];
    [self.weixinLoginBtn addBorderWidth:1.0 color:[UIColor whiteColor] cornerRadius:21.5];
//    [self setupCarouseView];
    
}

#pragma mark - 轮播view
- (void)setupCarouseView
{
    [self setupLeftCarouseView];
    
    [self setupRightCarouseView];
  
}

- (void)setupLeftCarouseView
{
    NJCarouseView * leftCarouseView = [[NJCarouseView alloc] init];
    [self.containerView insertSubview:leftCarouseView atIndex:0];
    
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.alpha = 0.6;
//    //必须给effcetView的frame赋值,因为UIVisualEffectView是一个加到UIIamgeView上的子视图.
//    effectView.frame = CGRectMake(0, 0, HDScreenW, HDScreenH);
//    [leftCarouseView addSubview:effectView];
    [leftCarouseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.containerView);
        //倍数的关系multipliedBy。width是self.containerView的0.5倍
        make.width.mas_equalTo(self.containerView).multipliedBy(0.5);
    }];
    
    self.leftCarouseView = leftCarouseView;
    leftCarouseView.carouseImageArr = self.leftImageArr;
    CGFloat firstImageViewHeight = self.leftImageArr.firstObject.imageViewHeight;
    leftCarouseView.scrollTime = 25.0;
    leftCarouseView.scrollOffSetY = firstImageViewHeight;
    leftCarouseView.scrollDistance = firstImageViewHeight;
    leftCarouseView.direction = NJCarouseViewScrollDirectionUp;
    
    [leftCarouseView beginAnimation];
}

- (void)setupRightCarouseView
{
    NJCarouseView * rightCarouseView = [[NJCarouseView alloc] init];
    [self.containerView insertSubview:rightCarouseView atIndex:0];
    [rightCarouseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.containerView);
        make.width.mas_equalTo(self.containerView).multipliedBy(0.5);
    }];
    
    self.rightCarouseView = rightCarouseView;
    rightCarouseView.carouseImageArr = self.rightImageArr;
    
    //取左边数组第一个
    CGFloat firstImageViewHeight = self.leftImageArr.firstObject.imageViewHeight;
    rightCarouseView.scrollTime = 25.0;
    rightCarouseView.scrollOffSetY = 0;
    rightCarouseView.scrollDistance = firstImageViewHeight;
    rightCarouseView.direction = NJCarouseViewScrollDirectionDown;
    
    [rightCarouseView beginAnimation];
}

#pragma mark - 网络请求

//微信登录
- (void)weChatLogin:(NSDictionary *)userInfo
{
    
    
//    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.phoneNumberTextF.text] forKey:@"username"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",userInfo[@"headimgurl"]] forKey:@"avatar"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.codeTextF.text] forKey:@"code"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",userInfo[@"openid"]] forKey:@"open_id"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",userInfo[@"nickname"]] forKey:@"nickname"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",userInfo[@"sex"]] forKey:@"sex"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",userInfo[@"city"]] forKey:@"city"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",userInfo[@"country"]] forKey:@"county"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",self.pwdTextF.text] forKey:@"wx_unionid"];
    
    
//    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
//    [postParams setValue:[NSString stringWithFormat:@"%@",userInfo[@"headimgurl"]] forKey:@"avatar"];
//    [postParams setValue:[NSString stringWithFormat:@"%@",userInfo[@"openid"]] forKey:@"open_id"];
//
//    [NJProgressHUD show];
//    [[NetAPIManager instance] postWithPath:@"User/wxlogin" parameters:postParams finished:^(HDError * _Nullable error, id object, BOOL isLast, id result) {
//        [NJProgressHUD dismiss];
//
//        NSLog(@"error-----%@",error);
//        if (error) {
//            if(error.code ==1004){
//                NJForceBindPhoneNumberVC * forceBindPhoneNumberVC = [[NJForceBindPhoneNumberVC alloc] init];
//                forceBindPhoneNumberVC.userInfos =userInfo;
//                [self.navigationController pushViewController:forceBindPhoneNumberVC animated:YES];
//                return;
//            }else{
//                [HDHelper say:error.desc];
//                return ;
//            }
//        }
//        NSDictionary *respons = result;
//        NSDictionary * dataDic = respons[DictionaryKeyData];
//        //字典转模型
////        HLTokenModel * tokenmodel = [HLTokenModel mj_objectWithKeyValues:dataDic];
//        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
////        [userDefaults setValue:tokenmodel.token forKey:NJUserDefaultLoginUserToken];
//        [self DataInit];
//
//    }];
    
    
    
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
    
//    //    NSString * token = [NJLoginTool getUserToken];
//    //    @{@"token":token}
//    NSString * token = [NJLoginTool getUserToken];
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
- (IBAction)phoneLoginBtnClick:(id)sender {
    NJValidationCodeLoginVC * loginVC = [[NJValidationCodeLoginVC alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (IBAction)weixinLoginBtnClick:(id)sender {
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

- (IBAction)userProtocolBtnClick:(id)sender {
    NJWebVC * webVC = [[NJWebVC alloc] init];
    webVC.titleStr = @"用户协议";
//    webVC.urlStr = [NJProtocolPrefix stringByAppendingPathComponent:@"user_xy.html"];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 懒加载
- (NSArray<NJLoginCarouseImageItem *> *)leftImageArr
{
    if(_leftImageArr == nil)
    {
        NSMutableArray<NJLoginCarouseImageItem *> * leftImageArrM = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            NSString * imageName = [NSString stringWithFormat:@"img_login_left_%ld", i + 1];
            NJLoginCarouseImageItem * imageItem = [[NJLoginCarouseImageItem alloc] init];
            imageItem.carouseImage = [UIImage imageNamed:imageName];
            [leftImageArrM addObject:imageItem];
        }
        _leftImageArr = [NSArray arrayWithArray:leftImageArrM];
    }
    return _leftImageArr;
}

- (NSArray<NJLoginCarouseImageItem *> *)rightImageArr
{
    if(_rightImageArr == nil)
    {
        NSMutableArray<NJLoginCarouseImageItem *> * rightImageArrM = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            NSString * imageName = [NSString stringWithFormat:@"img_login_right_%ld", i + 1];
            NJLoginCarouseImageItem * imageItem = [[NJLoginCarouseImageItem alloc] init];
            imageItem.carouseImage = [UIImage imageNamed:imageName];
            [rightImageArrM addObject:imageItem];
        }
        _rightImageArr = [NSArray arrayWithArray:rightImageArrM];
    }
    return _rightImageArr;
}

#pragma mark - 其他
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
- (IBAction)changeUrlClick:(id)sender {


  [[UrlManage urlManage] changeUrl];
}

@end