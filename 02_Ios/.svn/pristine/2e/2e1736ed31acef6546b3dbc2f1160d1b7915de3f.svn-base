//
//  NJModalListView.m
//  Destination
//
//  Created by TouchWorld on 2018/10/15.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJModalListView.h"
#import <SVProgressHUD.h>
#import "NJBankCell.h"
//#import "NJPugFooterView.h"
#import "NJAddBankTableFooterView.h"
//#import "NJBankCardItem.h"


@interface NJModalListView () <UITableViewDataSource, UITableViewDelegate>
/********* <#注释#> *********/
@property(nonatomic,weak)UIView * containerView;

/********* <#注释#> *********/
@property(nonatomic,weak)UIView * topView;

/********* tableView *********/
@property(nonatomic,weak)UITableView * tableView;

/********* tableFooterView *********/
@property(nonatomic,strong)NJAddBankTableFooterView * tableFooterView;

@end
@implementation NJModalListView
static NSString * const ID = @"NJBankCell";
static NSString * const FooterID = @"NJPugFooterView";

+ (instancetype)modalListView
{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupInit];
    }
    return self;
}

#pragma mark - 设置初始化
- (void)setupInit
{
    self.backgroundColor = NJGrayColorAlpha(0, 0);
    
    UIView * bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tapGesture];
    
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 273)];
    [self addSubview:containerView];
    
    self.containerView = containerView;
    
    containerView.backgroundColor = NJBgColor;
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.containerView.NJ_width, 60)];
    self.topView = topView;
    topView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:topView];
    
    //icon_delected
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HDScreenW, 25)];
    titleLable.center = topView.center;
    titleLable.font = [UIFont systemFontOfSize:18.0];
    titleLable.textColor = [UIColor blackColor];
    titleLable.text = @"选择到账银行卡";
    titleLable.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLable];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 52, topView.NJ_height);
    [cancelBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [topView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    //tableview
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.NJ_height + 1, HDScreenW, containerView.NJ_height - topView.NJ_height - 1) style:UITableViewStylePlain];
    [containerView addSubview:tableView];
    self.tableView = tableView;
    
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
    tableView.tableFooterView = self.tableFooterView;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NJBankCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    
//    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NJPugFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:FooterID];
    
}

#pragma mark - UITableViewDataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bankCardArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NJBankCell * cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    NJBankCardItem * item = self.bankCardArr[indexPath.section];
    cell.item = item;
    return cell;
}
#pragma mark - UITableViewDelegate方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NJBankCardItem * item = self.bankCardArr[indexPath.section];
    [self dismiss];
    if(self.selectedBankCardBlock)
    {
        self.selectedBankCardBlock(item);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    NJPugFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FooterID];
//    footerView.bgView.backgroundColor = NJBgColor;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - pickerView出现
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        self.containerView.center = CGPointMake(self.frame.size.width/2, self.containerView.center.y - self.containerView.frame.size.height);
        self.backgroundColor = NJGrayColorAlpha(0, 0.4);
    }];
}
#pragma mark - pickerView消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.containerView.center = CGPointMake(self.frame.size.width/2, self.containerView.center.y + self.containerView.frame.size.height);
        self.backgroundColor = NJGrayColorAlpha(0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - setter


#pragma mark - 事件
- (void)addNewBankCard
{
    [self dismiss];
    if(self.addNewBankCardBlock)
    {
        self.addNewBankCardBlock();
    }
}

#pragma mark - 懒加载
- (NJAddBankTableFooterView *)tableFooterView
{
    if(_tableFooterView == nil)
    {
        _tableFooterView = [NJAddBankTableFooterView NJ_loadViewFromXib];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewBankCard)];
        [_tableFooterView addGestureRecognizer:tapGesture];
        _tableFooterView.frame = CGRectMake(0, 0, HDScreenW, 49);
    }
    return _tableFooterView;
}

- (void)setBankCardArr:(NSArray<NJBankCardItem *> *)bankCardArr
{
    _bankCardArr = bankCardArr;
    [self.tableView reloadData];
}
@end
