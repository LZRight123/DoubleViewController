//
//  BlueViewController.m
//  DoubleViewController
//
//  Created by Right on 15/12/18.
//  Copyright © 2015年 Right. All rights reserved.
//

#import "BlueViewController.h"

@interface BlueViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BlueViewController
+ (instancetype) create {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[[self class]description]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = NO;
    self.tableView.separatorColor = [UIColor redColor   ];
    self.tableView.sectionFooterHeight = 100;
    self.tableView.estimatedRowHeight = 100;
}

#pragma mark - Table view data source
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    return view;
}
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    return view;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.numberOfLines = 0;
    if (indexPath.item%2 == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld分区-第%ld行 Override to support conditional editing of the table view.",indexPath.section,indexPath.item];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld分区-第%ld行 Override to support conditional editing of th Override to support conditional editing of the table view Override to support conditional editing of the table view Override to support conditional editing of the table viewe table view.",indexPath.section,indexPath.item];
    }
    
    
    return cell;
}

@end
