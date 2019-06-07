//
//  HDQRCodeHelper.m
//  Demo
//
//  Created by hufan on 2018/3/1.
//  Copyright © 2018年 hufan. All rights reserved.
//

#import "HDQRCodeCtr.h"
#import <AVFoundation/AVFoundation.h>

@interface ShadowView : UIView

@property (nonatomic, assign) CGSize showSize;
- (void)stopTimer;

@end

@interface HDQRCodeCtr ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    ShadowView *shadowView;
}
/** 输入数据源 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/** 输出数据源 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
/** 输入输出的中间桥梁 负责把捕获的音视频数据输出到输出设备中 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 相机拍摄预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layerView;
/** 预览图层尺寸 */
@property (nonatomic, assign) CGSize layerViewSize;
/** 有效扫码范围 */
@property (nonatomic, assign) CGSize showSize;

@end


@implementation HDQRCodeCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //调用
    [self creatScanQR];
    //添加拍摄图层
    [self.view.layer addSublayer:self.layerView];
    //开始二维码
    [self.session startRunning];

    shadowView = [[ShadowView alloc] initWithFrame:CGRectMake(0, 64, HDDeviceSize.width, HDDeviceSize.height - 64)];
    [self.view addSubview:shadowView];
    shadowView.showSize = CGSizeMake(HDDeviceSize.width / 2, HDDeviceSize.width / 2);
}


-(void)creatScanQR{
    /** 创建输入数据源 */
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];  //获取摄像设备
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];  //创建输出流
    
    /** 创建输出数据源 */
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];  //设置代理 在主线程里刷新
    
    /** Session设置 */
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];   //高质量采集
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //设置扫码支持的编码格式
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                        AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode128Code];
    /** 扫码视图 */
    //扫描框的位置和大小
    self.layerView = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.layerView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.layerView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    // 将扫描框大小定义为属行, 下面会有调用
    self.layerViewSize = CGSizeMake(_layerView.frame.size.width, _layerView.frame.size.height);
}

#pragma mark - 实现代理方法, 完成二维码扫描
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count == 0) {
        return;
    }
    // 停止动画, 看完全篇记得打开注释, 不然扫描条会一直有动画效果
    //[self.shadowView stopTimer];
    
    //停止扫描
    [self.session stopRunning];
    AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
    //输出扫描字符串
    NSLog(@"%@", metadataObject.stringValue);
    if (self.scanFinishedBlock) {
        self.scanFinishedBlock(metadataObject.stringValue);
    }

}

@end

@interface ShadowView ()

@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        // 图片下方附上
        self.lineView  = [[UIImageView alloc] init];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self addSubview:self.lineView];
        
    }
    return self;
}

-(void)playAnimation{
    
    [UIView animateWithDuration:2.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.lineView .frame = CGRectMake((self.frame.size.width - self.showSize.width) / 2, (self.frame.size.height + self.showSize.height) / 2, self.showSize.width, 2);
        
    } completion:^(BOOL finished) {
        self.lineView .frame = CGRectMake((self.frame.size.width - self.showSize.width) / 2, (self.frame.size.height - self.showSize.height) / 2, self.showSize.width, 2);
    }];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.lineView .frame = CGRectMake((self.frame.size.width - self.showSize.width) / 2, (self.frame.size.height - self.showSize.height) / 2, self.showSize.width, 2);
    if (!_timer) {
        [self playAnimation];
        /* 自动播放 */
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(playAnimation) userInfo:nil repeats:YES];
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 整体颜色
    CGContextSetRGBFillColor(ctx, 0.15, 0.15, 0.15, 0.6);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
    
    //中间清空矩形框
    CGRect clearDrawRect = CGRectMake((rect.size.width - self.showSize.width) / 2, (rect.size.height - self.showSize.height) / 2, self.showSize.width, self.showSize.height);
    CGContextClearRect(ctx, clearDrawRect);
    
    //边框
    CGContextStrokeRect(ctx, clearDrawRect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);  //颜色
    CGContextSetLineWidth(ctx, 0.5);             //线宽
    CGContextAddRect(ctx, clearDrawRect);       //矩形
    CGContextStrokePath(ctx);
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
    
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    float cornerWidth = 4.0;
    float cornerLong = 16.0;
    //画四个边角 线宽
    CGContextSetLineWidth(ctx, cornerWidth);
    //颜色
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    //左上角
    CGPoint poinsTopLeftA[] = {CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y),
        CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y + cornerLong)};
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y + cornerWidth/2),
        CGPointMake(rect.origin.x + cornerLong, rect.origin.y + cornerWidth/2)};
    
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];

    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y + rect.size.height - cornerLong),
        CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y + rect.size.height)};
    
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - cornerWidth/2),
        CGPointMake(rect.origin.x + cornerLong, rect.origin.y + rect.size.height - cornerWidth/2)};
    
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerLong, rect.origin.y + cornerWidth/2),
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + cornerWidth/2 )};
    
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerWidth/2, rect.origin.y),
        CGPointMake(rect.origin.x + rect.size.width- cornerWidth/2, rect.origin.y + cornerLong)};
    
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    //右下角
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerWidth/2, rect.origin.y+rect.size.height - cornerLong),
        CGPointMake(rect.origin.x- cornerWidth/2 + rect.size.width, rect.origin.y +rect.size.height )};
    
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerLong, rect.origin.y + rect.size.height - cornerWidth/2),
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - cornerWidth/2 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}


@end


