//
//  HBAddNewTaskVC.m
//  Destination
//
//  Created by 胡勃 on 7/8/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBAddNewTaskVC.h"
#import "HBAllTaskTypeModle.h"

@interface HBAddNewTaskVC ()<UITextViewDelegate>
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
    
    
    IBOutlet UIView         *vPhotoContain0, *vPhotoContain1, *vPhotoContain2,
                            *vPhotoContain3, *vPhotoContain4;
    IBOutlet UIImageView    *imvPhoto0, *imvPhoto1, *imvPhoto2, *imvPhoto3,                                 *imvPhoto4;
    IBOutlet UIImageView    *imvBack0, *imvBack1, *imvBack2, *imvBack3, *imvBack4;
    
    IBOutlet UIImageView    *imvValidateBack0, *imvValidateBack1, *imvValidateBack2;
    IBOutlet UIButton       *btnValidate0, *btnValidate1, *btnValidate2;

    IBOutlet UILabel        *lbAddStep0, *lbAddStep1, *lbAddStep2, *lbAddStep3, *lbAddStep4;
    IBOutlet UITextView     *tvphotoDes0, *tvphotoDes1, *tvphotoDes2, *tvphotoDes3, *tvphotoDes4;
    IBOutlet UIButton       *btnAddStepPhote0, *btnAddStepPhote1, *btnAddStepPhote2, *btnAddStepPhote3, *btnAddStepPhote4;
    
    IBOutlet UIButton       *btn0, *btn1, *btn2, *btn3, *btn4, *btn5, *btn6,
                            *btn7, *btn8, *btn9, *btn10, *btn11, *btn12, *btn13, *btn14, *btn15, *btn16, *btn17, *btn18, *btn19;
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
    NSArray             *arViewsForStep;
    NSMutableArray      *arImageLinks;
   
    NSArray             *arViewLayouConstainss;
    NSArray             *arLableAddSteps;
    

    NSURLSessionTask    *task;
    

}

@end

@implementation HBAddNewTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
    [self httpGetAllTask];
    
    [self stepPhotosInit];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UI touch event



- (void)checkAllTaskDetail:(UIButton *)sender
{
    
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
    
    lcValidateSubviewsHeight.constant = 0.f;
    vValidateSubview.hidden = YES;
    tfShopName.hidden = YES;
    
    [self setUIObjectHidden:arButtons];
    [self setUIObjectHidden:arViews];
    [self setUIObjectText:arButtons];
    [self setLayoutConstant:arButtonsLayoutConstraints];
    [self setScrollviewContainHeight];
}

- (NSMutableArray *)productStringObject:(int)number container:(NSMutableArray *)arrayObjects
{
    arrayObjects = [NSMutableArray array];
    for (int i ; i < number; i++) {
        NSString *str = @"";
        [arrayObjects addObject:str];
    }
    return arrayObjects;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return  YES;
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
    
   lcContentHeight.constant = lcTaskTypeContainHeight.constant + lcTaskPictureContainHeight.constant + lcValidateViewHeight.constant +2370-50*4-110*5*(120/110)-150 - 70;
    Dlog(@"llll:%f", lcContentHeight.constant);
    [self.view updateConstraints];
    [scv setContentSize:CGSizeMake(kSCREEN_WIDTH, lcContentHeight.constant)];
}

#pragma mark - other




@end
