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
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, copy) NSDate *dateCreated;

@end

@implementation CRWUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.userID = [[dictionary objectForKey:@"user_id"] unsignedIntegerValue];
        self.displayName = [dictionary objectForKey:@"display_name"];
        self.imageURL = [dictionary objectForKey:@"profile_image"];
        
        NSTimeInterval interval = [[dictionary objectForKey:@"creation_date"] integerValue];
        self.dateCreated = [NSDate dateWithTimeIntervalSince1970:interval];
    }
    
    return self;
}
    
@end
