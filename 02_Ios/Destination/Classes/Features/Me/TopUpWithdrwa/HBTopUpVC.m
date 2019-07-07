//
//  HBTopUpVC.m
//  Destination
//
//  Created by 胡勃 on 7/5/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBTopUpVC.h"
#import "HDMeModel.h"

@interface HBTopUpVC ()
{
    IBOutlet UITextView *tvExplain;
    
    IBOutlet UIView     *vTopup;
    IBOutlet UIView     *vWithdrawl;
    
    IBOutlet UILabel    *lbBank;
    IBOutlet UILabel    *lbBankAddress;
    IBOutlet UILabel    *lbBankCard;
    IBOutlet UILabel    *lbTopupMount;
    IBOutlet UILabel    *lbTaskBalance;
    IBOutlet UILabel    *lbTaskMargin;
    IBOutlet UILabel    *lbLable;
    
    IBOutlet UIButton   *btnTopup;
    IBOutlet UIButton   *btnTaskBalancd;
    IBOutlet UIButton   *btnTaskMarbin;
    
    IBOutlet UIView     *vLineContain;
    IBOutlet UIView     *vNeedCorner;
    IBOutlet UIView     *vBankContain;
    IBOutlet UIView     *vBankInsideContain;
    IBOutlet NSLayoutConstraint *lcDistanceInRoll;
    
    NSURLSessionTask    *task;
    HDMeModel   *model;
}

@end

@implementation HBTopUpVC

- (instancetype)initWithModel:(HDMeModel *)IModel
{
    self = [super init];
    if (self) {
        model = IModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitUI];
    [self httpGetExplainWriting];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - touch button event

- (IBAction)touchBalanceOrMarbin:(UIButton *)sender
{
    lcDistanceInRoll.constant = HDDeviceSize.width * 0.5 * sender.tag;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
   
    sender.selected = !sender.selected;
    if ([sender isEqual:btnTaskBalancd]) {
        btnTaskMarbin.selected = !btnTaskBalancd.selected;
       
    }else {
        btnTaskBalancd.selected = !btnTaskMarbin.selected;
    }
    
    vBankContain.hidden = !btnTaskMarbin.selected;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];

}

#pragma mark - http event

- (void)httpGetExplainWriting
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"type": HDSTR(@"7")};
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
            if (type == 7) {
                priceNote = d[@"Content"];
            }
        }

        NSAttributedString *as  = [HDStringHelper htmlString:priceNote];
        tvExplain.attributedText= as;
        CGSize size = CGSizeMake(HDDeviceSize.width - 20, 0);
        CGRect rect = [as boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGFloat height = CGRectGetHeight(rect);
        height = height + 10;

//        lcDistanceInRoll.constant   = height+30;
//        lcContentHeight.constant    = lcTextviewHeight.constant > 900? lcTextviewHeight.constant : 900;
   }];
}
#pragma mark - setter and getter

- (void)setInitUI
{
    self.title = @"充值";
    
    btnTaskBalancd.selected = YES;
    btnTaskMarbin.selected  = NO;
    lcDistanceInRoll.constant = 0.f;
    vBankContain.hidden = YES;
    
    btnTopup.layer.cornerRadius = 20.f;
    btnTopup.layer.masksToBounds= YES;
    
    vBankInsideContain.layer.cornerRadius = 8.f;
    vBankInsideContain.layer.masksToBounds= YES;
    
    vNeedCorner.layer.cornerRadius  = 8.f;
    vNeedCorner.layer.masksToBounds = YES;
    
    [HDHelper changeColor:btnTopup];
    [HDHelper changeViewColor:vBankInsideContain];
    
    lbTaskBalance.text = model.TaskBalance.length > 0 ? model.TaskBalance : @"--";
    lbTaskMargin.text = model.MarginBalance.length > 0 ? model.MarginBalance : @"--";
}


@end
