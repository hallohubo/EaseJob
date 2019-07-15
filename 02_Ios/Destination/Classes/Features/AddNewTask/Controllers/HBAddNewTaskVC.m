//
//  HBAddNewTaskVC.m
//  Destination
//
//  Created by 胡勃 on 7/8/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBAddNewTaskVC.h"
#import "HBAllTaskTypeModle.h"
#import "NJPhotoPickerManager.h"
#import "NJImageTool.h"

typedef void(^imageBlock)(UIImage *image);

@interface HBAddNewTaskVC ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet NSLayoutConstraint     *lcContentHeight;//scrollview的contentview 总高度
    
    IBOutlet NSLayoutConstraint     *lcTaskTypeContainHeight;
    IBOutlet NSLayoutConstraint     *lcTaskTypeHeight0;//任务类型数量变化时，需要改变
    IBOutlet NSLayoutConstraint     *lcTaskTypeHeight1;
    IBOutlet NSLayoutConstraint     *lcTaskTypeHeight2;
    IBOutlet NSLayoutConstraint     *lcTaskTypeHeight3;
    
    IBOutlet NSLayoutConstraint     *lcTaskPictureContainHeight;
    IBOutlet NSLayoutConstraint     *lcTaskPictureContain0;//添加步骤的外框高度值
    IBOutlet NSLayoutConstraint     *lcTaskPictureContain1;
    IBOutlet NSLayoutConstraint     *lcTaskPictureContain2;
    IBOutlet NSLayoutConstraint     *lcTaskPictureContain3;
    IBOutlet NSLayoutConstraint     *lcTaskPictureContain4;
    
    
    IBOutlet UIView         *vPhotoContain0, *vPhotoContain1, *vPhotoContain2, *vPhotoContain3, *vPhotoContain4;
    IBOutlet UIImageView    *imvPhoto0, *imvPhoto1, *imvPhoto2, *imvPhoto3, *imvPhoto4;
    IBOutlet UIImageView    *imvBack0, *imvBack1, *imvBack2, *imvBack3, *imvBack4;
    
    IBOutlet UIImageView    *imvValidateBack0, *imvValidateBack1, *imvValidateBack2;
    IBOutlet UIImageView    *imvValidateClose0, *imvValidateClose1, *imvValidateClose2;
    IBOutlet UIButton       *btnValidate0, *btnValidate1, *btnValidate2;
    IBOutlet UIButton       *btnValidatePhote0, *btnValidatePhote1, *btnValidatePhote3;

    IBOutlet UILabel        *lbAddStep0, *lbAddStep1, *lbAddStep2, *lbAddStep3, *lbAddStep4;
    IBOutlet UITextView     *tvphotoDes0, *tvphotoDes1, *tvphotoDes2, *tvphotoDes3, *tvphotoDes4;
    IBOutlet UIButton       *btnAddStepPhote0, *btnAddStepPhote1, *btnAddStepPhote2, *btnAddStepPhote3, *btnAddStepPhote4;
    
    IBOutlet UIButton       *btn0, *btn1, *btn2, *btn3, *btn4, *btn5, *btn6, *btn7, *btn8, *btn9, *btn10, *btn11, *btn12, *btn13, *btn14, *btn15, *btn16, *btn17, *btn18, *btn19;
    
    IBOutlet UILabel        *lbShopName;
    IBOutlet UITextField    *tfShopName;
    IBOutlet NSLayoutConstraint *lcValidateViewHeight, *lcValidateSubviewsHeight;
    IBOutlet UILabel        *lbDealAmount, *lbTransportationFee, *lbTotalFee;
    IBOutlet UIView         *vValidateSubview;
    
    IBOutlet UIView         *v0, *v1, *v2, *v3;
    
    IBOutlet UIButton       *btnPaidTask, *btnNotPaidTask;
    IBOutlet UIButton       *btnAll, *btnAndroid, *btnIOS;
    IBOutlet UITextField    *tfTastTitle;
    IBOutlet UIImageView    *imvValidate0, *imvValidate1, *imvValidate2;
    IBOutlet UITextField    *tfValidateDes, *tfValidateDes1, *tfValidateDes2;
    IBOutlet UITextField    *tfCommissionDes, *tfTaskNumbers, *tfExpect;
    IBOutlet UILabel        *lbCommissionDes, *lbTaskNumbers, *lbExpect;
    IBOutlet UITextField    *tfLinkAddress;
    IBOutlet UIButton       *btnShow, *btnHide;
    IBOutlet UITextView     *tvTaskAdditionDescription;
    IBOutlet UILabel        *lbTaskLimit, *lbAuditTime;
    IBOutlet UIButton       *BtnRedoYes, *btnRedoNo;
    IBOutlet UIButton       *btnAgreement;
    IBOutlet UILabel        *lbShowAgreement;
    IBOutlet UIButton       *btnRelease, *btnPreview;
    IBOutlet UIScrollView   *scv;

    NSArray             *arButtons;
    NSArray             *arViews;
    NSArray             *arButtonsLayoutConstraints;
    
    NSMutableArray      *marAllTaskList;
    NSMutableArray      *marOrderList;
    
    
    NSMutableArray      *arTextviewDescription;
    NSArray             *arTextviews;
    NSArray             *arImageviewsClose;
    NSArray             *arViewsForStep;
    NSMutableArray      *arImageLinks;
    
    NSArray             *arIsAdvancesButtons;
    NSArray             *arPhoneTypeButtons;
    NSArray             *arIsShowForLinkButtons;
    NSArray             *arIsRepeatOrderButtons;
   
    NSArray             *arViewLayouConstainss;
    NSArray             *arLableAddSteps;
    

    NSURLSessionTask    *task;
    

}
@property (nonatomic, copy) imageBlock imaBlock;
@end

