//
//  NJCIQRCodeTool.m
//  Sepetember_fifteen_二维码的综合使用
//
//  Created by TouchWorld on 2017/9/23.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import "NJCIQRCodeTool.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^ResultBlock)(NSArray<NSString *> *resultStrs);
@interface NJCIQRCodeTool () <AVCaptureMetadataOutputObjectsDelegate>
/********* 输入 *********/
@property (nonatomic, strong) AVCaptureDeviceInput * input;
/********* 输出 *********/
@property (nonatomic, strong) AVCaptureMetadataOutput * output;
/********* 会话 *********/
@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * prelayer;
@property (nonatomic, copy) ResultBlock resultBlock;
/********* 要删除的layer *********/
@property (nonatomic, strong) NSMutableArray * deleteTempLayers;
@end

@implementation NJCIQRCodeTool
single_implementation(NJCIQRCodeTool)
/// 开始扫描, 并添加预览层到指定视图, 扫描结果通过block返回
- (void)beginScanInView:(UIView *)view result:(void(^)(NSArray<NSString *> *resultStrs))resultBlock
{
    //移除图层
    [self removeShapLayers];
    
    self.resultBlock = resultBlock;
    
    // 4. 创建并设置会话
    if ([self.session canAddInput:self.input] && [self.session canAddOutput:self.output]) {
        [self.session addInput:self.input];
        [self.session addOutput:self.output];
        NSLog(@"test");
        // 设置元数据处理类型(注意, 一定要将设置元数据处理类型的代码添加到  会话添加输出之后)
        [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    }
    if([self.session.inputs containsObject:self.input] && [self.session.outputs containsObject:self.output])
    {
        
    }
    else
    {
        resultBlock(nil);
        return;
    }
    
    
    // 添加预览图层
    if (![view.layer.sublayers containsObject:self.prelayer])
    {
        self.prelayer.frame = view.layer.bounds;
        [view.layer insertSublayer:self.prelayer atIndex:0];
    }
    
    // 5. 启动会话
    [self.session startRunning];
    
}

- (void)stopScan
{
    [self.session stopRunning];
}

-(void)setInsteretRect:(CGRect)originRect
{
    // 设置兴趣点
    // 注意: 兴趣点的坐标是横屏状态(0, 0 代表竖屏右上角, 1,1 代表竖屏左下角)
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    CGFloat x = originRect.origin.x / screenBounds.size.width;
    CGFloat y = originRect.origin.y / screenBounds.size.height;
    CGFloat width = originRect.size.width / screenBounds.size.width;
    CGFloat height = originRect.size.height / screenBounds.size.height;
    
    self.output.rectOfInterest = CGRectMake(y, x, height, width);
}



#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (self.isDrawQRCodeRect) {
        [self removeShapLayers];
    }
    NSMutableArray *resultStrs = [NSMutableArray array];
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects)
    {
        [resultStrs addObject:obj.stringValue];
        
        if (self.isDrawQRCodeRect) {
            // obj 中的四个角, 是没有转换后的角, 需要我们使用预览图层转换
            AVMetadataMachineReadableCodeObject *tempObj = (AVMetadataMachineReadableCodeObject *)[self.prelayer transformedMetadataObjectForMetadataObject:obj];
            [self addShapLayers:tempObj];
            
        }
        
    }
    
    self.resultBlock(resultStrs);
    
}

// 添加二维码边框图层
- (void)addShapLayers:(AVMetadataMachineReadableCodeObject *)transformObj
{
    // 绘制边框
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.lineWidth = 6;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 创建一个贝塞尔曲线
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    
    int index = 0;
    for (NSDictionary *pointDic in transformObj.corners)
    {
        CFDictionaryRef dic = (__bridge CFDictionaryRef)(pointDic);
        CGPoint point = CGPointZero;
        CGPointMakeWithDictionaryRepresentation(dic, &point);
        if (index == 0) {
            [path moveToPoint:point];
        }else
        {
            [path addLineToPoint:point];
        }
        index ++;
        
    }
    [path closePath];
    layer.path = path.CGPath;
    [self.prelayer addSublayer:layer];
    [self.deleteTempLayers addObject:layer];
}

// 移除二维码边框图层
- (void)removeShapLayers
{
    // 移除图层
    for (CALayer *layer in self.deleteTempLayers) {
        [layer removeFromSuperlayer];
    }
    
    [self.deleteTempLayers removeAllObjects];
    
}





/**

 根据文字，生成对应的二维码图片
 
 @param str 内容
 @param centerImage 中间图片
 @param size 尺寸
 @return 二维码
 */
