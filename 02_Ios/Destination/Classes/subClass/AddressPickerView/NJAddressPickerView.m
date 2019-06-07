//
//  NJAddressPickerView.m
//  SmartCity
//
//  Created by TouchWorld on 2018/4/24.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "NJAddressPickerView.h"
#import "NJPickerAddressItem.h"
#import <MJExtension.h>

@interface NJAddressPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>
/********* <#注释#> *********/
@property(nonatomic,weak)UIView * containerView;

/********* <#注释#> *********/
@property(nonatomic,weak)UIView * topView;

/********* 数据模型 *********/
@property(nonatomic,strong)NSArray<NJProvinceItem *> * provinceArr;

/********* 当前选中省份 *********/
@property(nonatomic,assign)NSInteger currentProvinceIndex;
/********* 当前选中的城市 *********/
@property(nonatomic,assign)NSInteger currentCityIndex;
/********* 当前选中的地区 *********/
@property(nonatomic,assign)NSInteger currentDistrictIndex;
@end
@implementation NJAddressPickerView
+ (instancetype)addressPickerView
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
    [NJProvinceItem mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"citylist" : @"NJCityItem",
                 };
    }];
    
    [NJCityItem mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"arealist" : @"NJAreaItem",
                 };
    }];
    
    self.backgroundColor = NJGrayColorAlpha(0, 0);
    self.currentProvinceIndex = 0;
    
    UIView * bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tapGesture];
    
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 300)];
    [self addSubview:containerView];
    
    
    self.containerView = containerView;
    
    containerView.backgroundColor = [UIColor whiteColor];
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.containerView.NJ_width, 40)];
    self.topView = topView;
    [containerView addSubview:topView];

    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 40)];
        [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:97.0 / 255.0 green:97.0 / 255.0 blue:97.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor colorWithRed:234.0 / 255.0 green:138.0 / 255.0 blue:88.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        }
        [topView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.bounds), 260)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    
    //设置pickerView默认选中当前时间

    
    [containerView addSubview:pickerView];

}

#pragma mark - UIPickerViewDataSource方法
//几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//每列几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0://省份
        {
            return self.provinceArr.count;
        }
            break;
        case 1://城市
        {
            NJProvinceItem * provinceItem = self.provinceArr[self.currentProvinceIndex];
            return provinceItem.citylist.count;
        }
            break;
        case 2://地区
        {
            NJProvinceItem * provinceItem = self.provinceArr[self.currentProvinceIndex];
            NJCityItem * cityItem = provinceItem.citylist[self.currentCityIndex];
            return cityItem.arealist.count;
        }
            break;
            
        default:
            return 0;
            break;
    }
}
//某一列的哪一行的信息
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    switch (component) {
        case 0://省份
        {
            titleLabel.text = self.provinceArr[row].name;
        }
            break;
        case 1://城市
        {
            NJProvinceItem * provinceItem = self.provinceArr[self.currentProvinceIndex];
            NJCityItem * cityItem = provinceItem.citylist[row];
            titleLabel.text = cityItem.name;
        }
            break;
        case 2://地区
        {
            NJProvinceItem * provinceItem = self.provinceArr[self.currentProvinceIndex];
            NJCityItem * cityItem = provinceItem.citylist[self.currentCityIndex];
            NJAreaItem * areaItem = cityItem.arealist[row];
            titleLabel.text = areaItem.name;
        }
            break;
            
        default:
            titleLabel.text = @"其他";
            break;
    }
    return titleLabel;
}

#pragma mark - UIPickerViewDelegate方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    NSLog(@"%ld--%ld", component, row);
    switch (component) {
        case 0://省份
        {
            //滑动了第0列，更新后两列
            self.currentProvinceIndex = row;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            self.currentCityIndex = 0;
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
        case 1://城市
        {
            //滑动了第一列，更新后一列
            self.currentCityIndex = row;
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            
        }
            break;
        case 2://地区
        {
            self.currentDistrictIndex = row;
        }
            break;
            
        default:
            break;
    }
    //    HDLog(@"%ld--%ld--%ld",self.currentProvinceIndex, self.currentCityIndex, self.currentDistrictIndex);
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
#pragma mark - 事件
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        if(self.confirmBlock != nil)
        {
            NJProvinceItem * provinceItem = self.provinceArr[self.currentProvinceIndex];
            //选择的省份
            NSString * provinceName = provinceItem.name;
            
            NJCityItem * cityItem = provinceItem.citylist[self.currentCityIndex];
            //选择的城市
            NSString * cityName = cityItem.name;
            
            NJAreaItem * areaItem = cityItem.arealist[self.currentDistrictIndex];
            //选择的地区
            NSString * districtName = areaItem.name;
            NSString * address = districtName;
            if([provinceName isEqualToString:cityName])//什么市（北京市）
            {
                address = [NSString stringWithFormat:@"%@%@", cityName, districtName];
            }
            else
            {
                address = [NSString stringWithFormat:@"%@%@%@", provinceName, cityName, districtName];
            }
            self.confirmBlock(provinceName, cityName, districtName, address);
        }
        [self dismiss];
    }
}

#pragma mark - 懒加载
- (NSArray<NJProvinceItem *> *)provinceArr
{
    if(_provinceArr == nil)
    {
        NSString * pathStr = [[NSBundle mainBundle] pathForResource:@"ChinaProvince.plist" ofType:nil];
        //所有省份的信息
        NSArray * provinceArr = [NSArray arrayWithContentsOfFile:pathStr];
        
        self.provinceArr = [NJProvinceItem mj_objectArrayWithKeyValuesArray:provinceArr];

    }
    return _provinceArr;
}
@end
