//
//  ViewController.m
//  DoubleViewController
//
//  Created by Right on 15/12/18.
//  Copyright © 2015年 Right. All rights reserved.
//

#import "ViewController.h"
#import "RedViewController.h"
#import "BlueViewController.h"
#import "FistSliderVCDelegate.h"
@interface ViewController ()
@property (strong, nonatomic) RedViewController *redVC;
@property (strong, nonatomic) RedViewController *redVC2;
@property (strong, nonatomic) BlueViewController *blueVC;
@end

@implementation ViewController
- (RedViewController *)redVC {
    if (!_redVC) {
        _redVC = [RedViewController createWithDelegateObject:[[FistSliderVCDelegate alloc]initWithNum:5]];
    }
    return _redVC;
}
- (RedViewController *)redVC2 {
    if (!_redVC2) {
        _redVC2 = [RedViewController create];
        
    }
    return _redVC2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.redVC.view];
    [self.view addSubview:self.redVC2.view];
    [self.redVC showViewAtIndex:2];
    [self showTitleAtIndex:0];
}

- (IBAction)valuechange:(UISegmentedControl *)sender {
    [self showTitleAtIndex:sender.selectedSegmentIndex];
}
- (void) showTitleAtIndex :(NSInteger) index {
    switch (index) {
        case 0:
            [self.view bringSubviewToFront:self.redVC.view];
            break;
            
        default:
            [self.view bringSubviewToFront:self.redVC2.view];
            break;
    }
}
@end
