//
//  NJRewardListView.m
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJRewardListView.h"
@interface NJRewardListView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *inputContainerView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmBtnClick:(UIButton *)sender;
- (IBAction)cancelBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *weixinSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *balanceSelectBtn;
- (IBAction)weixinPayViewClick:(UITapGestureRecognizer *)sender;
- (IBAction)balancePayViewClick:(UITapGestureRecognizer *)sender;

@end
@implementation NJRewardListView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.payType = 0;
    
    [self.inputContainerView addBorderWidth:0.5 color:NJGrayColor(151) cornerRadius:4.0];
    
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 2.0;
    
    self.moneyTextF.delegate = self;
    [self.moneyTextF addTarget:self action:@selector(inputMoneyChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton * completedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completedBtn.frame = CGRectMake(0, 0, 50, 44);
    [completedBtn setTitle:@"完成" forState:UIControlStateNormal];
    completedBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [completedBtn setTitleColor:NJGrayColor(51) forState:UIControlStateNormal];
    [completedBtn addTarget:self action:@selector(completedBtnClick) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, HDScreenW, 44)];
    UIBarButtonItem * completedItem = [[UIBarButtonItem alloc] initWithCustomView:completedBtn];
    UIBarButtonItem * flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[flexItem, completedItem];
    self.moneyTextF.inputAccessoryView = toolBar;
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
    NSString * moneyText = self.moneyTextF.text;
    if(moneyText == nil || moneyText.length == 0)
    {
        [NJProgressHUD showError:@"打赏金额不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if([moneyText integerValue] == 0)
    {
        [NJProgressHUD showError:@"打赏金额不能为0"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(self.confirmBlock != nil)
    {
        self.confirmBlock(moneyText, self.payType);
    }
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    if(self.cancelBlock != nil)
    {
        self.cancelBlock();
    }
}

#pragma mark - 其他
- (void)inputMoneyChange:(UITextField *)moneyTextF
{
    NSString * text = moneyTextF.text;
    if([text isEqualToString:@"."])
    {
        text = @"0.";
    }
    moneyTextF.text = text;
}


#pragma mark - UITextFieldDelegate方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * oldText = textField.text;
    //    HDLog(@"%@--%@", textField.text, string);
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

- (IBAction)weixinPayViewClick:(UITapGestureRecognizer *)sender {
    self.payType = 0;
}

- (IBAction)balancePayViewClick:(UITapGestureRecognizer *)sender {
    self.payType = 1;
}

- (void)setPayType:(NSInteger)payType
{
    _payType = payType;
    
    
    self.weixinSelectBtn.selected = payType == 0;
    self.balanceSelectBtn.selected = payType == 1;
}

- (void)setMoneyStr:(NSString *)moneyStr
{
    _moneyStr = moneyStr;
    self.moneyTextF.text = moneyStr;
}

- (void)completedBtnClick
{
    [self.moneyTextF resignFirstResponder];
}
@end
