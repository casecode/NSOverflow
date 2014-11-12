//
//  CRWUser.m
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "CRWUser.h"

@implementation CRWUser

- (instancetype)initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        self.userID = (NSNumber *)data[@"user_id"];
        self.displayName = (NSString *)data[@""];
        self.location = (NSString *)data[@"location"];
        self.profileImageURL = (NSString *)data[@"profile_image"];
        
        NSDictionary *badgeDict = (NSDictionary *)data[@"badge_counts"];
        self.badgeCounts = @{
             @"bronze" : (NSNumber *)badgeDict[@"bronze"],
             @"silver" : (NSNumber *)badgeDict[@"silver"],
             @"gold"   : (NSNumber *)badgeDict[@"gold"]
        };
    }
    
    return self;
}
    
@end
