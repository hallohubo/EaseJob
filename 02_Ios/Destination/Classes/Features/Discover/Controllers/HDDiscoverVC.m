//
//  HDDiscoverVC.m
//  Destination
//
//  Created by hufan on 2019/6/1.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HDDiscoverVC.h"
#import "HBDiscoverCell.h"
#import "HBDiscoverModel.h"

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



@interface HDDiscoverVC ()<UINavigationControllerDelegate ,SPPageMenuDelegate, UIScrollViewDelegate>
{
    IBOutlet UITextField    *tfSearch;
    IBOutlet UIView         *vSearch;
    IBOutlet UIScrollView    *tbv;
    IBOutlet SPPageMenu     *vPageMenu;
    IBOutlet UIView         *vHead;
    NSArray                     *arBtn;
    NSURLSessionDataTask        *task;
    NSMutableArray              *marDiscoverList;
}

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;

@end

@implementation HDDiscoverVC

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self setupPageMenuInit];
//    [self httpGetRecentlyNews:1];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return marDiscoverList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"HBDiscoverCell";
    HBDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [HBDiscoverCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HBDiscoverModel *model = marDiscoverList[indexPath.section];
    
    cell.vBackground.layer.cornerRadius = 6.f;
    cell.vBackground.layer.masksToBounds= YES;
    
    [cell.imvPhoto setImage:HDIMAGE(@"main_cellHeadImage")];
    cell.lbMainheading.text = model.TaskTitle;
    NSString *strAmount = HDFORMAT(@"%@/%@", model.HasSaleNum, model.Quantity);
    cell.lbSubheading.text  = strAmount;
    cell.lbMoney.text = model.Commission;//@"¥ +1.99元";
    
    return cell;
}

#pragma mark - http event

- (void)httpGetRecentlyNews:(NSInteger)indexPage  //
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"PageSize": @"10",
                          @"PageIndex": @(indexPage),
                          @"type": @"0",
                          };
    [helper.parameters addEntriesFromDictionary:dic];
    
    task = [helper postPath:@"Act204" object:[HBDiscoverModel class] finished:^(HDError *error, id object, BOOL isLast, id json)
            {
                if (error) {
                    if (error.code != 0 ) {
                        [HDHelper say:error.desc];
                    }
                    return ;
                }
                if (!object) {
                    return;
                }
                marDiscoverList = object;
               
                
            }];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
     //这一步是实现跟踪器时刻跟随scrollView滑动的效果,如果对self.pageMenu.scrollView赋了值，这一步可省
//     [vPageMenu moveTrackerFollowScrollView:scrollView];
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    
    // 如果该代理方法是由拖拽self.scrollView而触发，说明self.scrollView已经在用户手指的拖拽下而发生偏移，此时不需要再用代码去设置偏移量，否则在跟踪模式为SPPageMenuTrackerFollowingModeHalf的情况下，滑到屏幕一半时会有闪跳现象。闪跳是因为外界设置的scrollView偏移和用户拖拽产生冲突
    if (!tbv.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [tbv setContentOffset:CGPointMake(kSCREEN_WIDTH * toIndex, 0) animated:NO];
        } else {
            [tbv setContentOffset:CGPointMake(kSCREEN_WIDTH * toIndex, 0) animated:YES];
        }
    }
    
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(kSCREEN_WIDTH * toIndex, 0, kSCREEN_WIDTH, tbv.bounds.size.height);
    [tbv addSubview:targetViewController.view];
    
}

#pragma mark - event



#pragma mark - setter and getter

- (void)setup
{
    self.navigationController.delegate = self;//设置导航控制器的代理为self

    [vSearch addBorderWidth:.1f color:nil cornerRadius:15.0];
}

- (void)setupPageMenuInit
{
    self.dataArr = @[@"全部",@"简单",@"高价",@"UIP"];
    //UIView *window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = [vPageMenu convertRect:vPageMenu.bounds toView:self.view];
//    Dlog(@"WINDowframe0:%@", NSStringFromCGRect(window.frame));
//    Dlog(@"WINDowbound0:%@", NSStringFromCGRect(window.bounds));

    Dlog(@"WINDowframe1:%@", NSStringFromCGRect(frame));
//    frame.origin.y = frame.origin.y-20;
    
    vPageMenu = [SPPageMenu pageMenuWithFrame:frame trackerStyle:SPPageMenuTrackerStyleLine];
    
    // 传递数组，默认选中第1个
    [vPageMenu setItems:self.dataArr selectedItemIndex:0];
//    vPageMenu.backgroundColor = HDCOLOR_RED;
    // 设置代理
    vPageMenu.delegate = self;
    //给pageMenu传递外界的大scrollView，内部监听self.scrollView的滚动，
    //从而实现让跟踪器跟随self.scrollView移动的效果
    vPageMenu.bridgeScrollView = tbv;
    [self.view addSubview:vPageMenu];
    
    NSArray *controllerClassNames = [NSArray arrayWithObjects:@"FirstViewController",@"SecondViewController",@"ThidViewController", @"FourViewController", nil];
    for (int i = 0; i < self.dataArr.count; i++) {
        if (controllerClassNames.count > i) {
            BaseViewController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
            id object = [vPageMenu contentForItemAtIndex:i];
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
    if (vPageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        BaseViewController *baseVc = self.myChildViewControllers[vPageMenu.selectedItemIndex];
        CGRect frame = [tbv convertRect:tbv.bounds toView:self.view];
        [tbv addSubview:baseVc.view];
        
        baseVc.view.frame = CGRectMake(kSCREEN_WIDTH * vPageMenu.selectedItemIndex, 0, kSCREEN_WIDTH, tbv.bounds.size.height);
        
        tbv.contentOffset = CGPointMake(kSCREEN_WIDTH * vPageMenu.selectedItemIndex, 0);
        tbv.contentSize = CGSizeMake(self.dataArr.count * kSCREEN_WIDTH, 0);
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
