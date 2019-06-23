//
//  HBNewsModel.h
//  Destination
//
//  Created by 胡勃 on 6/23/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBTaskNewsModel : NSObject
@property (nonatomic, strong) NSString *TaskID;     //任务ID
@property (nonatomic, strong) NSString *TaskNo;     //任务编号
@property (nonatomic, strong) NSString *TaskType;   //任务类型
@property (nonatomic, strong) NSString *TaskIcon;   //任务类型图标
@property (nonatomic, strong) NSString *TaskPayType;    //是否垫付（1=是，0=否）
@property (nonatomic, strong) NSString *TaskTitle;      //任务标题
@property (nonatomic, strong) NSString *Quantity;       //任务总数量
@property (nonatomic, strong) NSString *Commission;     //佣金(元)
@property (nonatomic, strong) NSString *MarginCharge;   //保证金(元)，即垫资
@property (nonatomic, strong) NSString *FreightFee;     //运费(元)
@property (nonatomic, strong) NSString *HasSaleNum;     //已接单数
@end

