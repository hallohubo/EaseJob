//
//  HBUpdateToVIP.m
//  Destination
//
//  Created by 胡勃 on 7/3/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBUpdateToVIPVC.h"

@interface HBUpdateToVIPVC ()
{
    IBOutlet UIButton   *btnOpenVIP;
    IBOutlet UILabel    *lbPerMonth;
    IBOutlet UILabel    *lbLable;       //rectangle stip mark
    IBOutlet UILabel    *lbForever;
    IBOutlet UILabel    *lbPerMonthTitle;
    IBOutlet UILabel    *lbForeverTitle;
    IBOutlet UITextView *tvExplain;
    IBOutlet NSLayoutConstraint *lcTextviewHeight;
    IBOutlet NSLayoutConstraint *lcContentHeight;
    IBOutlet NSLayoutConstraint *lcForeverTitleWidth;

    NSURLSessionTask    *task;
    NSString    *strMemberType;
    NSString    *strDueDate;
}

@end

@implementation HBUpdateToVIPVC

#pragma mark - life cycle

- (void)viewDidAppear:(BOOL)animated
{
    [self httpGetInitParameter];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
    [self httpGetExplainWriting];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - ui touch event

- (IBAction)touchOpenButton:(UIButton *)sender
{
    if (strMemberType.length == 0) {
        return;
    }
    
}

#pragma mark - http event

- (void)httpGetInitParameter
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"type": HDSTR(@"8,9")};
    [helper.parameters addEntriesFromDictionary:dic];
    
    [NJProgressHUD show];
    task = [helper postPath:@"Act115" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        if (!json) {
            return;
        }
        
        NSString *strMonth  = JSON(json[@"VIPFeePerMonth"]);
        NSString *strFor    = JSON(json[@"VIPFeeForever"]);
        strMemberType   = JSON(json[@"MemberGroup"]);
        strDueDate  = JSON(json[@"DueDate"]);
        
        if ([strMemberType isEqualToString:@"普通会员"] || strDueDate.length == 0) {
            lbPerMonth.text = strMonth.length>0? HDFORMAT(@"%.2f元", strMonth.floatValue) : HDFORMAT(@"--元");
            lbForever.text  = strFor.length>0? HDFORMAT(@"%.2f元", strFor.floatValue) : HDFORMAT(@"--元");
            btnOpenVIP.titleLabel.text = @"开通会员";
            lbForeverTitle.text = @"永久";
            lcForeverTitleWidth.constant = 45.f;
        }
        
        if ([strMemberType isEqualToString:@"包月VIP会员"] || strDueDate.length > 6) {
            lbPerMonth.text = strMonth.length>0? HDFORMAT(@"%.2f元", strMonth.floatValue) : HDFORMAT(@"--元");
            lbForever.text  = strDueDate;
            lbForeverTitle.text = @"到期时间";
            lcForeverTitleWidth.constant = 75.f;
            btnOpenVIP.titleLabel.text = @"续费";
        }
        
        if ([strMemberType isEqualToString:@"永久VIP会员"] || [strDueDate isEqualToString:@"永久"]) {
            lbPerMonth.text = strMonth.length>0? HDFORMAT(@"%.2f元", strMonth.floatValue) : HDFORMAT(@"--元");
            lbForever.text  = @"2119年01月01日";
            lbForeverTitle.text = @"到期时间";
            lbPerMonthTitle.text= @"永久";
            btnOpenVIP.hidden   = YES;
            lcForeverTitleWidth.constant = 75.f;
        }

    }];
}


- (void)httpGetExplainWriting
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"type": HDSTR(@"8,9")};
    [helper.parameters addEntriesFromDictionary:dic];
    
    [NJProgressHUD show];
    task = [helper postPath:@"Act005" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [HDHelper say:error.desc];
            return ;
        }
        NSArray *ar = json[@"List"];
        NSString *priceNote     = nil;
        for (int i = 0; i < ar.count; i++) {
            NSDictionary *d = ar[i];
            NSString *t = HDFORMAT(@"%@", d[@"Type"]);
            int type = t.intValue;
            if (type == 9) {
                priceNote = d[@"Content"];
            }
        }
        
        NSAttributedString *as  = [HDStringHelper htmlString:priceNote];
        tvExplain.attributedText= as;
        CGSize size = CGSizeMake(HDDeviceSize.width - 20, 0);
        CGRect rect = [as boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat height = CGRectGetHeight(rect);
        height = height + 10;
        
        lcTextviewHeight.constant   = height+30;
        lcContentHeight.constant    = lcTextviewHeight.constant > 900? lcTextviewHeight.constant : 900;
    }];
}

#pragma mark - setter

- (void)setupInit
{
    self.title = @"vip中心";
        
    btnOpenVIP.layer.cornerRadius = 15.f;
    btnOpenVIP.layer.masksToBounds= YES;
    lbLable.layer.cornerRadius = 2.f;
    lbLable.layer.masksToBounds= YES;

}
@end
