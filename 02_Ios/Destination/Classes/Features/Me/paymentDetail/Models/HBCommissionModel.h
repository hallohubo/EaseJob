//
//  HBCommissionModel.h
//  Destination
//
//  Created by 胡勃 on 7/8/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBCommissionModel : NSObject
@property (nonatomic, strong) NSString *ChargeId;  //会员开支记录ID
@property (nonatomic, strong) NSString *SerialNo;  //任务订单号/流水号
@property (nonatomic, strong) NSString *Charge;  //金额（元）
@property (nonatomic, strong) NSString *ChargeDesc;  //收支账目描述
@property (nonatomic, strong) NSString *OperateDT;  //操作时间
@property (nonatomic, strong) NSString *Status;  //状态
@property (nonatomic, strong) NSString *Remark;  //备注

@end

NS_ASSUME_NONNULL_END
