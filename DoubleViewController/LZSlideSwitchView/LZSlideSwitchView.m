//
//  LZSlideSwitchView.m
//  LZSliderSwitchView
//
//  Created by 梁泽 on 15/11/23.
//  Copyright © 2015年 right. All rights reserved.
//

#import "LZSlideSwitchView.h"
@interface LZSlideSwitchView()<UIScrollViewDelegate>
/// 顶部滚动视图
@property (nonatomic,strong) UIScrollView *topScrollView;
/// 主滚动视图
@property (nonatomic,strong) UIScrollView *rootScrollView;
/// 视图集合
@property (nonatomic,strong) NSMutableArray *viewArray;
/// 按钮集合
@property (nonatomic,strong) NSMutableArray *btns;
/// 分割线
@property (nonatomic,strong) NSMutableArray *lines;
/// 选中按钮的下标
@property (nonatomic,assign) NSInteger selectedBtnTag;
/// 是否滑动rootScroller
@property (nonatomic,assign) BOOL isRootScroll;
/// 记录rootScorller的contentoffset.x
@property (nonatomic,assign) CGFloat rootScrollContentOffsetX;
/// 看rootScorller是左滑还是右滑
@property (nonatomic,assign) BOOL isLeftScroll;
/// 是否对子视图进行布局
@property (nonatomic,assign) BOOL isLayoutForSubViews;
@end
//====================customParameter==================
/// 顶部视图高
static const CGFloat kHeightOfTopScrollView = 44.0f;
/// 按钮宽之间的间隙
static const CGFloat kWidthOfButtonMargin = 16.0f;
/// 按钮文字的大小
static const CGFloat kFontSizeOfTabButton = 17.0f;
/// 按钮下指示条显示高度  可以扩展成图片
static const CGFloat kShadowImageViewHeight = 1.0f;
/// 分割线到顶部的距离
static const CGFloat kLinePaddingForTop = 8.0f;
/// 分割线颜色
#define kLineColor [UIColor colorWithRed:212/255.0 green:213/255.0 blue:214/255.0 alpha:1]
//=====================================================
@implementation LZSlideSwitchView
/// 显示第几个
- (void) showViewAtIndex:(NSInteger)index{
    UIButton *btn = self.btns[index];
    [self selectNameButton:btn];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:self.topScrollView];
        [self addSubview:self.rootScrollView];
        self.isLayoutForSubViews = NO;
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame  {
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.topScrollView];
        [self addSubview:self.rootScrollView];
        self.isLayoutForSubViews = NO;
    }
    return self;
}

#pragma mark 数据源方法:
- (void) setDataSource:(id<LZSlideSwitchViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self reloadUI];
}

- (void) reloadUI{
    NSUInteger number = [self.dataSource numberOfTab:self];
    for (int i=0 ; i<number ; i++) {
        UIViewController *vc = [self.dataSource slideSwitchView:self viewOfTab:i];
        [self.viewArray addObject:vc];
        [self.rootScrollView addSubview:vc.view];
    }
    
    [self setupTopBtns];
    
    self.isLayoutForSubViews = YES;
    [self setNeedsDisplay];
}
- (void) setupTopBtns {
    //顶部tabbar的总长度  起始的 X坐标
    __block CGFloat topScrollViewContentWidth = kWidthOfButtonMargin;
    
    [self.viewArray enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     
        //按钮文字的宽
        CGFloat textWidth = [vc.title boundingRectWithSize:CGSizeMake(MAXFLOAT, kHeightOfTopScrollView) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kFontSizeOfTabButton]} context:nil].size.width;
        //累计每个tab文字的长度
        topScrollViewContentWidth += kWidthOfButtonMargin+textWidth;
        
        CGFloat btnX = kWidthOfButtonMargin + idx*(kWidthOfButtonMargin + textWidth);
        button.frame = CGRectMake(btnX, 0,textWidth, kHeightOfTopScrollView);
        button.tag = idx + 100;
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSizeOfTabButton];
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button setTitleColor:self.tabItemNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.tabItemSelectedColor forState:UIControlStateSelected];
        [button setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor redColor];
        [button setBackgroundImage:self.tabItemSelectedBackgroundImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topScrollView addSubview:button];
        [self.btns addObject:button];
        //分割线
        if (self.isNeedLine && idx < self.viewArray.count - 1) {
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = kLineColor;
            line.frame = CGRectMake(CGRectGetMaxX(button.frame)+kWidthOfButtonMargin*.5, kLinePaddingForTop,0.5, kHeightOfTopScrollView-2*kLinePaddingForTop);
            [self.lines addObject:line];
            [self.topScrollView addSubview:line];
        }
        
        if (idx == 0) {
            self.shadowImageView.frame = CGRectMake(CGRectGetMinX(button.frame), kHeightOfTopScrollView -kShadowImageViewHeight,CGRectGetWidth(button.frame),kShadowImageViewHeight);
            button.selected = YES;
            self.selectedBtnTag = button.tag;
        }
    }];
    if(self.topScrollView.contentSize.width < self.topScrollView.bounds.size.width){
        self.topScrollView.contentSize = CGSizeMake( self.topScrollView.bounds.size.width, kHeightOfTopScrollView);
        
        CGFloat padding = 5;
        CGFloat width = self.topScrollView.bounds.size.width /self.btns.count;
        [self.btns enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * stop) {
            CGFloat x = padding + idx*width;
            button.frame = CGRectMake(x,0,width, kHeightOfTopScrollView);
            
            if (idx == 0) {
                self.shadowImageView.frame = CGRectMake(CGRectGetMinX(button.frame), kHeightOfTopScrollView -kShadowImageViewHeight,CGRectGetWidth(button.frame),kShadowImageViewHeight);
                button.selected = YES;
                self.selectedBtnTag = button.tag;
            }
        }];
      
    }
    //设置顶部滚动视图的内容总尺寸
    self.topScrollView.contentSize = CGSizeMake(topScrollViewContentWidth, kHeightOfTopScrollView);
    // 如果滚动视图的内容尺寸没有自身视图的话
    if(self.topScrollView.contentSize.width < self.bounds.size.width - self.rightBtn.frame.size.width){
        
    }
}

