//
//  UILabel+NJChangeLineSpaceAndWordSpace.h
//  ConsumptionPlus
//
//  Created by TouchWorld on 2017/12/5.
//  Copyright © 2017年 qichen. All rights reserved.
//



@interface UILabel (NJChangeLineSpaceAndWordSpace)
//改变行间距
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

//改变字间距
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

//改变行间距和字间距
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
