//
//  RedViewController.h
//  DoubleViewController
//
//  Created by Right on 15/12/18.
//  Copyright © 2015年 Right. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedViewController : UIViewController
+ (instancetype) create;
+ (instancetype) createWithSubNum:(NSInteger)subNum;
+ (instancetype) createWithDelegateObject:(id)obj;

- (void) showViewAtIndex:(NSInteger)index;
@end
