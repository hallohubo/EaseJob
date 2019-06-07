//
//  NJDatabaseManager.h
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/5/22.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase,NJDraftDiscoveryItem;
@interface NJDatabaseManager : NSObject
//单例方法
+ (instancetype)defaultDatabaseManager;
//获取数据库路径
- (NSString *)getDatabasePath;
    
//添加数据
//- (BOOL)insertDraft:(NJDraftDiscoveryItem *)item;

//更新指定ID的信息
//- (BOOL)updateDraft:(NJDraftDiscoveryItem *)item;

//获取指定用户的信息
- (NSArray<NJDraftDiscoveryItem *> *)getDraftWithPid:(NSNumber *)DID;
//获取全部信息
- (NSArray<NJDraftDiscoveryItem *> *)getAllDrafts;

//删除指定ID的信息
- (BOOL)removeDraftWithID:(NSInteger)ID;
//删除全部数据
- (BOOL)removeAllDraft;


- (void)closeDB;
@end
