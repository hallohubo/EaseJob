//
//  NetAPIManager.m
//  ConsumptionPlus
//
//  Created by TouchWorld on 2017/10/26.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import "NetAPIManager.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "NJUserItem.h"

//#define HDDOMAIN @"http://app.test.yqxsy.cn"  //测试环境
#define HDDOMAIN @"http://app.yqxsy.cn"         //生产环境
#define URLSTRING [NetAPIManager getUrl]

@implementation NetAPIManager
static NetAPIManager * sharedManager = nil;
+ (instancetype)sharedManager{
    if(sharedManager == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[NetAPIManager alloc] init];
        });
    }
    return sharedManager;
}
+ (instancetype)instance{
    if(sharedManager == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[NetAPIManager alloc] init];
        });
    }
    return sharedManager;
}

+ (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@/api/", HDDOMAIN];
}

+ (NSString *)json:(id)object{
    if ([object isKindOfClass:[NSNull class]]) {
        object = @"";
    }
    NSString *s = HDFORMAT(@"%@", object);
    BOOL isNull1 = [s isEqualToString:@"<null>"] || [s isEqualToString:@"(null)"] || [s isEqualToString:@"null"];
    BOOL isNull2 = [s isEqualToString:@"<NULL>"] || [s isEqualToString:@"(NULL)"] || [s isEqualToString:@"NULL"];
    if (isNull1 || isNull2 || !object) {
        return @"";
    }else{
        return s;
    }
}

//添加用户ID
- (id)addUserID:(id)parameters
{
    if(parameters == nil)
    {
        parameters = [NSDictionary dictionary];
    }
//    //已经有用户id
//    if([NSString stringWithFormat:@"%@",parameters[@"user_id"]] != nil)
//    {
//        return parameters;
//    }

    NSString * userID = [NSString stringWithFormat:@"%@",[NJLoginTool getUserID]];
    NSMutableDictionary * parametersDicM = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if(userID != nil && userID.length > 0)
    {
        
        parametersDicM[@"user_id"] = userID;
    }
    return [NSDictionary dictionaryWithDictionary:parametersDicM];
}

- (void)postWithPath:(NSString *_Nullable)path parameters:(NSDictionary *_Nullable)p finished:(void (^_Nullable)(HDError * _Nullable error, id object, BOOL isLast, id result))block{
    HDError *e = [HDError new];
    if(!path || path.length == 0){
        HDLog(@"请求路径为空");
        e.desc = @"请求路径为空";
        block(e, nil, NO, nil);
        return;
    }

    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:URLSTRING]];
    //    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer = [self netResponseSerializerWithSerializerType:NetResponseSerializerTypeDefault];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",  nil];
    NSString * token = [NJLoginTool getUserToken];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Token"];
    HDLog(@"【%@】token = %@ \n Parameters = %@", path, token, p);
    [manager POST:path parameters:p progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HDLog(@"【%@】 http = %@", path, task.response.URL);
        HDLog(@"【%@】 json = %@", path, responseObject);
        NSDictionary *response = responseObject;
        NSString *code = JSON(response[@"code"]);
        if (code.intValue != 200) {
            e.desc = HDVALUE(response[@"msg"], @"请求失败");
            e.code = code.intValue;
            block(e, nil, NO, nil);
            return ;
        }
        block(nil, nil, NO, response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HDLog(@"【%@】 task = %@", path, task);
        HDLog(@"【%@】 http = %@", path, task.response.URL);
        HDLog(@"【%@】 error = %@", path, error);
        HDLog(@"【%@】 error.description = %@", path, error.description);
        e.desc = @"网络请求失败，请稍后再试";
        e.code = e.code;
        block(e, nil, NO, nil);
        return ;
    }];
}

- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    [self requestWithPath:URLString parameters:parameters methodType:NetRequestMethodTypeGet serializerType:NetResponseSerializerTypeDefault successBlock:successBlock failureBlock:failureBlock];
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock{
    //添加用户id和session
    parameters = [self addUserID:parameters];
    
    [self requestWithPath:URLString parameters:parameters methodType:NetRequestMethodTypePost serializerType:NetResponseSerializerTypeDefault successBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [responseObject[DictionaryKeyCode] integerValue];
        if(code == 200){
            successBlock(task, responseObject);
        }else{
            NSString * errorMsg = responseObject[DictionaryKeyMsg];
            [NJProgressHUD showError:errorMsg];
            [NJProgressHUD dismissWithDelay:1.2 completion:^{
                NSDictionary * userInfo = @{NSLocalizedDescriptionKey: errorMsg
                                            };
                NSError * error = [NSError errorWithDomain:NSPOSIXErrorDomain code:code userInfo:userInfo];
                failureBlock(task, error);
            }];
            return ;
            
        }
    } failureBlock:failureBlock];
}

- (void)requestWithPath:(NSString *)URLString parameters:(NSDictionary *)parameters methodType:(NetRequestMethodType)methodType serializerType:(NetResponseSerializerType)serializerType successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    if(!URLString || URLString.length == 0){
        HDLog(@"请求地址为空");
        failureBlock(nil, [NSError errorWithDomain:NSCocoaErrorDomain code:505 userInfo:@{NSLocalizedDescriptionKey: @"请求地址为空"}]);
        return;
    }
    
//    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:NJUrlPrefix]];
////    [manager setSecurityPolicy:[self customSecurityPolicy]];
//    manager.requestSerializer.timeoutInterval = 60;
//    manager.responseSerializer = [self netResponseSerializerWithSerializerType:serializerType];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",  nil];
//
//    NSString * fullUrlString = [NJUrlPrefix stringByAppendingPathComponent:URLString];
//    HDLog(@"%@",fullUrlString);
//
    
//    //打印地址和参数
//    [self logUrlAndParameters:fullUrlString parameterDic:parameters];
//
//    switch (methodType) {
//        case NetRequestMethodTypeGet:
//        {
//            [manager GET:URLString parameters:parameters progress:nil success:successBlock failure:failureBlock];
//        }
//            break;
//        case NetRequestMethodTypePost:
//        {
//            [manager POST:URLString parameters:parameters progress:nil success:successBlock failure:failureBlock];
//        }
//            break;
//
//        default:
//            break;
//    }
}

//上传文件
- (void)uploadFile:(NSString *)URLString parameters:(NSDictionary *)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType  progressBlock:(RequestProgressBlock)progressBlock successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    //添加用户id和session
    parameters = [self addUserID:parameters];
    
    [self POST:URLString parameters:parameters serializerType:NetResponseSerializerTypeDefault constructingBodyWithBlock:^(id formData) {
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progressBlock:progressBlock successBlock:successBlock failureBlock:failureBlock];
}

//递归上传文件
- (void)recursiveUploadFile:(NSString *)URLString fileDataArr:(NSArray<NJRecursiveDataItem *> *)fileDataArr name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType  progressBlock:(RequestRecursiveProgressBlock)progressBlock successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    double perFileProgress = 1.0 / fileDataArr.count;
    [self uploadPerFile:URLString fileDataArr:fileDataArr name:name fileName:fileName mimeType:mimeType index:0 completedDataArrM:nil uploadedProgress:0 perFileProgress:perFileProgress progressBlock:progressBlock successBlock:successBlock failureBlock:failureBlock];
}


