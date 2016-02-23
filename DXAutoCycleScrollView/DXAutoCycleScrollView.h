//
//  DXAutoCycleScrollView.h
//  AutoCycleScrollView
//
//  Created by 陈达欣 on 16/2/22.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DXAutoCycleScrollViewDelegate <NSObject>

@optional
/**
 *  监听当前显示图片的imageView的点击
 *  @param index   当前点击图片的索引
 */
- (void)autoCycleScrollView:(UIView *)scrollView didClickImageAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, DXAutoCycleScrollViewDirection) {
    /**水平滚动*/
    DXAutoCycleScrollViewDirectionHorizontal = 0,
    /**垂直滚动*/
    DXAutoCycleScrollViewDirectionVertical = 1
};

@interface DXAutoCycleScrollView : UIView

/**本地图片数据*/
@property(nonatomic, strong) NSArray *images;
/**滚动方向*/
@property(nonatomic,assign)DXAutoCycleScrollViewDirection scrollDirection;
/**代理*/
@property(nonatomic, weak)id <DXAutoCycleScrollViewDelegate> delegate;

/************** PageControl ***************/
@property(nonatomic, weak, readonly)UIPageControl *pageControl;
/**当前显示页码*/
@property(nonatomic, strong) UIImage *currentPageImage;
/**其他页码*/
@property(nonatomic, strong) UIImage *pageImage;

@end