@implementation HBAddNewTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
    [self httpGetAllTask];
    
    [self stepPhotosInit];
    // Do any additional setup after loading the view from its nib.
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
        if (self.imaBlock) {
            imageBlock(image);//回调
            
        }
        //[imvHead setImage:image];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            image = [self makeThumbnailFromImage:image scale:1.0];  // 固定方向
            image = [self reduceImage:image percent:0.1];           //压缩图片质量
            CGSize imageSize = image.size;
            Dlog(@"image:%@", image);
            imageSize.height = kSCREEN_WIDTH/4*3;
            imageSize.width = kSCREEN_WIDTH;
            image = [self imageWithImageSimple:image scaledToSize:imageSize];
        }
        
//        [self httpPostImages:image getHeadPortrail:^(NSString *portrail) {
//            NSDictionary *dic = @{@"headImg": portrail};
////            [self httpCommitMyProfile:dic successful:^(bool isSuccessful) {
////                Dlog(@"picture loadup %@", isSuccessful? @"YES" : @"NO");
////            }];
//        }];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

#pragma mark - UI touch event

- (IBAction)getValidatePhote:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:{
            __block HBAddNewTaskVC *blockSelf = self;
            self.imaBlock = ^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [blockSelf -> imvValidateClose0 setImage:image];
                    
                });

            };
            [self startGetPhoto];

            break;
        }
        case 1:{
            break;
        }
        case 2:{
            break;
        }

        default:
            break;
    }

}

- (IBAction)checkButtonState:(UIButton *)sender
{
    if (sender.tag == 0 || sender.tag == 1) {
        [self changeButtonState:arIsAdvancesButtons touchButton:sender];
    }else if (sender.tag > 1 && sender.tag < 22) {
//        sender.selected = !sender.selected;
        [self changeButtonState:arButtons touchButton:sender];
    }else if (sender.tag > 21 && sender.tag < 25) {
        [self changeButtonState:arPhoneTypeButtons touchButton:sender];
    }else if (sender.tag > 24 && sender.tag < 27) {
        [self changeButtonState:arIsShowForLinkButtons touchButton:sender];
    }else if(sender.tag > 26 && sender.tag < 29) {
        [self changeButtonState:arIsRepeatOrderButtons touchButton:sender];
    }else if (sender.tag == 29) {
        sender.selected = !sender.selected;
    }else if (sender.tag == 30) {
        NSLog(@"预览");
    }else {
        NSLog(@"预览");
    }
}

#pragma mark - http event

- (void)httpGetAllTask  //获取平台支持的任务类型
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    [NJProgressHUD show];
    
    task = [helper postPath:@"Act201" object:[HBAllTaskTypeModle class] finished:^(HDError *error, id object, BOOL isLast, id json)
    {
        [NJProgressHUD dismiss];
        if (error) {
            if (error.code != 0) {
                [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            }
            return ;
        }
        if (![object isKindOfClass:[NSArray class]]) {
            return;
        }
        
        marAllTaskList = object;
        Dlog(@"maralltask:%@", marAllTaskList);
        [self setUIObjectText:arButtons];
        for (int i = 0; i < marAllTaskList.count; i++) {
            HBAllTaskTypeModle *dic = marAllTaskList[i];
            
            UIButton *btn = arButtons[i];
            NSString *str = dic.TaskType;
            [btn setTitle:str forState:UIControlStateNormal];        }
            [self RefreshUIButtonObjectsHiden:arButtons];
    }];
}

