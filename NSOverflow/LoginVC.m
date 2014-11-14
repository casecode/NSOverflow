//
//  LoginVC.m
//  NSOverflow
//
//  Created by Casey R White on 11/13/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "LoginVC.h"
#import "CRWStackOverflowClient.h"
#import "OAuthVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) CRWStackOverflowClient *apiClient;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.apiClient = [CRWStackOverflowClient sharedClient];
}

- (IBAction)loginPressed:(id)sender {
    OAuthVC *oAuthVC = [[OAuthVC alloc] initWithURL:[_apiClient oAuthRequestURL]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:oAuthVC];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
