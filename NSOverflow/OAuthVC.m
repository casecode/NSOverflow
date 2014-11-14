//
//  OAuthVC.m
//  NSOverflow
//
//  Created by Casey R White on 11/12/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "OAuthVC.h"
#import "CRWStackOverflowClient.h"
#import <WebKit/WebKit.h>

@interface OAuthVC () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *url;

@end

@implementation OAuthVC

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
    self.webView.navigationDelegate = self;
    
    if ([self navigationController]) {
        self.title = @"Login";
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

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSString *targetURL = webView.URL.absoluteString;
    if (([targetURL rangeOfString:@"login_success"].location != NSNotFound) &&
        ([targetURL rangeOfString:@"expires"].location != NSNotFound)) {
        
        NSString *paramsString = [[targetURL componentsSeparatedByString:@"#"] lastObject];
        NSArray *params = [paramsString componentsSeparatedByString:@"&"];
        NSString *token = [[[params firstObject] componentsSeparatedByString:@"="] lastObject];
        
        if (token) {
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
