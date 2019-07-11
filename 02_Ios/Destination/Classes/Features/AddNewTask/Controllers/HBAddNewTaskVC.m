//
//  HBAddNewTaskVC.m
//  Destination
//
//  Created by 胡勃 on 7/8/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBAddNewTaskVC.h"
#import "HBAllTaskTypeModle.h"

@interface HBAddNewTaskVC ()
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
    
    IBOutlet NSLayoutConstraint     *lcImvHeight0;//添加步骤图高度值跟随lable的显示和隐藏变化
    IBOutlet NSLayoutConstraint     *lcImvHeight1;
    IBOutlet NSLayoutConstraint     *lcImvHeight2;
    IBOutlet NSLayoutConstraint     *lcImvHeight3;
    IBOutlet NSLayoutConstraint     *lcImvHeight4;
    
    
    IBOutlet UIView         *vPhotoContain0, *vPhotoContain1, *vPhotoContain2,
                            *vPhotoContain3, *vPhotoContain4;
    IBOutlet UIImageView    *imvPhoto0, *imvPhoto1, *imvPhoto2, *imvPhoto3,                                 *imvPhoto4;
    IBOutlet UIImageView    *imvBack0, *imvBack1, *imvBack2, *imvBack3, *imvBack4;
    IBOutlet UILabel        *lbAddStep0, *lbAddStep1, *lbAddStep2, *lbAddStep3, *lbAddStep4;
    IBOutlet UITextView     *tvphotoDes0, *tvphotoDes1, *tvphotoDes2, *tvphotoDes3, *tvphotoDes4;
    
    IBOutlet UIButton       *btn0, *btn1, *btn2, *btn3, *btn4, *btn5, *btn6,
                            *btn7, *btn8, *btn9, *btn10, *btn11, *btn12, *btn13, *btn14, *btn15, *btn16, *btn17, *btn18, *btn19;
    IBOutlet UIButton       *btnPaidTask, *btnNotPaidTask;
    IBOutlet UIButton       *btnAll, *btnAndroid, *btnIOS;
    IBOutlet UITextField    *tfTastTitle;
    IBOutlet UIImageView    *imvValidate0, *imvValidate1, *imvValidate2;
    IBOutlet UITextField    *tfValidateDes, *tfValidateDes1, *tfValidateDes2;
    IBOutlet UILabel        *lbCommissionDes, *lbTaskNumbers, *lbExpect;
    IBOutlet UITextField    *tfLinkAddress;
    IBOutlet UIButton       *btnShow, *btnHide;
    IBOutlet UITextView     *tvTaskAdditionDescription;
    IBOutlet UILabel        *lbTaskLimit, *lbAuditTime;
    IBOutlet UIButton       *BtnRedoYes, *btnRedoNo;
    IBOutlet UIButton       *btnAgreement;
    IBOutlet UILabel        *lbShowAgreement;
    IBOutlet UIButton       *btnRelease, *btnPreview;

    NSArray             *arButtons;
    NSArray             *arButtonsLayoutConstraints;
    
    NSMutableArray      *marAllTaskList;
    NSMutableArray      *marOrderList;

    NSURLSessionTask    *task;

}

@end

@implementation HBAddNewTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
//    [self httpGetAllTask];
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
//        [self setAllTaskView];
    }];
}



#pragma mark - setter and getter

- (void)setupInit
{
    self.title = @"新任务";
    
    arButtons  = @[btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9, btn10, btn11, btn12, btn13, btn14, btn15, btn16, btn17, btn18, btn19];
    
    [self setUIObjectHiden:arButtons];
}

- (void)setUIObjectHiden:(NSArray *)UIObject
{
    for (id object in UIObject) {
        [object setHidden:YES];
    }
    
}

- (void)setScrollviewContainHeight
{
    lcContentHeight.constant = lcTaskTypeContainHeight.constant + lcTaskPictureContainHeight.constant;
    [self.view updateConstraints];
}

- (void)setAllTaskView  // according the all task case to change task's view
{
//    for (int i = 0; i < marAllTaskList.count; i++) {
//        HBAllTaskTypeModle *model = marAllTaskList[i];
//        UIButton *btn   = arButtons[i];
//        btn.hidden  = NO;
//        btn.tag = i;
//        [btn addTarget:self action:@selector(checkAllTaskDetail:) forControlEvents:UIControlEventTouchUpInside];
//        btn.titleLabel.text = model.TaskType;
//    }
//    //need to change the tableview's height at the head part of view
////    lcTaskModelHeight.constant = marOrderList.count > 5 ? 150 : 90;
//    [self setViewHeight:marOrderList.count > 5 ? 150 : 90];
}

- (void)setViewHeight:(NSInteger)intHeight  //adjust the tableview's head
{
    CGFloat height = intHeight + HDDeviceSize.height;
}

#pragma mark - other




@end
