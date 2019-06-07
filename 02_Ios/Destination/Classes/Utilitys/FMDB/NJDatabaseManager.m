//
//  NJDatabaseManager.m
//  March_thirtyOne_Talk项目
//
//  Created by TouchWorld on 2017/5/22.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJDatabaseManager.h"
#import <FMDB.h>
#import <MJExtension.h>

@interface NJDatabaseManager ()
/********* 数据库 *********/
@property(nonatomic,strong)FMDatabase * database;

@end
@implementation NJDatabaseManager
static NJDatabaseManager * databaseManager;
//单例方法
+ (instancetype)defaultDatabaseManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(databaseManager == nil)
        {
            databaseManager = [[NJDatabaseManager alloc]init];
        }
    });
    return databaseManager;
}

- (id)copy
{
    @throw [NSException exceptionWithName:@"NJDatabaseManager" reason:@"不能用此方法创建对象" userInfo:nil];
    return self;
}
- (id)mutableCopy
{
    @throw [NSException exceptionWithName:@"NJDatabaseManager" reason:@"不能用此方法创建对象" userInfo:nil];
    return self;
}

//获取数据库路径
- (NSString *)getDatabasePath
{
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [docPath stringByAppendingPathComponent:@"db_Destination.sqlite"];
}

//创建数据库
- (FMDatabase *)database
{
    if(_database == nil)
    {
        _database = [FMDatabase databaseWithPath:[self getDatabasePath]];
        //打开数据库
        if([_database open])
        {
            //创建表
            BOOL flag =[_database executeUpdate:@"create table if not exists draft(DID integer primary key autoincrement, maskImage varchar(255) NOT NULL, title varchar(255), content text NOT NULL, publicType integer, createDate varchar(255) NOT NULL)"];
            if(flag)
            {
                NSLog(@"创建表成功");
            }
            else
            {
                NSLog(@"创建表失败");
            }
        }
    }
    return _database;
}

//添加数据
//- (BOOL)insertDraft:(NJDraftDiscoveryItem *)item
//{
//    NSString * contentJSONStr = [[NJDraftDiscoveryContentItem mj_keyValuesArrayWithObjectArray:item.content] mj_JSONString];
//    BOOL success = [self.database executeUpdate:@"insert into draft (maskImage, title, content, publicType, createDate) values (?, ?, ?, ?, ?)", item.maskImage, item.title, contentJSONStr, @(item.publicType), item.createDate];
//    if (!success) {
//        NSLog(@"error = %@", [self.database lastErrorMessage]);
//    }
//    return success;
//}

//删除全部数据
- (BOOL)removeAllDraft
{
    return [self.database executeUpdate:@"delete from draft"];
}

//删除指定ID的信息
- (BOOL)removeDraftWithID:(NSInteger)ID
{
    BOOL success = [self.database executeUpdate:@"delete from draft where DID = ?", @(ID)];
    if (!success) {
        NSLog(@"error = %@", [self.database lastErrorMessage]);
    }
    return success;
}

//更新指定ID的信息
//- (BOOL)updateDraft:(NJDraftDiscoveryItem *)item
//{
//    NSString * contentJSONStr = [[NJDraftDiscoveryContentItem mj_keyValuesArrayWithObjectArray:item.content] mj_JSONString];
//    BOOL success = [self.database executeUpdate:@"update draft set maskImage = ?, title = ? , content = ? , publicType = ? where DID = ?", item.maskImage,  item.title, contentJSONStr, @(item.publicType), @([item.DID integerValue])];
//    if (!success) {
//        NSLog(@"error = %@", [self.database lastErrorMessage]);
//    }
//    return success;
//}

//获取全部信息
- (NSArray<NJDraftDiscoveryItem *> *)getAllDrafts
{
    return [self getDraftWithPid:nil];
}

//获取指定用户的信息
- (NSArray<NJDraftDiscoveryItem *> *)getDraftWithPid:(NSNumber *)DID
{
    FMResultSet * resultSet = nil;
    //1.不为空，返回跟这个好友的聊天记录
    if(DID != nil)
    {
        resultSet = [self.database executeQuery:@"select * from draft where DID = ?", DID];
    }
    //2.为空，返回所有的聊天数据
    else
    {
        //select * from message limit 4 OFFSET 1分页查询
        resultSet = [self.database executeQuery:@"select * from draft order by DID desc"];
    }
    NSMutableArray<NJDraftDiscoveryItem *> * draftArrM = [NSMutableArray array];
    while (resultSet.next) {
//        NJDraftDiscoveryItem * item = [[NJDraftDiscoveryItem alloc] init];
//        item.DID = [NSString stringWithFormat:@"%ld", [resultSet longForColumn:@"DID"]];
//        item.maskImage = [resultSet stringForColumn:@"maskImage"];
//        item.title = [resultSet stringForColumn:@"title"];
//        NSString * contentStr = [resultSet stringForColumn:@"content"];
//
//        item.content = [NJDraftDiscoveryContentItem mj_objectArrayWithKeyValuesArray:(NSArray *)[contentStr mj_JSONObject]];
//        item.publicType = [resultSet longForColumn:@"publicType"];
//        item.createDate = [resultSet stringForColumn:@"createDate"];
        //添加到数组
//        [draftArrM addObject:item];
    }
    return [NSArray arrayWithArray:draftArrM];
}

- (void)closeDB
{
    //关闭数据库
    [self.database close];
}
@end
