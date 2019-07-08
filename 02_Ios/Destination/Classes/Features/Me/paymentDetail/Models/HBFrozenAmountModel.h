//
//  HBFrozenAmountModel.h
//  Destination
//
//  Created by 胡勃 on 7/8/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBFrozenAmountModel : NSObject

@property (nonatomic, strong) NSString *TaskID;  //任务ID
@property (nonatomic, strong) NSString *TaskNo;  //任务编号
@property (nonatomic, strong) NSString *TaskPayType;  //任务种类（垫付，非垫付）
@property (nonatomic, strong) NSString *TaskIcon;  //任务类型图标
@property (nonatomic, strong) NSString *TaskTitle;  //任务标题
@property (nonatomic, strong) NSString *FreezingBalance;  //冻结任务余额
@property (nonatomic, strong) NSString *FreezingDeposit;  //冻结保证金
@end

NS_ASSUME_NONNULL_END
