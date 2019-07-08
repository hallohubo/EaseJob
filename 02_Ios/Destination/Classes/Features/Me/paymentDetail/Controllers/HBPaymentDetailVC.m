//
//  HBPaymentDetailVC.m
//  Destination
//
//  Created by 胡勃 on 7/7/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBPaymentDetailVC.h"
#import "SPPageMenu.h"
#import "BaseViewController.h"

@interface HBPaymentDetailVC ()<SPPageMenuDelegate>
{
    IBOutlet UIScrollView   *scv;
    IBOutlet SPPageMenu     *vPageMenu;
}

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;

@end

@implementation HBPaymentDetailVC

#pragma mark - lifeCycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self setupPageMenuInit];
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
//     如果该代理方法是由拖拽self.scrollView而触发，说明self.scrollView已经在用户手指的拖拽下而发生偏移，此时不需要再用代码去设置偏移量，否则在跟踪模式为SPPageMenuTrackerFollowingModeHalf的情况下，滑到屏幕一半时会有闪跳现象。闪跳是因为外界设置的scrollView偏移和用户拖拽产生冲突
    if (!scv.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [scv setContentOffset:CGPointMake(kSCREEN_WIDTH * toIndex, 0) animated:NO];
        } else {
            [scv setContentOffset:CGPointMake(kSCREEN_WIDTH * toIndex, 0) animated:YES];
        }
    }
    
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(kSCREEN_WIDTH * toIndex, 0, kSCREEN_WIDTH, scv.bounds.size.height);
    [scv addSubview:targetViewController.view];
    
}


#pragma mark - event



#pragma mark - setter and getter

- (void)setup
{
    self.title = @"收支明细";
}

- (void)setupPageMenuInit
{
    self.dataArr = @[@"佣金金额",@"任务余额",@"保证金",@"冻结金额"];
    
    CGRect frame = [vPageMenu convertRect:vPageMenu.bounds toView:self.view];
    Dlog(@"WINDowframe1:%@", NSStringFromCGRect(frame));
    
    vPageMenu = [SPPageMenu pageMenuWithFrame:frame trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    
    // 传递数组，默认选中第1个
    [vPageMenu setItems:self.dataArr selectedItemIndex:0];
    // 不可滑动的等宽排列
    vPageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    vPageMenu.trackerWidth = 40;
    // 设置代理
    vPageMenu.delegate = self;
    //给pageMenu传递外界的大scrollView，内部监听self.scrollView的滚动，
    //从而实现让跟踪器跟随self.scrollView移动的效果
    vPageMenu.bridgeScrollView = scv;
    [self.view addSubview:vPageMenu];
    
    NSArray *controllerClassNames = [NSArray arrayWithObjects:
                                     @"HBCommissionBalanceVC",
                                     @"HBTaskBalanceVC",
                                     @"HBMarginVC",
                                     @"HBAmountFrozenVC",
                                     nil
                                     ];
    for (int i = 0; i < self.dataArr.count; i++) {
        if (controllerClassNames.count > i) {
            BaseViewController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
            [self addChildViewController:baseVc];
            // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
            [self.myChildViewControllers addObject:baseVc];
        }
    }
    
    // pageMenu.selectedItemIndex就是选中的item下标
    if (vPageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        BaseViewController *baseVc = self.myChildViewControllers[vPageMenu.selectedItemIndex];
        CGRect frame = [scv convertRect:scv.bounds toView:self.view];
        [scv addSubview:baseVc.view];
        
        baseVc.view.frame = CGRectMake(kSCREEN_WIDTH * vPageMenu.selectedItemIndex, 0, kSCREEN_WIDTH, scv.bounds.size.height);
        
        scv.contentOffset = CGPointMake(kSCREEN_WIDTH * vPageMenu.selectedItemIndex, 0);
        scv.contentSize = CGSizeMake(self.dataArr.count * kSCREEN_WIDTH, 0);
    }
    
}

- (NSMutableArray *)myChildViewControllers {
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    return _myChildViewControllers;
}

- (void)dealloc {
    NSLog(@"父控制器被销毁了");
}
@end
