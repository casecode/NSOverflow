//
//  MenuTableVC.m
//  NSOverflow
//
//  Created by Casey R White on 11/15/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "MenuTableVC.h"
#import "CRWConstants.h"
#import "MenuCell.h"

@interface MenuTableVC ()

@property (nonatomic, copy) NSArray *menuItems;

@end

@implementation MenuTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *menuCellNib = [UINib nibWithNibName:kReIDMenuCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:menuCellNib forCellReuseIdentifier:kReIDMenuCell];
    
    NSString *searchQuestionsItem = NSLocalizedString(@"Search Questions", nil);
    NSString *myProfileItem = NSLocalizedString(@"My Profile", nil);
    self.menuItems = @[searchQuestionsItem, myProfileItem];
    
    self.title = NSLocalizedString(@"Menu", @"Main menu item");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kReIDMenuCell forIndexPath:indexPath];
    cell.menuItemLabel.text = _menuItems[indexPath.row];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
