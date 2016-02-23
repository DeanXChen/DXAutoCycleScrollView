//
//  DXAutoCycleScrollView.h
//  无限滚动
//
//  Created by 陈达欣 on 16/2/21.
//  Copyright © 2016年 cdx. All rights reserved.
//

#import "DXAutoCycleScrollView.h"

@interface DXAutoCycleScrollView () <UIScrollViewDelegate>

@property(nonatomic, weak)UIScrollView *scrollView;
@property(nonatomic, weak)UIPageControl *pageControl;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation DXAutoCycleScrollView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //添加scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //添加三个imageView
        for (NSInteger i = 0; i< 3; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [scrollView addSubview:imageView];
        }
        
        //添加PageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [pageControl setValue:[UIImage imageNamed:@"DXAutoCycleScrollView.bundle/other"] forKeyPath:@"_pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"DXAutoCycleScrollView.bundle/current"] forKeyPath:@"_currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        //开启定时器
        [self starTimer];
    }
    
    return self;
}

#pragma mark - 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //常量
    CGFloat scrollViewW = self.bounds.size.width;
    CGFloat scrollViewH = self.bounds.size.height;
    CGFloat pageControlW = 150;
    CGFloat pageControlH = 30;
    
    //设置scrollView
    self.scrollView.frame = self.bounds;
    
    if (self.scrollDirection == DXAutoCycleScrollViewDirectionHorizontal) {
        self.scrollView.contentSize = CGSizeMake(scrollViewW * 3, self.scrollView.contentSize.height);
    } else if (self.scrollDirection == DXAutoCycleScrollViewDirectionVertical) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, scrollViewH * 3);
    }
    
    //设置imageView
    for (NSInteger i = 0; i< 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        if (self.scrollDirection == DXAutoCycleScrollViewDirectionHorizontal) {
            imageView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, self.bounds.size.height);
        } else if (self.scrollDirection == DXAutoCycleScrollViewDirectionVertical) {
            imageView.frame = CGRectMake(0, i *scrollViewH, scrollViewW, self.bounds.size.height);
        }
    }
    
    //设置pageControl
    self.pageControl.frame = CGRectMake(scrollViewW - pageControlW, scrollViewH - pageControlH, pageControlW, pageControlH);
    self.pageControl.numberOfPages = self.images.count;
    
    //初始化
    [self updateImageViews];
    
}

#pragma mark - 定时器
- (void)starTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage{
    
    if (self.scrollDirection == DXAutoCycleScrollViewDirectionHorizontal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.bounds.size.width, 0) animated:YES];
    } else if (self.scrollDirection == DXAutoCycleScrollViewDirectionVertical) {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + self.bounds.size.height) animated:YES];
    }
}

#pragma mark - 重写方法
- (void)setImages:(NSArray *)images{
    _images = images;
}

- (void)setScrollDirection:(DXAutoCycleScrollViewDirection)scrollDirection{
    _scrollDirection = scrollDirection;
}

- (void)setPageImage:(UIImage *)pageImage{
    _pageImage = pageImage;
    [self.pageControl setValue:self.pageImage forKeyPath:@"_pageImage"];
}

- (void)setCurrentPageImage:(UIImage *)currentPageImage{
    _currentPageImage = currentPageImage;
    [self.pageControl setValue:self.currentPageImage forKeyPath:@"_currentPageImage"];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取当前显示图片的imageView
    CGFloat minDelta = MAXFLOAT;
    UIImageView *destImageView = nil;
    for (NSInteger i = 0; i< 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        CGFloat delta = 0;
        if (self.scrollDirection == DXAutoCycleScrollViewDirectionHorizontal) {
            delta = ABS(self.scrollView.contentOffset.x - imageView.frame.origin.x);
        } else if (self.scrollDirection == DXAutoCycleScrollViewDirectionVertical) {
            delta = ABS(self.scrollView.contentOffset.y - imageView.frame.origin.y);
        }
        
        if (delta < minDelta) {
            minDelta = delta;
            destImageView = imageView;
        }
    }
    
    //设置当前的页码(当前imageView绑定的tag)
    self.pageControl.currentPage = destImageView.tag;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateImageViews];
    [self starTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateImageViews];
}

#pragma mark - 自定义方法
- (void)updateImageViews{
    
    //当前页数
    NSInteger currentPage = self.pageControl.currentPage;
    
    //重新设置imageView显示的内容
    for (NSInteger i = 0; i < 3; i++) {
        
        UIImageView *imageView = self.scrollView.subviews[i];
        
        //图片的索引
        NSInteger index = 0;
        if (i == 0) { //左边的imageView
            index = currentPage - 1;
        } else if (i == 1){ //中间imageView
            index = currentPage;
        } else if (i == 2){ //右边imageView
            index = currentPage + 1;
        }
        
        //处理特殊情况
        if (index == -1) {
            index = self.images.count - 1;
        } else if (index == self.images.count) {
            index = 0;
        }

        imageView.image = self.images[index];
        
        //绑定图片索引
        imageView.tag = index;
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
    
    //将中间的imageView滚动到中间
    if (self.scrollDirection == DXAutoCycleScrollViewDirectionHorizontal) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    } else if (self.scrollDirection == DXAutoCycleScrollViewDirectionVertical) {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }
}

- (void)imageViewClick:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(autoCycleScrollView:didClickImageAtIndex:)]) {
        [self.delegate autoCycleScrollView:self didClickImageAtIndex:tap.view.tag];
    }
}

@end
