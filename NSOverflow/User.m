//
//  User.m
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init:(NSDictionary *)data {
    if (self = [super init]) {
        self.userID = data[@"user_id"];
    }
    
    return self;
}
    
@end