#pragma mark - 顶部滚动视图逻辑方法
/// 按钮点击
- (void)selectNameButton:(UIButton *)sender{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使用使tab文字显示全
    [self adjustScrollViewContentX:sender];
    
    //如果更换按钮
    if (sender.tag != self.selectedBtnTag){
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self.topScrollView viewWithTag:self.selectedBtnTag];
        lastButton.selected = NO;
        //赋值按钮ID
        self.selectedBtnTag = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.1 animations:^{
//            CGFloat textWidth = [sender.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, kHeightOfTopScrollView) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kFontSizeOfTabButton]} context:nil].size.width;
            self.shadowImageView.frame = CGRectMake(CGRectGetMinX(sender.frame), kHeightOfTopScrollView -kShadowImageViewHeight,CGRectGetWidth(sender.frame),kShadowImageViewHeight);
        } completion:^(BOOL finished) {
            if (finished) {
                //设置新页出现
                if (!self.isRootScroll) {
                    [self.rootScrollView setContentOffset:CGPointMake((sender.tag - 100)*self.bounds.size.width, 0) animated:YES];
                }
                self.isRootScroll = NO;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
                    [self.delegate slideSwitchView:self didselectTab:_selectedBtnTag - 100];
                }
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        
    }

}

/// 调整顶部滚动视图x位置
- (void)adjustScrollViewContentX:(UIButton *)sender
{
    if(self.topScrollView.contentSize.width <= self.topScrollView.bounds.size.width){
        return;
    }
    //如果 当前显示的最后一个tab文字超出右边界
    if (CGRectGetMaxX(sender.frame) + kWidthOfButtonMargin -self.topScrollView.contentOffset.x > self.topScrollView.bounds.size.width) {
        //向左滚动视图，显示完整tab文字
        [self.topScrollView setContentOffset:CGPointMake(CGRectGetMaxX(sender.frame) + kWidthOfButtonMargin - self.topScrollView.bounds.size.width, 0)  animated:YES];
    }
    
    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    if (sender.frame.origin.x - self.topScrollView.contentOffset.x < kWidthOfButtonMargin) {
        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
        [self.topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - kWidthOfButtonMargin, 0)  animated:YES];
    }
}
#pragma mark 主视图逻辑方法

//滚动视图开始时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.rootScrollView) {
        self.rootScrollContentOffsetX = scrollView.contentOffset.x;
    }
}

//滚动视图结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.rootScrollView) {
        //判断用户是否左滚动还是右滚动
        if (self.rootScrollContentOffsetX < scrollView.contentOffset.x) {
            self.isLeftScroll = YES;
        }
        else {
            self.isLeftScroll = NO;
        }
    }
}

//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.rootScrollView) {
        self.isRootScroll = YES;
        //调整顶部滑条按钮状态
        int tag = (int)scrollView.contentOffset.x/self.bounds.size.width +100;
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:tag];
        [self selectNameButton:button];
    }
}

//传递滑动事件给下一层
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    //当滑道左边界时，传递滑动事件给代理
    if(self.rootScrollView.contentOffset.x <= 0) {
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(slideSwitchView:panLeftEdge:)]) {
            [self.delegate slideSwitchView:self panLeftEdge:panParam];
        }
    } else if(self.rootScrollView.contentOffset.x >= _rootScrollView.contentSize.width - _rootScrollView.bounds.size.width) {
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(slideSwitchView:panRightEdge:)]) {
            [self.delegate slideSwitchView:self panRightEdge:panParam];
        }
    }
}



