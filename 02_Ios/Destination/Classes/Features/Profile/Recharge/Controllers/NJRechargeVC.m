//
//  NJRechargeVC.m
//  Destination
//
//  Created by TouchWorld on 2018/10/12.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJRechargeVC.h"
#import "NJRechargeSuccessVC.h"
#import "NJPayTool.h"

@interface NJRechargeVC () <UITextFieldDelegate, NJPayToolDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyTextF;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;


- (IBAction)rechargeBtnClick;

@end

@implementation NJRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupInit];
}

#pragma mark - 设置初始化
- (void)setupInit
{
    self.title = @"充值";
    
    self.rechargeBtn.layer.masksToBounds = YES;
    self.rechargeBtn.layer.cornerRadius = 4.0;
    
    self.moneyTextF.delegate = self;
    [self.moneyTextF addTarget:self action:@selector(inputMoneyChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 网络请求
- (void)withdrawRequestWithAmount:(NSString *)amount
{
    [NJProgressHUD show];
    [NetRequest weixinRechargeWithMoney:amount completedBlock:^(id data, NSError *error) {
        [NJProgressHUD dismiss];
        if(!error)
        {
            NSDictionary * dataDic = data[DictionaryKeyData];
            [NJPayTool shareInstance].delegate = self;
            [NJPayTool shareInstance].type = PayToolTypeRecharge;
            [[NJPayTool shareInstance] weixinPayWithOrderInfo:dataDic];
        }
        else
        {
            NJLog(@"%@", error);
        }
    }];
}

#pragma mark - UITextFieldDelegate方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * oldText = textField.text;
    //    NJLog(@"%@--%@", textField.text, string);
    //多个.
    if([oldText containsString:@"."] && [string containsString:@"."])
    {
        return NO;
    }
    
    //.12
    NSString * regex = @"^\\d+\\.\\d{2}$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([predicate evaluateWithObject:oldText] && string.length > 0)
    {
        return NO;
    }
    return YES;
}

#pragma mark - NJPayToolDelegate方法
- (void)paySuccess:(NJPayTool *)payTool type:(PayToolType)type
{
    if(type == PayToolTypeRecharge)
    {
        NSString * text = self.moneyTextF.text;
        CGFloat withdrawMoney = [text floatValue];
        if(withdrawMoney <= 0)
        {
            return;
        }
        
        NJRechargeSuccessVC * rechargeSuccessVC = [[NJRechargeSuccessVC alloc] init];
        rechargeSuccessVC.rechargeMoney = [NSString stringWithFormat:@"%.2f", withdrawMoney];
        [self.navigationController pushViewController:rechargeSuccessVC animated:YES];
    }
}

- (void)payFailure:(NJPayTool *)payTool type:(PayToolType)type
{
    if(type == PayToolTypeRecharge)
    {
        [NJProgressHUD showSuccess:@"充值失败"];
        [NJProgressHUD dismissWithDelay:1.2];
    }
}

#pragma mark - 事件
- (IBAction)rechargeBtnClick {
    NSString * text = self.moneyTextF.text;
    CGFloat withdrawMoney = [text floatValue];
    if(withdrawMoney <= 0)
    {
        return;
    }
    NJLog(@"提现金额：%.2f", withdrawMoney);
    [self withdrawRequestWithAmount:[NSString stringWithFormat:@"%.2f", withdrawMoney]];
}


- (void)inputMoneyChange:(UITextField *)moneyTextF
{
    NSString * text = moneyTextF.text;
    if([text isEqualToString:@"."])
    {
        text = @"0.";
    }
    moneyTextF.text = text;
    NJLog(@"%@", text);
    
}


@end
