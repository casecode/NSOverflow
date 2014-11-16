//
//  QuestionWebVC.m
//  NSOverflow
//
//  Created by Casey R White on 11/16/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "QuestionWebVC.h"
#import "CRWConstants.h"
#import "CRWStackOverflowClient.h"
#import <WebKit/WebKit.h>

@interface QuestionWebVC () 

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *url;

@end

@implementation QuestionWebVC

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc] init];
    self.view = self.webView;
    
    if ([self navigationController]) {
        self.title = @"StackOverflow";
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(navigateBack:)];
        self.navigationItem.leftBarButtonItem = backButton;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
}

- (IBAction)navigateBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
