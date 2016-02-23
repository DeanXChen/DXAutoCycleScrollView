# DXAutoCycleScrollView
这是一个可以自动循环滚动的控件, 支持水平和垂直滚动方向.

##基本使用
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建autoCycleScrollView
    DXAutoCycleScrollView *autoCycleScrollView = [[DXAutoCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    [self.view addSubview:autoCycleScrollView];
    
    //传入图片数据
    autoCycleScrollView.images = @[
                                   [UIImage imageNamed:@"image0"],
                                   [UIImage imageNamed:@"image1"],
                                   [UIImage imageNamed:@"image2"],
                                   [UIImage imageNamed:@"image3"],
                                   ];
    
    //设置图片滚动方向
    autoCycleScrollView.scrollDirection = DXAutoCycleScrollViewDirectionVertical;
    
    //设置代理
    autoCycleScrollView.delegate = self;
    
}

#pragma mark - DXAutoCycleScrollViewDelegate
- (void)autoCycleScrollView:(UIView *)scrollView didClickImageAtIndex:(NSInteger)index{
    NSLog(@"%ld", index);
}
```
