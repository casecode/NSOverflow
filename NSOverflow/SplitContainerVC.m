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

@end

@implementation SplitContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UISplitViewController *splitVC = self.childViewControllers[0];
    [splitVC setDelegate:self];
    
    NSLog(@"HELLO");
    
    CRWStackOverflowClient *service = [[CRWStackOverflowClient alloc] init];
    [service fetchObjectsAtPath:@"users" withParams:nil completion:^(NSData *data, NSString *errorMessage) {
        NSLog(@"Error: %@", errorMessage);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

@end
