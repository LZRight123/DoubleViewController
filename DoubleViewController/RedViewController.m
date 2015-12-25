//
//  RedViewController.m
//  DoubleViewController
//
//  Created by Right on 15/12/18.
//  Copyright © 2015年 Right. All rights reserved.
//

#import "RedViewController.h"
#import "LZSlideSwitchView.h"
@interface RedViewController ()<LZSlideSwitchViewDataSource,LZSlideSwitchViewDelegate>
@property (strong, nonatomic) LZSlideSwitchView *slideSwitchView;
@property (strong, nonatomic) id delegate;
@property (assign, nonatomic) NSInteger subNum;
@end

@implementation RedViewController
- (LZSlideSwitchView*) slideSwitchView {
    if (!_slideSwitchView) {
        _slideSwitchView = [[LZSlideSwitchView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
        _slideSwitchView .isNeedLine = YES;
        _slideSwitchView .shadowImageView.backgroundColor = [UIColor redColor];
        _slideSwitchView .tabItemNormalColor = [UIColor blackColor];
        _slideSwitchView .tabItemSelectedColor = [UIColor redColor];
    }
    return _slideSwitchView;
}
+ (instancetype) createWithDelegateObject:(id)obj{
    RedViewController *redview = [self create];
    redview.delegate = obj;
    return redview;
}
+ (instancetype) createWithSubNum:(NSInteger)subNum{
    RedViewController *redview = [self create];
    redview.subNum = subNum;
    return redview;
}
+ (instancetype) create {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[[self class]description]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.delegate) {
        self.slideSwitchView.dataSource = self.delegate;
        self.slideSwitchView.delegate   = self.delegate;
    }else{
        self.slideSwitchView.dataSource = self;
        self.slideSwitchView.delegate   = self;
    }
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.slideSwitchView];
}
- (void) showViewAtIndex:(NSInteger)index{
    [self.slideSwitchView showViewAtIndex:index];
}
- (NSUInteger)numberOfTab:(LZSlideSwitchView *)view{
    return self.subNum?self.subNum:4;
}
- (UIViewController*) slideSwitchView:(LZSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    UITableViewController *vc = [[UITableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.title = [NSString stringWithFormat:@"第%ld",number];
    vc.view.backgroundColor = [UIColor colorWithRed:(random()%255)/255.0 green:(random()%255)/255.0 blue:(random()%255)/255.0 alpha:1];
    return vc   ;
}

@end
