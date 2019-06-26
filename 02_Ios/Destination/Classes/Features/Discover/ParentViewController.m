//
//  ViewController.m
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "ParentViewController.h"
#import "SPPageMenu.h"
#import "BaseViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThidViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"
#import "SevenViewController.h"
#import "EightViewController.h"

#import "JSBadgeView.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define pageMenuH 40
#define NaviH (screenH >= 812 ? 88 : 64) // 812是iPhoneX的高度
#define scrollViewHeight (screenH-NaviH-pageMenuH)

@interface ParentViewController () <SPPageMenuDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@end

@implementation ParentViewController

//示例3:SPPageMenuTrackerStyleLineAttachment,下划线依恋样式，当滑动底下装载控制器的scrollView时，该下划线会有阻尼效果
- (void)test3 {
    self.dataArr = @[@"生活",@"影视中心",@"交通",@"电视剧",@"搞笑",@"综艺"];
    
    // trackerStyle:跟踪器的样式
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, NaviH, screenW, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLineAttachment];
    // 传递数组，默认选中第2个
    [pageMenu setItems:self.dataArr selectedItemIndex:1];
    // 设置代理
    pageMenu.delegate = self;
    // 给pageMenu传递外界的大scrollView，内部监听self.scrollView的滚动，从而实现让跟踪器跟随self.scrollView移动的效果
    pageMenu.bridgeScrollView = self.scrollView;
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test3];
    
    [self.view addSubview:self.scrollView];

    NSArray *controllerClassNames = [NSArray arrayWithObjects:@"FirstViewController",@"SecondViewController",@"ThidViewController",@"FourViewController",@"FiveViewController",@"SixViewController",@"SevenViewController",@"EightViewController", nil];
    for (int i = 0; i < self.dataArr.count; i++) {
        if (controllerClassNames.count > i) {
            BaseViewController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
            id object = [self.pageMenu contentForItemAtIndex:i];
            if ([object isKindOfClass:[NSString class]]) {
                baseVc.text = object;
            } else if ([object isKindOfClass:[UIImage class]]) {
                baseVc.text = @"图片";
            } else {
                SPPageMenuButtonItem *item = (SPPageMenuButtonItem *)object;
                baseVc.text = item.title;
            }
            
            [self addChildViewController:baseVc];
            // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
            [self.myChildViewControllers addObject:baseVc];
        }
    }

    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        BaseViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [self.scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(screenW*self.pageMenu.selectedItemIndex, 0, screenW, scrollViewHeight);
        self.scrollView .contentOffset = CGPointMake(screenW*self.pageMenu.selectedItemIndex, 0);
        self.scrollView .contentSize = CGSizeMake(self.dataArr.count*screenW, 0);
    }
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"%zd------->%zd",fromIndex,toIndex);

    // 如果该代理方法是由拖拽self.scrollView而触发，说明self.scrollView已经在用户手指的拖拽下而发生偏移，此时不需要再用代码去设置偏移量，否则在跟踪模式为SPPageMenuTrackerFollowingModeHalf的情况下，滑到屏幕一半时会有闪跳现象。闪跳是因为外界设置的scrollView偏移和用户拖拽产生冲突
    if (!self.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:NO];
        } else {
            [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:YES];
        }
    }

    if (self.myChildViewControllers.count <= toIndex) {return;}

    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;

    targetViewController.view.frame = CGRectMake(screenW * toIndex, 0, screenW, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];

}

- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"插入一个带标题的item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self insertItemWithObject:@"十九大" toIndex:0];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"插入一个带图片的item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self insertItemWithObject:[UIImage imageNamed:@"Expression_1"] toIndex:0];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除一个item" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self removeItemAtIndex:0];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"删除所有item" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self removeAllItems];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:action4];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - insert or remove

