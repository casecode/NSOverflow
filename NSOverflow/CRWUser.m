//
//  CRWUser.m
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "CRWUser.h"

@interface CRWUser ()

@property (nonatomic, assign) NSUInteger userID;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSDictionary *badgeCounts;

@end

@implementation CRWUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.userID = [[dictionary objectForKey:@"user_id"] unsignedIntegerValue];
        self.displayName = [dictionary objectForKey:@"diplay_name"];
        self.location = [dictionary objectForKey:@"location"];
        self.badgeCounts = [dictionary objectForKey:@"badge_counts"];
    }
    
    return self;
}
    
@end
