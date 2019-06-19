//
//  HBNewsModle.h
//  Destination
//
//  Created by 胡勃 on 6/19/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBNewsModle : NSObject
@property (nonatomic, strong) NSString *NoticeID;       //公告ID
@property (nonatomic, strong) NSString *NoticeTitle;    //公告标题
@property (nonatomic, strong) NSString *NoticeContent;  //公告内容（请求列表时，该字段返回空串）
@property (nonatomic, strong) NSString *PublishDT;      //公告发布日期
@end

NS_ASSUME_NONNULL_END