#pragma mark - 视图元素
- (UIScrollView *) topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeightOfTopScrollView)];
        _topScrollView.backgroundColor = [UIColor whiteColor];
        _topScrollView.delegate = self;
        _topScrollView.pagingEnabled = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_topScrollView addSubview:self.shadowImageView];
    }
    return _topScrollView;
}
- (UIImageView *) shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc]init];
    }
    return _shadowImageView;
}
- (UIScrollView *) rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kHeightOfTopScrollView, self.bounds.size.width, self.bounds.size.height - kHeightOfTopScrollView)];
        _rootScrollView.delegate = self;
        _rootScrollView.pagingEnabled = YES;
        _rootScrollView.bounces = NO;
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.showsVerticalScrollIndicator = NO;
        _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [_rootScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
        self.rootScrollContentOffsetX = 0;
    }
    return _rootScrollView;
}

- (NSMutableArray *) viewArray {
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

- (NSMutableArray*)btns {
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}
- (NSMutableArray*) lines{
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
#pragma mark - 布局
- (void)layoutSubviews
{
    //创建完子视图UI才需要调整布局
    if (self.isLayoutForSubViews) {
        //如果有设置右侧视图，缩小顶部滚动视图的宽度以适应按钮
        if (self.rightBtn.bounds.size.width > 0) {
            self.rightBtn.frame = CGRectMake(self.bounds.size.width - self.rightBtn.bounds.size.width, 0,
                                                self.rightBtn.bounds.size.width, kHeightOfTopScrollView);
            
            self.topScrollView.frame = CGRectMake(0, 0,
                                              self.bounds.size.width - self.rightBtn.bounds.size.width, kHeightOfTopScrollView);
        }
        
        if(self.topScrollView.contentSize.width < self.topScrollView.bounds.size.width){
            self.topScrollView.contentSize = CGSizeMake( self.topScrollView.bounds.size.width, kHeightOfTopScrollView);
            
            CGFloat padding = 5;
            CGFloat width = self.topScrollView.bounds.size.width /self.btns.count;
            [self.btns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * stop) {
                CGFloat x = padding + idx*width;
                obj.frame = CGRectMake(x,0,width, kHeightOfTopScrollView);

                //分割线
                if (self.isNeedLine && idx < self.btns.count-1) {
                    UIView *line = self.lines[idx];
                    line.frame = CGRectMake(CGRectGetMaxX(obj.frame), kLinePaddingForTop, 0.5,kHeightOfTopScrollView-2*kLinePaddingForTop);
                }
            }];
        }

        
        
        
        //更新主视图的总宽度
        self.rootScrollView.contentSize = CGSizeMake(self.bounds.size.width * [self.viewArray count], self.rootScrollView.contentSize.height);
        
        //更新主视图各个子视图的宽度
        for (int i = 0; i < [self.viewArray count]; i++) {
            UIViewController *listVC = self.viewArray[i];
            listVC.view.frame = CGRectMake(0+self.rootScrollView.bounds.size.width*i, 0,
                                           self.rootScrollView.bounds.size.width, self.rootScrollView.bounds.size.height);
            NSLog(@"%@",NSStringFromCGRect(listVC.view.frame));
        }
        
        //滚动到选中的视图
        [self.rootScrollView setContentOffset:CGPointMake((self.selectedBtnTag - 100)*self.bounds.size.width, 0) animated:NO];
        
        //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[self.topScrollView viewWithTag:self.selectedBtnTag];
        [self adjustScrollViewContentX:button];
    }
}
#pragma mark - set方法
- (void) setRightBtn:(UIButton *)rightBtn{
    _rightBtn = rightBtn;
    [self addSubview:rightBtn];
}
- (void) setIsNeedLine:(BOOL)isNeedLine{
    _isNeedLine = isNeedLine;
    if (isNeedLine) {
        [self.lines removeAllObjects];
        for (int i = 0; i<self.btns.count; ++i) {
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = kLineColor;
            [self.lines addObject:line];
            [self.topScrollView addSubview:line];
        }
    }
}
- (void) setTabItemNormalColor:(UIColor *)tabItemNormalColor{
    _tabItemNormalColor = tabItemNormalColor;
    [self.btns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:tabItemNormalColor forState:UIControlStateNormal];
    }];
}
- (void) setTabItemSelectedColor:(UIColor *)tabItemSelectedColor{
    _tabItemSelectedColor = tabItemSelectedColor;
    [self.btns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:tabItemSelectedColor forState:UIControlStateSelected];
    }];
}

@end














