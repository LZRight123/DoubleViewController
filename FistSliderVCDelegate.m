//
//  FistSliderVCDelegate.m
//  DoubleViewController
//
//  Created by Right on 15/12/18.
//  Copyright © 2015年 Right. All rights reserved.
//

#import "FistSliderVCDelegate.h"
#import "LZSlideSwitchView.h"
#import "BlueViewController.h"
@interface FistSliderVCDelegate()
@property (assign, nonatomic) NSInteger numOfTab;
@end
@implementation FistSliderVCDelegate
- (instancetype) initWithNum:(NSInteger)num{
    self = [super init];
    self.numOfTab = num;
    return self;
}
- (NSArray *) titleArray {
    return @[@"全部",@"待付款",@"待消费",@"待发货",@"退款"];
}
- (NSUInteger)numberOfTab:(LZSlideSwitchView *)view{
    return [[self titleArray] count];
}
- (UIViewController*) slideSwitchView:(LZSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    BlueViewController *vc = [BlueViewController create];
    
    vc.title = [[self titleArray] objectAtIndex:number];

    return vc   ;
}
@end
