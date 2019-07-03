//
//  HBGetPersonalAuthentificationVC.m
//  Destination
//
//  Created by 胡勃 on 7/2/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBGetPersonalAuthentificationVC.h"
#import "HBMobileCodeAuthenticationVC.h"
#import "HBRealNameAuthenticationModel.h"
#import "HBModyfyNicknameVC.h"
#import "NJPhotoPickerManager.h"
#import "NJImageTool.h"


@interface HBGetPersonalAuthentificationVC ()
{
    IBOutlet UIButton   *btnNickName;
    IBOutlet UIButton   *btnGender;
    IBOutlet UIButton   *btnImage;
    IBOutlet UIButton   *btnVertify;
    
    IBOutlet UILabel    *lbNickName;
    IBOutlet UILabel    *lbGender;
    IBOutlet UILabel    *lbName;
    IBOutlet UILabel    *lbIDNumber;
    IBOutlet UILabel    *lbBank;
    IBOutlet UILabel    *lbBankNumber;
    IBOutlet UILabel    *lbRemark;
    
    IBOutlet UIImageView        *imvHead;
    IBOutlet NSLayoutConstraint *lcHeight;
    HBRealNameAuthenticationModel   *model;
    NSURLSessionTask    *task;
}

@end

@implementation HBGetPersonalAuthentificationVC

#pragma mark - life cycle

- (void)viewDidAppear:(BOOL)animated
{
    [self httpGetMeData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
}

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
        [imvHead setImage:image];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            image = [self makeThumbnailFromImage:image scale:1.0];  // 固定方向
            image = [self reduceImage:image percent:0.1];           //压缩图片质量
            CGSize imageSize = image.size;
            Dlog(@"image:%@", image);
            imageSize.height = kSCREEN_WIDTH/4*3;
            imageSize.width = kSCREEN_WIDTH;
            image = [self imageWithImageSimple:image scaledToSize:imageSize];
        }
        
        [self httpPostImages:image getHeadPortrail:^(NSString *portrail) {
            NSDictionary *dic = @{@"headImg": portrail};
            [self httpCommitMyProfile:dic successful:^(bool isSuccessful) {
                Dlog(@"picture loadup %@", isSuccessful? @"YES" : @"NO");
            }];
        }];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

#pragma mark - touch event

- (void)startGetPhoto
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

- (IBAction)jumpToIdentifyAuthentifycation:(UIButton *)sender
{
    [self.navigationController pushViewController:[HBMobileCodeAuthenticationVC new] animated:YES];
}

- (IBAction)changeNicknameGenderHeadimage:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:{
            [self startGetPhoto];
            break;
        }
        case 1:{
            HBModyfyNicknameVC *_ctr =  [[HBModyfyNicknameVC alloc] initWithTitle:@"请输入姓名" defaultValue:model.RealName];
            __weak HBModyfyNicknameVC *ctr = _ctr;
            
            [self.navigationController pushViewController:ctr animated:YES];
            ctr.HBModifyMyInformationBlock = ^(NSString *name){
                lbNickName.text = name;
                [ctr.navigationController popViewControllerAnimated:YES];
            };
            break;
        }

        case 2:{
            __block NSString *strGender = [NSString string];
            [LBXAlertAction sayWithTitle:@"温馨提示" message:@"请选择相片来源" buttons:@[@"取消", @"男", @"女"] chooseBlock:^(NSInteger buttonIdx) {
                if(buttonIdx == 0) {
                    return ;
                }
                
                strGender = (buttonIdx == 1)? @"男" : @"女";
                btnGender.titleLabel.text = strGender;
//                [btnGender setTitle:strGender forState:UIControlStateNormal];
                NSDictionary *dic = @{@"sex" : @(buttonIdx)};
                [self httpCommitMyProfile:dic successful:^(bool isSuccessful) {
                    if (!isSuccessful) {
                        return ;
                    }
                    [self httpGetMeData];
                }];
            }];
            break;
        }

        default:
            break;
    }
}

#pragma mark - http event

- (void)httpPostImages:(UIImage *)image getHeadPortrail:(void(^)(NSString *portrail))block
{
    if (!image) {
        Dlog(@"Error:图片为空！");
        return ;
    }
    
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:@{@"uploadCode": @(2)}];
    
    [helper httpPostPath:@"Act112" data:@[image] finished:^(HDError *error, id object) {
        NSLog(@"json112:%@", object);
        
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        NSLog(@"json112:%@", object);
        NSString *strPhotoPath = JSON(JSON(object));
        Dlog(@"strPhotoPath:%@", strPhotoPath);
        block(strPhotoPath);
    }];
}

- (void)httpGetMeData //
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [NJProgressHUD show];
    
    task = [helper postPath:@"Act110" object:[HBRealNameAuthenticationModel new] finished:^(HDError *error, id object, BOOL isLast, id json) {
        
        [NJProgressHUD dismiss];
        
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        Dlog(@"MeMode:%@", object);
        model = object;
        [self reloadUIDate];
    }];
}

- (void)httpCommitMyProfile:(NSDictionary *)personalData successful:(void(^)(bool isSuccessful))blocl{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:personalData];
    [NJProgressHUD show];

    task = [helper postPath:@"Act118" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
        [NJProgressHUD dismiss];
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            return ;
        }
        [NJProgressHUD showSuccess:@"保存成功"];
        [NJProgressHUD dismissWithDelay:1.2];
        blocl(1);

    }];
}

#pragma mark - setter and getter

- (void)setupInit
{
    self.title = @"个人信息";
    
    imvHead.layer.cornerRadius  = 40.f;
    imvHead.layer.masksToBounds = YES;
    imvHead.layer.borderWidth   = 1.f;
    imvHead.layer.borderColor   = HDCOLOR_GRAY.CGColor;
    
    
    btnVertify.layer.cornerRadius = 25.f;
    btnVertify.layer.masksToBounds= YES;
    
    [HDHelper changeColor:btnVertify];
}

- (void)reloadUIDate
{
    lbName.text = HDSTR(model.RealName);
    lbBank.text = HDSTR(model.OpeningBank);
    lbBankNumber.text   = HDSTR(model.BankAccount);
    lbIDNumber.text     = HDSTR(model.IDCard);
    lbNickName.text     = HDSTR(model.NickName);
    lbGender.text       = HDSTR(model.Sex);
    lbRemark.text       = HDSTR(model.AuthRemark);
    
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:HDSTR(model.HeadImg)]]];
    [imvHead setImage:image];
    
    NSString *str   = HDSTR(model.AuthStatus);
    BOOL isHidden   = [str isEqualToString:@"待审核"] || [str isEqualToString:@"已认证"];
    [btnVertify setHidden:!isHidden];
    
    lcHeight.constant = lbRemark.text.length > 0? 30 : 0;
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
