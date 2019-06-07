//
//  NJPayContentView.m
//  Destination
//
//  Created by TouchWorld on 2018/12/15.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJPayContentView.h"
//#import "NJPictureFeeItem.h"

@interface NJPayContentView ()
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmBtnClick:(UIButton *)sender;
- (IBAction)cancelBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *weixinSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *balanceSelectBtn;
- (IBAction)weixinPayViewClick:(UITapGestureRecognizer *)sender;
- (IBAction)balancePayViewClick:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
@implementation NJPayContentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.confirmBtn addAllCornerRadius:4.0];
    self.payType = 0;
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
    if(self.confirmBlock != nil)
    {
        self.confirmBlock(self.payType);
    }
}

- (IBAction)cancelBtnClick {
    if(self.cancelBlock != nil)
    {
        self.cancelBlock();
    }
}
- (IBAction)weixinPayViewClick:(UITapGestureRecognizer *)sender {
    self.payType = 0;
}

- (IBAction)balancePayViewClick:(UITapGestureRecognizer *)sender {
    self.payType = 1;
}

- (void)setFeeStr:(NSString *)feeStr
{
    _feeStr = feeStr;
    self.feeLabel.text = feeStr;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

- (void)setPayType:(NSInteger)payType
{
    _payType = payType;
    
    
    self.weixinSelectBtn.selected = payType == 0;
    self.balanceSelectBtn.selected = payType == 1;
}
@end
