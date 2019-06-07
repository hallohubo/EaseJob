//
//  HD3DScrollView.h
//  HD3DScrollView
//
//  Created by DennisHu
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HB3DScrollViewEffect) {
    HB3DScrollViewEffectNone,
    HB3DScrollViewEffectTranslation,
    HB3DScrollViewEffectDepth,
    HB3DScrollViewEffectCarousel,
    HB3DScrollViewEffectCards
};

@interface HB3DScrollView : UIScrollView

@property (nonatomic) HB3DScrollViewEffect effect;

@property (nonatomic) CGFloat angleRatio;

@property (nonatomic) CGFloat rotationX;
@property (nonatomic) CGFloat rotationY;
@property (nonatomic) CGFloat rotationZ;

@property (nonatomic) CGFloat translateX;
@property (nonatomic) CGFloat translateY;

- (NSUInteger)currentPage;

- (void)loadNextPage:(BOOL)animated;
- (void)loadPreviousPage:(BOOL)animated;
- (void)loadPageIndex:(NSUInteger)index animated:(BOOL)animated;

@end
