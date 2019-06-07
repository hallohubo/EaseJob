//
//  NJRewardListView.h
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NJRewardListView : UIView
/********* 取消 *********/
@property(nonatomic,copy)void (^cancelBlock)(void);
@property (weak, nonatomic) IBOutlet UITextField *moneyTextF;
/********* 0:微信支付 1：余额支付 *********/
@property(nonatomic,assign)NSInteger payType;
/********* <#注释#> *********/
@property(nonatomic,copy)void (^confirmBlock)(NSString * rewardMoney, NSInteger payType);

/********* <#注释#> *********/
@property(nonatomic,strong)NSString * moneyStr;

@end

NS_ASSUME_NONNULL_END
