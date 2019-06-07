//
//  NJCollectionViewFlowLayout.m
//  June_five_自定义流水布局
//
//  Created by TouchWorld on 2017/6/7.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "NJCollectionViewFlowLayout.h"
/*
 自定义布局:只要了解5个方法
 
 - (void)prepareLayout;
 
 - (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
 
 - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
 
 - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity; // return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
 
 - (CGSize)collectionViewContentSize;
 
 */
@implementation NJCollectionViewFlowLayout
//CollectionView第一次布局时调用，刷新时调用
- (void)prepareLayout
{
    [super prepareLayout];
//    NSLog(@"%s",__func__);
}
// 计算collectionView滚动范围
- (CGSize)collectionViewContentSize
{
    CGSize contentSize = [super collectionViewContentSize];
//    NSLog(@"%@",NSStringFromCGSize(contentSize));
    return contentSize;
}
// 作用:指定一段区域给你这段区域内cell的尺寸
// 可以一次性返回所有cell尺寸,也可以每隔一个距离返回cell
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
//    NSLog(@"%@",NSStringFromCGRect(rect));
//    NSArray * attris = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, CGFLOAT_MAX, CGFLOAT_MAX)];
//    for (UICollectionViewLayoutAttributes * attr in attris) {
//        NSLog(@"%@",attr);
//    }
    //获得当前可是范围内的所有cell
    NSArray * attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    CGFloat width = self.collectionView.bounds.size.width;
    for (UICollectionViewLayoutAttributes * attr in attrs) {
        //计算与屏幕中心点的距离
        CGFloat distance = fabs(attr.center.x - self.collectionView.contentOffset.x - width * 0.5) ;
        CGFloat scale = 1 - (distance / (width * 0.5)) * 0.25;
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return attrs;
}
// Invalidate:刷新
// 在滚动的时候是否允许刷新布局
 - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
// 什么时候调用:用户手指一松开就会调用
// 作用:确定最终偏移量
// 定位:距离中心点越近,这个cell最终展示到中心点
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //1.停止移动后的位置坐标，最终偏移量
    CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    //2.显示区域的宽度
    CGFloat displayW = self.collectionView.bounds.size.width;
    //3.获得停止后的区域范围的所有cell
    NSArray * attrs = [super layoutAttributesForElementsInRect:CGRectMake(targetP.x, 0, displayW, CGFLOAT_MAX)];
    //计算与中心点的最小值
    CGFloat smallest = CGFLOAT_MAX;
    CGFloat width = self.collectionView.bounds.size.width;
    for (UICollectionViewLayoutAttributes * attr in attrs) {
        // 获取距离中心点距离:注意:应该用最终的x
        CGFloat distance = attr.center.x - targetP.x - width * 0.5 ;
        if(fabs(smallest) > fabs(distance))
        {
            smallest = distance;
        }
        
    }
    //最终偏移量加上最小量
    targetP.x += smallest;
    if(targetP.x < 0)
    {
        targetP.x = 0;
    }
//    NSLog(@"%@%@",NSStringFromCGRect(self.collectionView.bounds),NSStringFromCGPoint(proposedContentOffset));
    return targetP;
}
@end
