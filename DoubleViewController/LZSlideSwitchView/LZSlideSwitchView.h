//
//  LZSlideSwitchView.h
//  LZSliderSwitchView
//
//  Created by 梁泽 on 15/11/23.
//  Copyright © 2015年 right. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZSlideSwitchView;

@protocol LZSlideSwitchViewDataSource <NSObject>
@required
/// 顶部tab个数
- (NSUInteger)numberOfTab:(LZSlideSwitchView *)view;
/// 每个tab所属的viewController
- (UIViewController *)slideSwitchView:(LZSlideSwitchView *)view viewOfTab:(NSUInteger)number;
@end

@protocol LZSlideSwitchViewDelegate <NSObject>
@optional
/// 滑动左边界时传递手势
- (void)slideSwitchView:(LZSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer*) panParam;

/// 滑动右边界时传递手势
- (void)slideSwitchView:(LZSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam;

/// 点击tabitem
- (void)slideSwitchView:(LZSlideSwitchView *)view didselectTab:(NSUInteger)number;
@end
@interface LZSlideSwitchView : UIView
@property (nonatomic,weak) IBOutlet id<LZSlideSwitchViewDataSource> dataSource;
@property (nonatomic,weak) IBOutlet id<LZSlideSwitchViewDelegate> delegate;
/// 滚动条背景图
@property (nonatomic,strong) UIImageView *shadowImageView;
/// 右侧按钮
@property (nonatomic,strong) UIButton *rightBtn;
/// 是否搞分割线
@property (nonatomic,assign) BOOL isNeedLine;
@property (nonatomic,strong) UIColor *tabItemNormalColor;
@property (nonatomic,strong) UIColor *tabItemSelectedColor;
@property (nonatomic,strong) UIImage *tabItemNormalBackgroundImage;
@property (nonatomic,strong) UIImage *tabItemSelectedBackgroundImage;

/// 显示第几个
- (void) showViewAtIndex:(NSInteger)index;


@end
















