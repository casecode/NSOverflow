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
#import "QuestionsSearchVC.h"
#import "CRWStackOverflowClient.h"
#import "LoginVC.h"

@interface MenuTableVC ()

@property CRWStackOverflowClient *apiClient;
@property (nonatomic, copy) NSArray *menuItems;

@end

@implementation MenuTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *menuCellNib = [UINib nibWithNibName:kReIDMenuCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:menuCellNib forCellReuseIdentifier:kReIDMenuCell];
    
    NSDictionary *searchQuestionsItem = @{@"title": NSLocalizedString(@"Search Questions", nil),
                                          @"reuseID": kReIDQuestionsSearchVC};
    NSDictionary *myProfileItem = @{@"title": NSLocalizedString(@"My Profile", nil),
                                    @"reuseID": kReIDProfileVC};
    self.menuItems = @[searchQuestionsItem, myProfileItem];
    
    self.title = NSLocalizedString(@"Menu", @"Main menu items");
    
    self.apiClient = [CRWStackOverflowClient sharedClient];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kReIDMenuCell forIndexPath:indexPath];
    NSDictionary *item = self.menuItems[indexPath.row];
    cell.menuItemLabel.text = [item objectForKey:@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_apiClient isAuthenticated]) {
        NSDictionary *item = self.menuItems[indexPath.row];
        id destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:[item objectForKey:@"reuseID"]];
        [self showDetailViewController:destinationVC sender:self];
    }
    else {
        LoginVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:kReIDLoginVC];
        [self showDetailViewController:loginVC sender:self];
    }
}

@end
