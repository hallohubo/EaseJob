//
//  HBUpdateToVIP.m
//  Destination
//
//  Created by 胡勃 on 7/3/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBUpdateToVIP.h"

@interface HBUpdateToVIP ()
{
    IBOutlet UIButton   *btnOpenVIP;
    IBOutlet UILabel    *lbPerMonth;
    IBOutlet UILabel    *lbLable;
    IBOutlet UILabel    *lbForever;
    IBOutlet UITextView *tvExplain;
    IBOutlet NSLayoutConstraint *lcTextviewHeight;
    IBOutlet NSLayoutConstraint *lcContentHeight;
    NSURLSessionTask    *task;
}

@end

@implementation HBUpdateToVIP

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
    [self httpGetExplainWriting];
    [self httpGetInitParameter];
    // Do any additional setup after loading the view from its nib.
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
        lbPerMonth.text = strMonth.length>0? HDFORMAT(@"%.2f元", strMonth.floatValue) : HDFORMAT(@"--");
        lbForever.text  = strFor.length>0? HDFORMAT(@"%.2f元", strFor.floatValue) : HDFORMAT(@"--");
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
