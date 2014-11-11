//
//  User.m
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "CCUser.h"

@implementation CCUser

- (instancetype)init:(NSDictionary *)data {
    if (self = [super init]) {
        self.userID = data[@"user_id"];
    }
    
    return self;
}
    
@end
