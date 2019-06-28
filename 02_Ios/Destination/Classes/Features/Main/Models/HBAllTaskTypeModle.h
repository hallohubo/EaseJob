//
//  HBAllTaskTypeModle.h
//  Destination
//
//  Created by 胡勃 on 6/27/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBAllTaskTypeModle : NSObject//api:Act201

@property (nonatomic, strong) NSString *TaskTypeID;     //任务类型ID
@property (nonatomic, strong) NSString *TaskType;       //任务类型名称
@property (nonatomic, strong) NSString *TaskIcon;       //任务图标
@property (nonatomic, strong) NSString *TaskPayType;    //是否垫付（是1，否0）
@property (nonatomic, strong) NSString *MinPrice;       //最低出价
@property (nonatomic, strong) NSString *MinQuantity;    //最低单数
@property (nonatomic, strong) NSString *PlusVerifyImgPrice;     //1验证图出价
@property (nonatomic, strong) NSString *MinVerifyImgNum;        //最小验证图数量
@property (nonatomic, strong) NSString *MaxVerifyImgNum;        //最大验证图数量
@property (nonatomic, strong) NSString *OrderValue;             //排序号
@property (nonatomic, strong) NSString *HasSetFreight;          //是否设置运费（是1，否0）
@property (nonatomic, strong) NSString *FreightList;            //任务类型运费区间列表                                                       FreightID：垫付任务的运费设置区间ID；LowerLimit：                                            垫付区间下限(元)；UpperLimit：垫付区间上限(元)；FreightPrice：运费价格

+ (id)readFromLocal;
- (void)saveToLocal;
+ (void)clearFromLocal;
@end

NS_ASSUME_NONNULL_END
