//
//  NetAPIManager.h
//  ConsumptionPlus
//
//  Created by TouchWorld on 2017/10/26.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestConst.h"
#import <AFNetworking.h>
#import "NJRecursiveDataItem.h"
#import "NJRecursiveItem.h"

#define JSON(P) [NetAPIManager json:P]
#define ResultTypeSuccess 200

@interface HDError : NSObject

/*!
 @property
 @brief 错误代码
 */
@property (nonatomic) int code;

/*!
 @property
 @brief 错误信息描述
 */
@property (nonatomic, copy) NSString * _Nullable desc;

@end


//请求成功回调
typedef void (^RequestManagerSuccessBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);

//请求失败回调
typedef void (^RequestManagerFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

typedef void (^ConstructingBodyWithBlock)(id <AFMultipartFormData> _Nullable formData);

//进度回调
typedef void (^RequestProgressBlock)(NSProgress * _Nonnull);

typedef void (^RequestRecursiveProgressBlock)(double progress);

//typedef void(^ReturnBlock)(id data, NSError * error);

@interface NetAPIManager : NSObject

//单例方法
+ (instancetype _Nullable)sharedManager;
+ (instancetype _Nullable)instance;

+ (NSString *_Nonnull)json:(id _Nullable )object;

- (void)postWithPath:(NSString *_Nullable)path parameters:(NSDictionary *_Nullable)p finished:(void (^_Nullable)(HDError * _Nullable error, id _Nullable object, BOOL isLast, id _Nonnull result))block;

/**
 GET方法

 @param URLString 地址
 @param parameters 参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters successBlock:(RequestManagerSuccessBlock _Nullable)successBlock failureBlock:(RequestManagerFailureBlock _Nullable)failureBlock;


/**
 POST方法

 @param URLString 地址
 @param parameters 参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters successBlock:(RequestManagerSuccessBlock _Nullable)successBlock failureBlock:(RequestManagerFailureBlock _Nullable)failureBlock;


/**
 文件上传-通过NSData上传

 @param URLString 地址
 @param parameters 参数
 @param fileData 文件数据
 @param name 服务器接口规定的key
 @param fileName 文件名
 @param mimeType 上传文件的MIMEType类型
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)uploadFile:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters fileData:(NSData *_Nullable)fileData name:(NSString *_Nullable)name fileName:(NSString *_Nullable)fileName mimeType:(NSString *_Nonnull)mimeType  progressBlock:(RequestProgressBlock _Nullable )progressBlock successBlock:(RequestManagerSuccessBlock _Nullable )successBlock failureBlock:(RequestManagerFailureBlock _Nullable)failureBlock;


/**
 文件上传-通过文件路径上传

 @param URLString 地址
 @param parameters 参数
 @param filePath 文件路径
 @param name 服务器接口规定的key
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)uploadFile:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters filePath:(NSString *_Nullable)filePath name:(NSString *_Nullable)name progressBlock:(RequestProgressBlock _Nullable )progressBlock successBlock:(RequestManagerSuccessBlock _Nullable )successBlock failureBlock:(RequestManagerFailureBlock _Nullable )failureBlock;



/**
 递归上传文件

 @param URLString 地址
 @param fileDataArr 二进制数据
 @param name 服务器接口规定的key
 @param fileName 文件名
 @param mimeType 上传文件的MIMEType类型
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)recursiveUploadFile:(NSString *_Nullable)URLString fileDataArr:(NSArray<NJRecursiveDataItem *> *_Nonnull)fileDataArr name:(NSString *_Nullable)name fileName:(NSString *_Nullable)fileName mimeType:(NSString *_Nullable)mimeType  progressBlock:(RequestRecursiveProgressBlock _Nullable)progressBlock successBlock:(RequestManagerSuccessBlock _Nullable)successBlock failureBlock:(RequestManagerFailureBlock _Nullable)failureBlock;

/**
 多图上传 (任意数量上传)

 @param URLString 地址
 @param parameters 参数
 @param imageArr 图片数组
 @param ratio 压缩比例 （0~1之间）
 @param name 服务器规定的key
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)uploadFile:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters imageArr:(NSArray<UIImage *> *_Nullable)imageArr ratio:(CGFloat)ratio name:(NSString *_Nullable)name progressBlock:(RequestProgressBlock _Nullable)progressBlock successBlock:(RequestManagerSuccessBlock _Nullable)successBlock failureBlock:(RequestManagerFailureBlock _Nullable)failureBlock;

/**
 多图上传 （任意数量）

 @param URLString 地址
 @param parameters 参数
 @param fileDataArr 数据
 @param mimeType 上传文件的MIMEType类型
 @param name 服务器规定的key
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)uploadFile:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters fileDataArr:(NSArray<NSData *> *_Nullable)fileDataArr mimeType:(NSString *_Nullable)mimeType name:(NSString *_Nullable)name  progressBlock:(RequestProgressBlock _Nullable)progressBlock successBlock:(RequestManagerSuccessBlock _Nullable)successBlock failureBlock:(RequestManagerFailureBlock _Nullable)failureBlock;
/**
 下载文件
 
 @param url 网址
 @param savePath 保存路径 默认document
 @param downloadProgressBlock 进度回调
 @param completionHandler 完成回调
 */
+ (void)downloadFileWithUrl:(NSURL *_Nullable)url savePath:(NSString *_Nullable)savePath progress:(void (^_Nullable)(NSProgress * _Nullable downloadProgress)) downloadProgressBlock completionHandler:(void (^_Nonnull)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;


@end

