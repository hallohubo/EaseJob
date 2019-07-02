//
//  HBKindsCardsAuthenticationVC.m
//  Destination
//
//  Created by 胡勃 on 7/1/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBKindsCardsAuthenticationVC.h"
#import "NJPhotoPickerManager.h"
#import "NJImageTool.h"

@interface HBKindsCardsAuthenticationVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIButton       *btnNextStep;
    IBOutlet UIImageView    *imvCard;
    IBOutlet UIImageView    *imvSmallImage;
    IBOutlet UITextField    *tfName;
    IBOutlet UITextField    *tfIdentifyCode;
    IBOutlet UITextField    *tfBank;
    IBOutlet UITextField    *tfBankCode;
    IBOutlet UIButton       *btnTouchPhoto;
    
    NSURLSessionDataTask    *task;
    NSString    *isValid;
    NSString    *strPhotoPath;
    
}

@end

@implementation HBKindsCardsAuthenticationVC

#pragma mark - life cycle

- (instancetype)initWithIsvail:(NSString *)vailString
{
    if (self = [super init]) {
        isValid = vailString;
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate Call Back Implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        NSString *key = nil;
        if (picker.allowsEditing)
        {
            key = UIImagePickerControllerEditedImage;
        }
        else
        {
            key = UIImagePickerControllerOriginalImage;
        }
        //获取图片
        UIImage *image = [info objectForKey:key];
        [imvCard setImage:image];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            image = [self makeThumbnailFromImage:image scale:1.0];  // 固定方向
            image = [self reduceImage:image percent:0.1];           //压缩图片质量
            CGSize imageSize = image.size;
            Dlog(@"image:%@", image);
            imageSize.height = kSCREEN_WIDTH/4*3;
            imageSize.width = kSCREEN_WIDTH;
            image = [self imageWithImageSimple:image scaledToSize:imageSize];
        }
        
        imvSmallImage.hidden = YES;
        [self httpPostImages:image];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

#pragma mark - UI touch event

- (IBAction)startGetPhoto:(UIButton *)send
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        [self guideUserOpenAuth];
        return;
    }
    
    __block NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    [LBXAlertAction sayWithTitle:@"温馨提示" message:@"请选择相片来源" buttons:@[@"取消", @"拍照", @"相册"] chooseBlock:^(NSInteger buttonIdx) {
        if(buttonIdx == 0)
        {
            return ;
        }
        
        sourceType = buttonIdx == 1? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self localPhot:sourceType];
    }];
}

- (IBAction)btnNextClick:(UIButton *)sender
{
    if(tfName.text.length == 0) {
        [NJProgressHUD showError:@"姓名为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(![HDHelper isValideteIdentityCard:tfIdentifyCode.text]) {
        [NJProgressHUD showError:@"身份证号码不正确"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(tfBank.text.length == 0) {
        [NJProgressHUD showError:@"开户行不能为空"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if(tfBankCode.text.length == 0) {
        [NJProgressHUD showError:@"银行卡号不正确!"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }
    
//    if(![HDHelper isValidateBandCard:tfBankCode.text]) {
//        [NJProgressHUD showError:@"银行卡号不正确!"];
//        [NJProgressHUD dismissWithDelay:1.2];
//        return;
//    }
    
    if((strPhotoPath.length < 1)) {
        [NJProgressHUD showError:@"身份证图片未上传成功，请检查!"];
        [NJProgressHUD dismissWithDelay:1.2];
        return;
    }

    
    [self.view endEditing:YES];
    
    NSDictionary *dic = @{@"name"           :HDSTR(tfName.text),
                          @"idCard"         :HDSTR(tfIdentifyCode.text),
                          @"bankAccount"    :HDSTR(tfBankCode.text),
                          @"openingBank"    :HDSTR(tfBank.text),
                          @"openingBank"    :HDSTR(tfBank.text),
                          @"isValid"        :HDSTR(isValid),    //Act113接口返回的IsValid参数值原样回传
                          @"photoPath"      :HDSTR(strPhotoPath),  //请求接口Act112上传后返回的图片地址
                          };
    Dlog(@"dic115:%@", dic);
    [self HttpPostMobileAuthentication:dic];
}

#pragma mark - http event

- (void)HttpPostMobileAuthentication:(NSDictionary *)dicParam //request authentication
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:dicParam];
    [NJProgressHUD show];
    task = [helper postPath:@"Act115" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        Dlog(@"json:%@",json);
        NSDictionary *respons = json;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)httpPostImages:(UIImage *)image
{
    if (!image) {
        Dlog(@"Error:图片为空！");
        return ;
    }
    
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:@{@"uploadCode": @(1)}];
    
    [helper httpPostPath:@"Act112" data:@[image] finished:^(HDError *error, id object) {
        NSLog(@"json112:%@", object);

        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        NSLog(@"json112:%@", object);
        strPhotoPath = JSON(JSON(object));
        Dlog(@"strPhotoPath:%@", strPhotoPath);
    }];
}

#pragma mark - setter and getter

- (void)setupInit
{
    self.title = @"实名认证";
    
    [btnNextStep addBorderWidth:.0 color:nil cornerRadius:25.];
    [HDHelper changeColor:btnNextStep];
}

#pragma mark - other method

- (void)guideUserOpenAuth
{
    [LBXAlertAction sayWithTitle:@"温馨提示" message:@"请打开相机权限" buttons:@[@"确定", @"去设置"] chooseBlock:^(NSInteger buttonIdx) {
        if(buttonIdx == 1)//去设置
        {
            [[NJCommonTool shareInstance] openAppSetting];
        }
    }];
}

-(void)localPhot:(NSUInteger *)sourceType
{
    //本地相册不需要检查，因为UIImagePickerController会自动检查并提醒
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage scale:(double)imageScale {
    UIImage *thumbnail = nil;
    CGSize imageSize = CGSizeMake(srcImage.size.width * imageScale, srcImage.size.height * imageScale);
    UIGraphicsBeginImageContext(imageSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    [srcImage drawInRect:imageRect];
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnail;
}

-(UIImage *)reduceImage:(UIImage *)image percent:(float)percent {
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

//Compressed image size
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
