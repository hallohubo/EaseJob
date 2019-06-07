//
//  NJPayTool.h
//  SmartCity
//
//  Created by TouchWorld on 2018/5/8.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>
typedef NS_ENUM(NSUInteger, PayToolType)
{
    PayToolTypeNaviAndParameterUnlockPay = 0, //导航和图片参数解锁
    PayToolTypeReward, //打赏
    PayToolTypeRecharge //充值
};
@class NJPayTool;

@protocol NJPayToolDelegate <NSObject>

@required
/**
 支付成功

 @param payTool payTool
 @param type 类型
 */
- (void)paySuccess:(NJPayTool *)payTool type:(PayToolType)type;


/**
 支付成功（支付取消）

 @param payTool payTool
 @param type 类型
 */
- (void)payFailure:(NJPayTool *)payTool type:(PayToolType)type;

@end

@interface NJPayTool : NSObject <WXApiDelegate>
+ (instancetype)shareInstance;

/********* deleagete *********/
@property(nonatomic,weak)id<NJPayToolDelegate> delegate;


/********* 类型 *********/
@property(nonatomic,assign)PayToolType type;


/**
 支付宝

 @param orderStr 订单信息
 */
//- (void)alipayWithOrderStr:(NSString *)orderStr;


/**
 微信支付

 @param dataDic 订单信息
 */
- (void)weixinPayWithOrderInfo:(NSDictionary *)dataDic;
@end