/**
 递归上传文件

 @param URLString 地址
 @param fileDataArr 数据数组
 @param name 服务器接口规定的key
 @param fileName 文件名
 @param mimeType 上传文件的MIMEType类型
 @param index 正在上传的文件下标
 @param completedDataArrM 服务器返回的数据
 @param uploadedProgress 上传进度
 @param perFileProgress 每个文件进度比例 1.0 / 3
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)uploadPerFile:(NSString *)URLString fileDataArr:(NSArray<NJRecursiveDataItem *> *)fileDataArr name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType index:(NSUInteger)index completedDataArrM:(NSMutableArray<NJRecursiveItem *> *)completedDataArrM uploadedProgress:(double)uploadedProgress perFileProgress:(double)perFileProgress progressBlock:(RequestRecursiveProgressBlock)progressBlock  successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    __block NSUInteger currentIndex = index;
    __block double currentUploadedProgress = uploadedProgress;
    if(completedDataArrM == nil)
    {
        completedDataArrM = [NSMutableArray array];
    }
    NJRecursiveDataItem * item = fileDataArr[index];
    [self uploadFile:URLString parameters:item.parameters fileData:item.data name:name fileName:fileName mimeType:mimeType progressBlock:^(NSProgress * _Nonnull progress) {
        double fractionCompleted = [progress fractionCompleted];
        double currentProgress = uploadedProgress + perFileProgress * fractionCompleted;
        progressBlock(currentProgress);
    } successBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [responseObject[DictionaryKeyCode] integerValue];
        if(code != ResultTypeSuccess)
        {
            NSString * errorMsg = responseObject[DictionaryKeyMsg];
            NSDictionary * userInfo = @{
                                        NSLocalizedDescriptionKey: errorMsg
                                        };
            NSError * error = [NSError errorWithDomain:NSPOSIXErrorDomain code:code userInfo:userInfo];
            failureBlock(task, error);
            return ;
        }
        
        HDLog(@"已上传第%ld张图片", index);
        currentIndex += 1;
        currentUploadedProgress += perFileProgress;
        NJRecursiveItem * recursiveItem = [[NJRecursiveItem alloc] initWithReServedInfo:item.reServedInfo data:responseObject[DictionaryKeyData]];
        [completedDataArrM addObject:recursiveItem];
        if(currentIndex < fileDataArr.count)
        {
            
            [self uploadPerFile:URLString fileDataArr:fileDataArr name:name fileName:fileName mimeType:mimeType index:currentIndex completedDataArrM:completedDataArrM uploadedProgress:currentUploadedProgress perFileProgress:perFileProgress progressBlock:progressBlock successBlock:successBlock failureBlock:failureBlock];
        }
        else
        {
            successBlock(task, [NSArray arrayWithArray:completedDataArrM]);
        }
        
    } failureBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HDLog(@"%@", error);
        failureBlock(task, error);
    }];
    
}

//多图上传 (任意数量上传)
- (void)uploadFile:(NSString *)URLString parameters:(NSDictionary *)parameters imageArr:(NSArray<UIImage *> *)imageArr ratio:(CGFloat)ratio name:(NSString *)name progressBlock:(RequestProgressBlock)progressBlock successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    NSMutableArray<NSData *> * fileDataArrM = [NSMutableArray array];
    for (UIImage * image in imageArr) {
        NSData *imageData;
        if (ratio > 0.0f && ratio < 1.0f) {
            imageData = UIImageJPEGRepresentation(image, ratio);
        }
        else
        {
            imageData = UIImageJPEGRepresentation(image, 1.0f);
        }
        
        [fileDataArrM addObject:imageData];
        
    }
    
    [self uploadFile:URLString parameters:parameters fileDataArr:[NSArray arrayWithArray:fileDataArrM] mimeType:@"image/jpg/png/jpeg" name:name progressBlock:progressBlock successBlock:successBlock failureBlock:failureBlock];
}


//多图上传 (任意数量上传)
- (void)uploadFile:(NSString *)URLString parameters:(NSDictionary *)parameters fileDataArr:(NSArray<NSData *> *)fileDataArr mimeType:(NSString *)mimeType name:(NSString *)name progressBlock:(RequestProgressBlock)progressBlock successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    //添加用户id和session
    parameters = [self addUserID:parameters];
    
    [self POST:URLString parameters:parameters serializerType:NetResponseSerializerTypeDefault constructingBodyWithBlock:^(id formData) {
        //根据当前系统时间生成图片名称
        NSDate * date = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString * dateString = [formatter stringFromDate:date];
        for (NSInteger i = 0; i < fileDataArr.count; i++) {
            NSData * fileData = fileDataArr[i];
            NSString * fileName = [NSString stringWithFormat:@"%@%@.jpg", dateString, name];
            [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        }
        
        
    } progressBlock:progressBlock successBlock:successBlock failureBlock:failureBlock];
}

- (void)uploadFile:(NSString *)URLString parameters:(NSDictionary *)parameters filePath:(NSString *)filePath name:(NSString *)name progressBlock:(RequestProgressBlock)progressBlock successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    //添加用户id和session
    parameters = [self addUserID:parameters];
    
    [self POST:URLString parameters:parameters serializerType:NetResponseSerializerTypeDefault constructingBodyWithBlock:^(id formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name error:nil];
    } progressBlock:progressBlock successBlock:successBlock
     failureBlock:failureBlock];
}
/**
 文件上传-通过NSData上传

 @param URLString 地址
 @param parameters 参数
 @param serializerType 返回的数据类型要怎么解析
 @param constructingBodyWithBlock A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `AFMultipartFormData` protocol.
 @param progressBlock 进度回调
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters serializerType:(NetResponseSerializerType)serializerType constructingBodyWithBlock:(ConstructingBodyWithBlock)constructingBodyWithBlock progressBlock:(RequestProgressBlock)progressBlock successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    if(!URLString || URLString.length == 0)
    {
        HDLog(@"请求地址为空");
        failureBlock(nil, [NSError errorWithDomain:NSCocoaErrorDomain code:505 userInfo:@{
                                                                           NSLocalizedDescriptionKey: @"请求地址为空"
                                                                           }]);
        return;
    }
//    AFHTTPSessionManager * manager;
//    if ([URLString rangeOfString:@"User/uploadImg"].location == NSNotFound) {
//
//        NSLog(@"URLString 不存在 User/uploadImg");
//        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:NJUrlPrefix]];
//    } else {
//
//        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:NJPathPrefixuplondImge]];
//        NSLog(@"URLString 包含 User/uploadImg");
//
//    }
//
////    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:NJUrlPrefix]];
//    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
//    manager.requestSerializer.timeoutInterval = 60;
//    manager.responseSerializer = [self netResponseSerializerWithSerializerType:NetResponseSerializerTypeJson];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",  nil];
//
//    NSString * fullUrlString = [NJUrlPrefix stringByAppendingPathComponent:URLString];
//    HDLog(@"%@",fullUrlString);
//
    //打印地址和参数
//    [self logUrlAndParameters:fullUrlString parameterDic:parameters];
//    
//    [manager POST:URLString parameters:parameters constructingBodyWithBlock:constructingBodyWithBlock progress:progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSInteger code = [responseObject[DictionaryKeyCode] integerValue];
//        if(code != ResultTypeSuccess)
//        {
//            NSString * errorMsg = responseObject[DictionaryKeyMsg];
//            NSDictionary * userInfo = @{
//                                        NSLocalizedDescriptionKey: errorMsg
//                                        };
//            NSError * error = [NSError errorWithDomain:NSPOSIXErrorDomain code:code userInfo:userInfo];
//            failureBlock(task, error);
//            return ;
//        }
//        
//        successBlock(task, responseObject);
//    } failure:failureBlock];
}

//下载文件
+ (void)downloadFileWithUrl:(NSURL *)url savePath:(NSString *)savePath progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    if(url == nil)
    {
        NSLog(@"下载url为空");
        return;
    }
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if(savePath != nil)
        {
            return [NSURL fileURLWithPath:savePath];
        }
        //默认存储路径
        //document目录
        NSURL * documentDirUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return  [documentDirUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(error == nil)
        {
            NSLog(@"File downloaded to: %@", filePath);
        }
        else
        {
            NSLog(@"下载出错：%@",[error localizedDescription]);
        }
        completionHandler(response, filePath, error);
    }];
    [downloadTask resume];
}

//发布账号在其他地方登录通知
- (void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NJTokenChangeNotification object:nil];
}

//发布网络错误通知
- (void)postNetworkErrorNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNetworkError object:nil];
}

//打印url和参数
- (void)logUrlAndParameters:(NSString *)urlStr parameterDic:(NSDictionary *)parameterDic
{
    urlStr = [urlStr stringByAppendingString:@"?"];
    for (NSString * dicKey in parameterDic.allKeys) {
        NSString * dicValue =  parameterDic[dicKey];
        
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", dicKey, dicValue]];
    }
    
    Dlog(@"地址和参数：%@", [urlStr substringToIndex:urlStr.length - 1]);
}


- (AFHTTPResponseSerializer *)netResponseSerializerWithSerializerType:(NetResponseSerializerType)serializerType {
    switch (serializerType) {
        case NetResponseSerializerTypeDefault: return [AFJSONResponseSerializer serializer]; break;
        case NetResponseSerializerTypeJson: return [AFJSONResponseSerializer serializer]; break;
        case NetResponseSerializerTypeXml: return [AFXMLParserResponseSerializer serializer]; break;
        case NetResponseSerializerTypePlist: return [AFPropertyListResponseSerializer serializer]; break;
        case NetResponseSerializerTypeCompound: return [AFCompoundResponseSerializer serializer]; break;
        case NetResponseSerializerTypeImage: return [AFImageResponseSerializer serializer]; break;
        case NetResponseSerializerTypeData: return [AFHTTPResponseSerializer serializer]; break;
        default: return [AFJSONResponseSerializer serializer]; break;
    }
}

#pragma mark - 证书
- (AFSecurityPolicy *)customSecurityPolicy
{
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"mdd.yqxsy.cn" ofType:@".cer"];
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    if(cerData == nil)
    {
        return nil;
    }
    NSSet * cerSet = [NSSet setWithObject:cerData];
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
    // allowInvalidCertificates 是否允许无效证书(也就是自建的证书)，默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    // validatesDomainName 是否需要验证域名，默认为YES;
    // 假如证书的域名与你请求的域名不一致，需要把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    // 设置为NO，主要用于这种情况：客户端请求的事子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com,那么mail.google.com是无法验证通过的；当然有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    // 如设置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    return securityPolicy;
}



//旅游接口
- (void)POSTTour:(NSString *)URLString parameters:(NSDictionary *)parameters successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    //添加用户id和session
//    parameters = [self addUserID:parameters];
    
    [self requestWithPathTour:URLString parameters:parameters methodType:NetRequestMethodTypePost serializerType:NetResponseSerializerTypeDefault successBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [responseObject[DictionaryKeyCode] integerValue];
        if(code == ResultTypeSuccess)
        {
            successBlock(task, responseObject);
        }
        else
        {
            NSString * errorMsg = responseObject[DictionaryKeyMsg];
            [NJProgressHUD showError:errorMsg];
            [NJProgressHUD dismissWithDelay:1.2 completion:^{
                NSDictionary * userInfo = @{
                                            NSLocalizedDescriptionKey: errorMsg
                                            };
                NSError * error = [NSError errorWithDomain:NSPOSIXErrorDomain code:code userInfo:userInfo];
                failureBlock(task, error);
            }];
            return ;
            
        }
    } failureBlock:failureBlock];
}

- (void)requestWithPathTour:(NSString *)URLString parameters:(NSDictionary *)parameters methodType:(NetRequestMethodType)methodType serializerType:(NetResponseSerializerType)serializerType successBlock:(RequestManagerSuccessBlock)successBlock failureBlock:(RequestManagerFailureBlock)failureBlock
{
    if(!URLString || URLString.length == 0)
    {
        HDLog(@"请求地址为空");
        failureBlock(nil, [NSError errorWithDomain:NSCocoaErrorDomain code:505 userInfo:@{
                                                                                          NSLocalizedDescriptionKey: @"请求地址为空"
                                                                                          }]);
        return;
    }
    
//    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://app.test.yqxsy.cn/tour/Index/index"]];
    
    AFJSONRequestSerializer *rqSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    rqSerializer.stringEncoding = NSUTF8StringEncoding;
    AFJSONResponseSerializer *rsSerializer = [AFJSONResponseSerializer serializer];
//    rsSerializer.stringEncoding = NSUTF8StringEncoding;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:60];
    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
  
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/xml",@"text/xml",@"text/json",@"text/plain",@"text/javascript",@"text/html",  nil];
   
    
   
   
    manager.responseSerializer = rsSerializer;
    manager.requestSerializer = rqSerializer;
    
   
    
//    NSString * fullUrlString = [NJUrlPrefix stringByAppendingPathComponent:URLString];
//    HDLog(@"%@",fullUrlString);
//
//
//    //打印地址和参数
//    [self logUrlAndParameters:fullUrlString parameterDic:parameters];
//
    switch (methodType) {
        case NetRequestMethodTypeGet:
        {
            [manager GET:URLString parameters:parameters progress:nil success:successBlock failure:failureBlock];
        }
            break;
        case NetRequestMethodTypePost:
        {
            [manager POST:URLString parameters:parameters progress:nil success:successBlock failure:failureBlock];
        }
            break;
            
        default:
            break;
    }
}

@end



@implementation HDError


@end
