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

/*
 *** NOTE:
 The LoginVC uses a custom bitmask along with KVC and KVO for showing/hiding views.
 The example here is silly and contrived, and the sole purpose was to learn/practice these concepts.
*/

typedef NS_OPTIONS(NSUInteger, LoginDisplayItem) {
    LoginDisplayItemNone        = 0,
    LoginMessageItem            = 1 << 0,
    LoginButtonItem             = 1 << 1,
    AuthenticatedMessageItem    = 1 << 2
};

static int kAuthenticationContext;

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *loginMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *authenticatedMessageLabel;

@property (nonatomic, assign) LoginDisplayItem displayBitmask;

@property (strong, nonatomic) CRWStackOverflowClient *apiClient;

@end

@implementation LoginVC

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"displayBitmask" context:&kAuthenticationContext];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.apiClient = [CRWStackOverflowClient sharedClient];
    
    [self addObserver:self forKeyPath:@"displayBitmask" options:NSKeyValueObservingOptionNew context:&kAuthenticationContext];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([_apiClient isAuthenticated]) {
        LoginDisplayItem items = AuthenticatedMessageItem;
        [self setValue:[NSNumber numberWithInteger:items] forKey:@"displayBitmask"];
    } else {
        LoginDisplayItem items = (LoginMessageItem |
                                  LoginButtonItem);
        [self setValue:[NSNumber numberWithInteger:items] forKey:@"displayBitmask"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kAuthenticationContext) {
        if ([keyPath isEqualToString:@"displayBitmask"]) {
            [self updateDisplayItems];
        }
        else {
            NSLog(@"Unknown key being observed in Authentication Context");
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updateDisplayItems {

    LoginDisplayItem loginMessageItem = LoginMessageItem;
    if (loginMessageItem & _displayBitmask) {
        self.loginMessageLabel.hidden = NO;
    }
    else {
        self.loginMessageLabel.hidden = YES;
    }
    
    LoginDisplayItem loginButtonItem = LoginButtonItem;
    if (loginButtonItem & _displayBitmask) {
        self.loginButton.hidden = NO;
    }
    else {
        self.loginButton.hidden = YES;
    }
    
    LoginDisplayItem authenticatedMessageItem = AuthenticatedMessageItem;
    if (authenticatedMessageItem & _displayBitmask) {
        self.authenticatedMessageLabel.hidden = NO;
    }
    else {
        self.authenticatedMessageLabel.hidden = YES;
    }
}

- (IBAction)loginPressed:(id)sender {
    OAuthVC *oAuthVC = [[OAuthVC alloc] initWithURL:[_apiClient oAuthRequestURL]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:oAuthVC];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
