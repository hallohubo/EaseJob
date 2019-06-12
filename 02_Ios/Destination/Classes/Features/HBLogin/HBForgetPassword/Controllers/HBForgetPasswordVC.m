//
//  HBForgetPasswordVC.m
//  Destination
//
//  Created by 胡勃 on 6/12/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBForgetPasswordVC.h"

@interface HBForgetPasswordVC ()
{
    IBOutlet UITextField        *tfPhone;
    IBOutlet UITextField        *tfCode;
    IBOutlet UIButton           *btnGetCode;
    IBOutlet UIButton           *btnSubmit;
    NSURLSessionDataTask        *task;
}

/********* 定时器 *********/
@property(nonatomic, strong) dispatch_source_t timer;
@end

@implementation HBForgetPasswordVC

#pragma mark life cycle

-(void)viewWillDisappear:(BOOL)animated
{
    task = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UI event

- (IBAction)btnRegisterClick:(UIButton *)sender
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
    
    if(tfCode.text.length == 0) {
        [NJProgressHUD showError:@"验证码不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSDictionary *dic = @{@"mobile":HDSTR(tfPhone.text), @"validCode":HDSTR(tfCode.text)};
    
    [self HttpPostRegisterRequest:dic];
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

- (void)getPhoneVeriCode //获取验证码
{
    [LBXAlertAction sayWithTitle:@"提示" message:HDFORMAT(@"我们将下发短信验证码，请确认手机号：%@", tfPhone.text) buttons:@[@"取消", @"确认"] chooseBlock:^(NSInteger buttonIdx) {
        if (buttonIdx == 0) {
            return ;
        }
        NSDictionary *dic = @{@"mobile": HDSTR(tfPhone.text), @"flag": @"2"};//1 为h登录, 2为忘记密码
        Dlog(@"-----dic:%@", dic);
        [self httpGetCode:dic];
    }];
}

#pragma mark - http event

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
        [tfCode becomeFirstResponder];
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
    task = [helper postPath:@"Act106" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        Dlog(@"json:%@",json);
        NSDictionary *respons = json;
        NSString *str = JSON(json[@"IsValid"]);
        Dlog(@"isvalid:%@",respons);
        
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
                btnGetCode.userInteractionEnabled = NO;
                [btnGetCode setTitleColor:HDCOLOR_RED forState:UIControlStateNormal];
                NSString * titleStr = [[NSString alloc] initWithFormat:@"剩余%dS", timeout];
                [btnGetCode setTitle:titleStr forState:UIControlStateNormal];
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
            btnGetCode.selected = NO;
            [btnGetCode setTitleColor:HDCOLOR_ORANGE forState:UIControlStateNormal];
            [btnGetCode setTitle:@"发送验证码" forState:UIControlStateNormal];
            btnGetCode.userInteractionEnabled = YES;
        });
    }
}

#pragma mark - getter and setter

- (void)setupUI
{
    self.title = @"忘记密码";
    [btnSubmit addBorderWidth:.0f color:nil cornerRadius:25.f];
    [HDHelper changeColor:btnSubmit];
}

@end