// object是插入的对象(NSString、UIImage或SPPageMenuButtonItem),insertNumber是插入到第几个
- (void)insertItemWithObject:(id)object toIndex:(NSInteger)insertNumber {
    if (insertNumber > self.myChildViewControllers.count) return;
    // 插入之前，先将新控制器之后的控制器view往后偏移
    for (int i = 0; i < self.myChildViewControllers.count; i++) {
        if (i >= insertNumber) {
            UIViewController *childController = self.myChildViewControllers[i];
            childController.view.frame = CGRectMake(screenW * (i+1), 0, screenW, scrollViewHeight);
            [self.scrollView addSubview:childController.view];
        }
    }
    if (insertNumber <= self.pageMenu.selectedItemIndex && self.myChildViewControllers.count) { // 如果新插入的item在当前选中的item之前
        // scrollView往后偏移
        self.scrollView.contentOffset = CGPointMake(screenW*(self.pageMenu.selectedItemIndex+1), 0);
    } else {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    SixViewController *sixVc = [[SixViewController alloc] init];
    sixVc.text = @"我是新插入的";
    [self addChildViewController:sixVc];
    [self.myChildViewControllers insertObject:sixVc atIndex:insertNumber];
    
    // 要先添加控制器，再添加item，如果先添加item，会立即调代理方法，此时myChildViewControllers的个数还是0，在代理方法中retun了
    if ([object isKindOfClass:[NSString class]]) {
        [self.pageMenu insertItemWithTitle:object atIndex:insertNumber animated:YES];
    } else if([object isKindOfClass:[UIImage class]]) {
        [self.pageMenu insertItemWithImage:object atIndex:insertNumber animated:YES];
    } else {
        [self.pageMenu insertItem:object atIndex:insertNumber animated:YES];
    }
    
    // 重新设置scrollView容量
    self.scrollView.contentSize = CGSizeMake(screenW*self.myChildViewControllers.count, 0);
}

- (void)removeItemAtIndex:(NSInteger)index {
    // 示例中index给的是1，所以当只剩下一个子控制器时，会走该if语句，无法继续删除
    if (index >= self.myChildViewControllers.count) {
        return;
    }
    
    [self.pageMenu removeItemAtIndex:index animated:YES];
    
    // 删除之前，先将新控制器之后的控制器view往前偏移
    for (int i = 0; i < self.myChildViewControllers.count; i++) {
        if (i >= index) {
            UIViewController *childController = self.myChildViewControllers[i];
            childController.view.frame = CGRectMake(screenW * (i>0?(i-1):i), 0, screenW, scrollViewHeight);
            [self.scrollView addSubview:childController.view];
        }
    }
    if (index <= self.pageMenu.selectedItemIndex) { // 移除的item在当前选中的item之前
        // scrollView往前偏移
        NSInteger offsetIndex = self.pageMenu.selectedItemIndex-1;
        if (offsetIndex < 0) {
            offsetIndex = 0;
        }
        self.scrollView.contentOffset = CGPointMake(screenW*offsetIndex, 0);
    }
    
    UIViewController *vc = [self.myChildViewControllers objectAtIndex:index];
    [self.myChildViewControllers removeObjectAtIndex:index];
    [vc removeFromParentViewController];
    [vc.view removeFromSuperview];
    
    // 重新设置scrollView容量
    self.scrollView.contentSize = CGSizeMake(screenW*self.myChildViewControllers.count, 0);
}

- (void)removeAllItems {
    [self.pageMenu removeAllItems];
    for (UIViewController *vc in self.myChildViewControllers) {
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }
    [self.myChildViewControllers removeAllObjects];
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.contentSize = CGSizeMake(0, 0);
    
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // 这一步是实现跟踪器时刻跟随scrollView滑动的效果,如果对self.pageMenu.scrollView赋了值，这一步可省
    // [self.pageMenu moveTrackerFollowScrollView:scrollView];
}


#pragma mark - getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NaviH+pageMenuH, screenW, scrollViewHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return  _scrollView;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
