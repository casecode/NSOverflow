//
//  SplitContainerVC.m
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "SplitContainerVC.h"
#import "CRWStackOverflowClient.h"

@interface SplitContainerVC ()

@property (nonatomic, strong) CRWStackOverflowClient *apiClient;
@end

@implementation SplitContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UISplitViewController *splitVC = self.childViewControllers[0];
    [splitVC setDelegate:self];
    
    self.apiClient = [CRWStackOverflowClient sharedClient];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([self.apiClient isAuthenticated]) {
        return YES;
    }
    return NO;
}

@end
