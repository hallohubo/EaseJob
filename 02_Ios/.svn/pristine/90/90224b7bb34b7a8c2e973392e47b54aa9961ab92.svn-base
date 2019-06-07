//
//  LableView.m
//  BusinessProject
//
//  Created by 中庚环境 on 17/4/11.
//  Copyright © 2017年 ZhongGengKeJi. All rights reserved.
//

#import "LableView.h"
#import "myLabel.h"
@implementation LableView

- (instancetype)initWith:(NSString *)left rightLable:(NSString *)right imageNS:(NSString *)imge AndTag:(int)m_tag
{
    self = [super init];
    if (self) {
        [self Subviews];
        [self configLeftlabel:left rightLable:right image:imge AndTag:m_tag];
    }
    return self;
}
-(void)Subviews{
    
    _LableView  = [[UIView alloc]init];
    _LableView.userInteractionEnabled = YES;
    _LableView.backgroundColor = WhiteColor;
    [self addSubview:_LableView];
    [_LableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        
    }];
    _LineView  = [[UIView alloc]init];
    _LineView.backgroundColor = LineViewColor;
    [_LableView addSubview:_LineView];
    [_LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-0.5);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(HDScreenW-15, 0.5));
    }];
}

-(void)configLeftlabel:(NSString *)left rightLable:(NSString*)right image:(NSString*)imge AndTag:(int)m_tag{
   
    self.left = [[UILabel alloc]init];
    self.left.text = left;
    self.left.textColor = TextfieldPlasehoderColor;
    self.left.font = Font(16);
    [self.LableView addSubview:self.left];
    
   _HLTextField = [[UITextField alloc]init];
    _HLTextField.font = [UIFont systemFontOfSize:16];
    _HLTextField.backgroundColor = [UIColor whiteColor];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = TextfieldPlasehoderColor;
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:right attributes:dict];
    [_HLTextField setAttributedPlaceholder:attribute];
    [self.LableView addSubview:_HLTextField];
    
    _fllowImage = [[UIImageView alloc]init];
    _fllowImage.frame =CGRectMake(HDScreenW-15-16, 17, 16, 16);
    _fllowImage.image = [UIImage imageNamed:imge];
    _fllowImage.contentMode = UIViewContentModeScaleAspectFill;
    _fllowImage.clipsToBounds = YES;
    [_LableView addSubview:_fllowImage];
    [self.left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    
    [self.HLTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.left.mas_centerY).offset(0);
        make.left.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(HDScreenW-50-100, 30));
    }];
    
    
    
}


@end
