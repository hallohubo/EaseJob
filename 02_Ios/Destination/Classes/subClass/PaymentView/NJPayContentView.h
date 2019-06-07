//
//  NJPayContentView.h
//  Destination
//
//  Created by TouchWorld on 2018/12/15.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NJPayContentView : UIView
/********* 费用 *********/
@property(nonatomic,strong)NSString * feeStr;
/********* 标题 *********/
@property(nonatomic,strong)NSString * titleStr;
/********* <#注释#> *********/
@property(nonatomic,copy)void (^cancelBlock)(void);
/********* 0:微信支付 1：余额支付 *********/
@property(nonatomic,assign)NSInteger payType;
/********* <#注释#> *********/
@property(nonatomic,copy)void (^confirmBlock)(NSInteger payType);



@end

NS_ASSUME_NONNULL_END