- (void)httpPostImages:(UIImage *)image getHeadPortrail:(void(^)(NSString *portrail))block
{
    if (!image) {
        Dlog(@"Error:图片为空！");
        return ;
    }
    
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:@{@"uploadCode": @(3)}];
    
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

//- (void)httpCommitMyProfile:(NSDictionary *)personalData successful:(void(^)(bool isSuccessful))blocl{
//    HDHttpHelper *helper = [HDHttpHelper instance];
//    [helper.parameters addEntriesFromDictionary:personalData];
//    [NJProgressHUD show];
//
//    task = [helper postPath:@"Act118" object:nil finished:^(HDError *error, id object, BOOL isLast, id json) {
//        [NJProgressHUD dismiss];
//        if (error) {
//            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
//            return ;
//        }
//        [NJProgressHUD showSuccess:@"保存成功"];
//        [NJProgressHUD dismissWithDelay:1.2];
//        blocl(1);
//
//    }];
//}

#pragma mark - setter and getter

- (void)setupInit
{
    self.title = @"新任务";
    
    arButtons   = @[btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, btn10, btn11, btn12, btn13, btn14, btn15, btn16, btn17, btn18, btn19];
    arButtonsLayoutConstraints = @[lcTaskTypeHeight0, lcTaskTypeHeight1, lcTaskTypeHeight2, lcTaskTypeHeight3];
    arViews = @[v0, v1, v2, v3];
    
    arTextviewDescription   = [self productStringObject:5 container:arTextviewDescription];

    arViewLayouConstainss   = @[lcTaskPictureContain0, lcTaskPictureContain1, lcTaskPictureContain2, lcTaskPictureContain3, lcTaskPictureContain4];
    arViewsForStep  = @[vPhotoContain0, vPhotoContain1, vPhotoContain2, vPhotoContain3, vPhotoContain4];
    arImageLinks    = [self productStringObject:5 container:arImageLinks];
    arLableAddSteps = @[lbAddStep0, lbAddStep1, lbAddStep2, lbAddStep3, lbAddStep4];
    arTextviews = @[tvphotoDes0, tvphotoDes1, tvphotoDes2, tvphotoDes3, tvphotoDes4];

    arIsAdvancesButtons = @[btnPaidTask, btnNotPaidTask];//是否垫付
    arPhoneTypeButtons  = @[btnAll, btnAndroid, btnIOS];
    arImageviewsClose   = @[imvValidateClose0, imvValidateClose1, imvValidateClose2];
    arIsShowForLinkButtons  = @[btnShow, btnHide];
    arIsRepeatOrderButtons  = @[btnRedoNo, BtnRedoYes];
    
    
    lcValidateSubviewsHeight.constant = 0.f;
    vValidateSubview.hidden = YES;
    tfShopName.hidden = YES;
    
    [self setUIObjectHidden:arButtons];
    [self setUIObjectHidden:arViews];
    [self setUIObjectHidden:arImageviewsClose];
    [self setUIObjectText:arButtons];
    [self setLayoutConstant:arButtonsLayoutConstraints];
    [self setScrollviewContainHeight];
}


- (void)stepPhotosInit//步骤图初始化UI
{
    [self setupStepPhotoprimaryState];
    for (NSString *str in arImageLinks) {
        if (str.length < 1 && arImageLinks.count > 0) {
            NSInteger iPosition=[arImageLinks indexOfObject:str];
            if (iPosition < 0) {
                return;
            }
            NSLayoutConstraint *lc =  arViewLayouConstainss[iPosition];
            NSLog(@"lc:%f index:%ld", lc.constant,(long)iPosition);
            UIView *v = arViewsForStep[iPosition];
            v.hidden    = NO;
            lc.constant = 130.f;
            NSLog(@"lc:%f", lc.constant);
            [self setScrollviewContainHeight];
            return;
        }else {
            NSInteger iPosition=[arImageLinks indexOfObject:str];
            if (iPosition < 0) {
                return;
            }
            NSLayoutConstraint *lc =  arViewLayouConstainss[iPosition];
            NSLog(@"lc:%f index:%ld", lc.constant,(long)iPosition);
            UIView *v = arViewsForStep[iPosition];
            UILabel *lb = arLableAddSteps[iPosition];
            v.hidden    = NO;
            lb.hidden   = YES;
            lc.constant = 110.f;
            NSLog(@"lc:%f", lc.constant);
            [self setScrollviewContainHeight];
        }
    }
    
}

