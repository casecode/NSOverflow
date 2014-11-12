//
//  CRWUser.h
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRWUser : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, strong) NSDictionary *badgeCounts;

- (instancetype)initWithDictionary:(NSDictionary *)data;

@end
