//
//  HBMobileCodeAuthenticationVC.m
//  Destination
//
//  Created by 胡勃 on 7/1/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBMobileCodeAuthenticationVC.h"

@interface HBMobileCodeAuthenticationVC ()
{
    IBOutlet UITextField    *tfVerifyCode;
    IBOutlet UITextField    *tfPhone;
    IBOutlet UIButton       *btnNextStep;
    IBOutlet UIButton       *btnGetVerify;

    NSURLSessionDataTask    *task;
}

/********* 定时器 *********/
@property(nonatomic, strong) dispatch_source_t timer;


@end

@implementation HBMobileCodeAuthenticationVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UI touch event

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

- (IBAction)btnNectClick:(UIButton *)sender
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
    
    if(tfVerifyCode.text.length == 0) {
        [NJProgressHUD showError:@"验证码不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSDictionary *dic = @{@"mobile":HDSTR(tfPhone.text), @"validCode":HDSTR(tfVerifyCode.text)};
    
    [self HttpPostMobileAuthentication:dic];
}


#pragma mark - http event

- (void)getPhoneVeriCode //获取验证码
{
    [LBXAlertAction sayWithTitle:@"提示" message:HDFORMAT(@"我们将下发短信验证码，请确认手机号：%@", tfPhone.text) buttons:@[@"取消", @"确认"] chooseBlock:^(NSInteger buttonIdx) {
        if (buttonIdx == 0) {
            return ;
        }
        NSDictionary *dic = @{@"mobile": HDSTR(tfPhone.text), @"flag": @"3"};//1 为h登录, 2为忘记密码 3为实名认证
        Dlog(@"-----dic:%@", dic);
        [self httpGetCode:dic];
    }];
}

#pragma mark - http event

- (void)httpGetCode:(NSDictionary *)dicParam// reques authentication code
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
        [tfVerifyCode becomeFirstResponder];
        [NJProgressHUD showSuccess:@"验证码下发成功，请注意查收短信！"];
        [NJProgressHUD dismissWithDelay:1.2];
        [self startTime];
    }];
}

- (void)HttpPostMobileAuthentication:(NSDictionary *)dicParam //request authentication
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:dicParam];
    [NJProgressHUD show];
    task = [helper postPath:@"Act114" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
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
                btnGetVerify.userInteractionEnabled = NO;
                [btnGetVerify setTitleColor:HDCOLOR_RED forState:UIControlStateNormal];
                NSString * titleStr = [[NSString alloc] initWithFormat:@"剩余%dS", timeout];
                [btnGetVerify setTitle:titleStr forState:UIControlStateNormal];
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
            btnGetVerify.selected = NO;
            [btnGetVerify setTitleColor:HDCOLOR_ORANGE forState:UIControlStateNormal];
            [btnGetVerify setTitle:@"发送验证码" forState:UIControlStateNormal];
            btnGetVerify.userInteractionEnabled = YES;
        });
    }
}

#pragma mark - setter and getter

- (void)setupInit
{
    self.title = @"实名认证";
    
    [btnNextStep addBorderWidth:.0 color:nil cornerRadius:25.];
    [HDHelper changeColor:btnNextStep];

}

@end