- (void)setupStepPhotoprimaryState//步骤图初始化
{
    [self setUIObjectHidden:arViewsForStep];
    [self setLayoutConstant:arViewLayouConstainss];
    [self setScrollviewContainHeight];
}

- (void)setUIObjectText:(NSArray *)arObject
{
    for (UIButton *btn in arObject) {
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.selected = NO;
        }
}

- (void)setUIObjectHidden:(NSArray *)arObject//btn容器
{
    for (id object in arObject) {
        [object setHidden:YES];
    }
}

- (void)setLayoutConstant:(NSArray *)arLayOut
{
    for (NSLayoutConstraint *lc in arLayOut) {
        lc.constant = 0.f;
    }
}

- (void)RefreshUIButtonObjectsHiden:(NSArray *)UIObjects
{
    [self setUIObjectHidden:arViews];
    [self setLayoutConstant:arButtonsLayoutConstraints];

    int i=0;
    for (id object in UIObjects) {
        if ([object isKindOfClass:[UIButton class]]) {
            UIButton *btn = object;
            NSString *str = btn.titleLabel.text;
            Dlog(@"strstr:%@", str);
            [object setHidden:(btn.titleLabel.text.length > 1)? NO : YES];
            i = btn.titleLabel.text.length > 0? i+1 : i;
        }
    }
    
    if (i/5 > 0) {
        int j = i/5;
        Dlog(@"j:%d", j);
        j = i%5 > 0? j++ : j;
        Dlog(@"j:%d", j);
        for (int k = 0; k < j; k++) {
            UIView *v = arViews[k];
            v.hidden = NO;
            NSLayoutConstraint *lc = arButtonsLayoutConstraints[k];
            lc.constant = 50.f;
        }
        
        
    }else if (i%5 > 0) {
        UIView *v = arViews[0];
        NSLayoutConstraint *lc = arButtonsLayoutConstraints[0];
        v.hidden = NO;
        lc.constant = 50.f;
    }else {
        [self setUIObjectHidden:arButtons];
        [self setUIObjectHidden:arViews];
        [self setLayoutConstant:arButtonsLayoutConstraints];
    }
    [self setScrollviewContainHeight];
}

- (void)setScrollviewContainHeight
{
    lcTaskTypeContainHeight.constant = lcTaskTypeHeight0.constant+lcTaskTypeHeight1.constant+lcTaskTypeHeight2.constant+lcTaskTypeHeight3.constant+60;
    
    lcTaskPictureContainHeight.constant = lcTaskPictureContain0.constant*(120/110) + lcTaskPictureContain1.constant*(120/110) + lcTaskPictureContain2.constant*(120/110) + lcTaskPictureContain3.constant*(120/110) + lcTaskPictureContain4.constant*(120/110)+60;
    lcValidateViewHeight.constant = lcValidateSubviewsHeight.constant + 325;
    
   lcContentHeight.constant = lcTaskTypeContainHeight.constant + lcTaskPictureContainHeight.constant + lcValidateViewHeight.constant +2370-50*4-110*5*(120/110)-150-70-325;
    Dlog(@"llll:%f", lcContentHeight.constant);
    [self.view updateConstraints];
    [scv setContentSize:CGSizeMake(kSCREEN_WIDTH, lcContentHeight.constant)];
}

#pragma mark - other

- (NSMutableArray *)productStringObject:(int)number container:(NSMutableArray *)arrayObjects
{
    arrayObjects = [NSMutableArray array];
    for (int i ; i < number; i++) {
        NSString *str = @"";
        [arrayObjects addObject:str];
    }
    return arrayObjects;
}

- (void)changeButtonState:(NSArray *)arButtons touchButton:(UIButton *)Touchbutton
{
    for (UIButton  *btn in arButtons) {
        if ([btn isEqual:Touchbutton]) {
            btn.selected = !btn.selected;
            for (UIButton *btn in arButtons) {
                btn.selected = [btn isEqual:Touchbutton]? Touchbutton.selected : !Touchbutton.selected;
            }
        }
    }
}

#pragma mark - 获取图片

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


#pragma mark -字典转换成json串
- (NSString *)dictionaryToJsonString:(NSDictionary *)dict{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
#pragma mark -数组转换成json串
- (NSString *)arrayToJsonString:(NSArray *)array{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
}


@end
