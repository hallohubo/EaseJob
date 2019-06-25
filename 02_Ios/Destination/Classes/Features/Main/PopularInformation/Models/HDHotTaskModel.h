//
//  HDPopularInformationModel.h
//  Destination
//
//  Created by 胡勃 on 6/25/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDHotTaskModel : NSObject
@property (strong, nonatomic) NSString *TaskID;  //任务ID
@property (strong, nonatomic) NSString *TaskNo;  //任务编号
@property (strong, nonatomic) NSString *TaskType;  //任务类型
@property (strong, nonatomic) NSString *TaskIcon;  //任务类型图标
@property (strong, nonatomic) NSString *TaskPayType;  //是否垫付（1=是，0=否）
@property (strong, nonatomic) NSString *TaskTitle;  //任务标题
@property (strong, nonatomic) NSString *Quantity;  //任务总数量
@property (strong, nonatomic) NSString *Commission;  //佣金(元)
@property (strong, nonatomic) NSString *MarginCharge;  //保证金(元)，即垫资
@property (strong, nonatomic) NSString *FreightFee;  //运费(元)
@property (strong, nonatomic) NSString *HasSaleNum;  //已接单数

@end

NS_ASSUME_NONNULL_END
