//
//  ProfileVC.m
//  NSOverflow
//
//  Created by Casey R White on 11/16/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "ProfileVC.h"
#import "CRWUser.h"
#import "CRWStackOverflowClient.h"
#import "CRWNSOverflowError.h"

@interface ProfileVC ()

@property CRWStackOverflowClient *apiClient;
@property (strong, nonatomic) CRWUser *user;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLabel;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ProfileVC

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    return _dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"My Profile", @"Profile of the authenticated user");
    [self hideLabels];
    
    if (_user) {
        [self configureProfileViews];
    }
    else {
    self.apiClient = [CRWStackOverflowClient sharedClient];
        [_apiClient fetchAuthenticatedUser:^(CRWUser *user, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
            else {
                self.user = user;
                [self configureProfileViews];
            }
        }];
    }
}

- (void)configureProfileViews {
    self.userNameLabel.text = self.user.displayName;
    self.creationDateLabel.text = [[self dateFormatter] stringFromDate:self.user.dateCreated];
    [self showLabels];
    if (_user.profileImage) {
        self.userImageView.image = _user.profileImage;
    }
    else {
        [self fetchUserImage:^(UIImage *image, NSError *error) {
            _user.profileImage = image;
            self.userImageView.image = image;
        }];
    }
}

- (void)fetchUserImage:(void (^)(UIImage *image, NSError *error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *imageURL = [NSURL URLWithString:self.user.imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        UIImage *image = nil;
        NSError *error = nil;
        
        if (imageData.length > 0) {
            image = [UIImage imageWithData:imageData];
        }
        else {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Error fetching user image"};
            error = [CRWNSOverflowError fetchErrorWithUserInfo:userInfo];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image, error);
        });
    });
}

- (void)hideLabels {
    self.userNameLabel.hidden = YES;
    self.memberSinceLabel.hidden = YES;
    self.creationDateLabel.hidden = YES;
}

- (void)showLabels {
    self.userNameLabel.hidden = NO;
    self.memberSinceLabel.hidden = NO;
    self.creationDateLabel.hidden = NO;
}

@end
