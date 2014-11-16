//
//  CRWUser.h
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRWUser : NSObject

@property (nonatomic, readonly, assign) NSUInteger userID;
@property (nonatomic, readonly, strong) NSString *displayName;
@property (nonatomic, readonly, strong) NSString *location;
@property (nonatomic, readonly, strong) NSDictionary *badgeCounts;

- (instancetype)initWithDictionary:(NSDictionary *)data;

@end
