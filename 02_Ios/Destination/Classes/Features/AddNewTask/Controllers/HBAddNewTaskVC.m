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
    IBOutlet NSLayoutConstraint     *lcContentHeight;
    IBOutlet NSLayoutConstraint     *lcTaskModelHeight;
    IBOutlet UIButton               *btn0, *btn1, *btn2, *btn3, *btn4,
                                    *btn5, *btn6, *btn7, *btn8, *btn9;
    NSArray             *arButtons;
    NSMutableArray      *marAllTaskList;
    NSMutableArray      *marOrderList;

    NSURLSessionTask    *task;

}

@end

@implementation HBAddNewTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
    [self httpGetAllTask];
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
        [self setAllTaskView];
    }];
}



#pragma mark - setter and getter

- (void)setupInit
{
    self.title = @"新任务";
    
    arButtons  = @[btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9];
    [self setUIObjectHiden:arButtons];
}

- (void)setUIObjectHiden:(NSArray *)UIObject
{
    for (id object in UIObject) {
        [object setHidden:YES];
    }
}

- (void)setAllTaskView  // according the all task case to change task's view
{
    for (int i = 0; i < marAllTaskList.count; i++) {
        HBAllTaskTypeModle *model = marAllTaskList[i];
        UIButton *btn   = arButtons[i];
        btn.hidden  = NO;
        btn.tag = i;
        [btn addTarget:self action:@selector(checkAllTaskDetail:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.text = model.TaskType;
    }
    //need to change the tableview's height at the head part of view
    lcTaskModelHeight.constant = marOrderList.count > 5 ? 150 : 90;
    [self setViewHeight:marOrderList.count > 5 ? 150 : 90];
}

- (void)setViewHeight:(NSInteger)intHeight  //adjust the tableview's head
{
    CGFloat height = intHeight + HDDeviceSize.height;
}

#pragma mark - other




@end