+ (UIImage *)QRCodeGenerator:(NSString *)str centerImage:(UIImage *)centerImage withSize:(CGFloat) size
{
    if(str == nil || str.length == 0)
    {
      
        return nil;
    }
    
    //1.生成滤镜
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.设置相关属性
    [filter setDefaults];
    //3.设置输入数据
    NSData * strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    //3.1KVC
    [filter setValue:strData forKey:@"inputMessage"];
    //3.2设置容错率
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    //4.获取输出结果
    CIImage * outputImage = [filter outputImage];
    //获取指定大小的图片
    UIImage * resultImage = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
    //5.设置前景图片
    if(centerImage != nil)
    {
        resultImage = [self getNewImage:resultImage centerImage:centerImage];
    }
   
    return resultImage;
}
//识别图片中的二维码
+ (void)detectorQICodeImage:(UIImage *)sourceImage isDrawFrame:(BOOL)isDrawFrame withCompleted:(void(^)(NSString * str,UIImage * resultImage)) completed
{
    if(sourceImage == nil)
    {
        completed(nil,nil);
        return;
    }
    CIImage * imageCI = [CIImage imageWithCGImage:sourceImage.CGImage];
    //2.生成一个探测器
    CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{
                                                                                                  CIDetectorAccuracy : CIDetectorAccuracyHigh,
                                                                                                  }];
    //3.探测二维码特征
    NSArray<CIFeature *> * featureArr = [detector featuresInImage:imageCI];
    UIImage * resultImage = sourceImage;
    NSMutableString * resultStrM = [NSMutableString string];
    for (CIQRCodeFeature * feature in featureArr)
    {
        //        NSLog(@"%@",[feature messageString]);
        //        NSLog(@"%@",NSStringFromCGRect(feature.bounds));
        [resultStrM appendString:feature.messageString];
        if(isDrawFrame == YES)
        {
            resultImage = [self drawFrameWithImage:resultImage feature:feature];
        }
        
    }
    
    completed(resultStrM,resultImage);
}
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
+ (UIImage *)getNewImage:(UIImage *)bgImage centerImage:(UIImage *)centerImage
{
    CGSize bgImageSize = [bgImage size];
    //1.开启图像上下文
    UIGraphicsBeginImageContext(bgImageSize);

    //2.绘画背景图片
    [bgImage drawInRect:CGRectMake(0, 0, bgImageSize.width,  bgImageSize.height)];
    
    //3.绘画前景图片
    CGFloat frontImageWidth = 25;
    CGFloat frontImageHeight = 25;
    CGFloat frontImageX= (bgImageSize.width - frontImageWidth) * 0.5;
    CGFloat frontImageY =(bgImageSize.height - frontImageHeight) * 0.5;
    [centerImage drawInRect:CGRectMake(frontImageX, frontImageY, frontImageWidth, frontImageHeight)];
    //4.取出图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图像上下文
    UIGraphicsEndImageContext();
    return newImage;
}
//绘画二维码边框
+ (UIImage *)drawFrameWithImage:(UIImage *)bgImage feature:(CIQRCodeFeature *)feature
{
    CGSize imageSize = bgImage.size;
    //1.开启图像上下文
    UIGraphicsBeginImageContext(imageSize);
    
    //2.绘制背景图片
    [bgImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    //3.转换坐标系
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(contextRef, 1, -1);
    CGContextTranslateCTM(contextRef, 0, -imageSize.height);
    //4.绘制路径
    CGRect bounds = feature.bounds;
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:bounds];
    [UIColor.redColor setStroke];
    path.lineWidth = 6;
    [path stroke];
    //5.获取图片
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    //6.关闭图像上下文
    UIGraphicsEndImageContext();
    return resultImage;
}
#pragma mark - 懒加载
// 懒加载输入
- (AVCaptureDeviceInput *)input
{
    if (!_input) {
        // 获取摄像头设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // 设置为输入设备
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    }
    return _input;
}

// 懒加载输出
- (AVCaptureMetadataOutput *)output
{
    if (!_output) {
        // 设置元数据输出
        _output = [[AVCaptureMetadataOutput alloc] init];
        // 设置输出处理者
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _output;
}

// 懒加载session
- (AVCaptureSession *)session
{
    if (!_session) {
        // 创建会话, 并设置输入输出
        _session = [[AVCaptureSession alloc] init];
        
    }
    return _session;
}

// 懒加载预览层
- (AVCaptureVideoPreviewLayer *)prelayer
{
    if (!_prelayer) {
        _prelayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    }
    return _prelayer;
}

- (NSMutableArray *)deleteTempLayers
{
    if (!_deleteTempLayers) {
        _deleteTempLayers = [NSMutableArray array];
    }
    return _deleteTempLayers;
}
@end
