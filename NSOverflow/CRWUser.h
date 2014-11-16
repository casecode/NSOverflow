//
//  CRWUser.h
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CRWUser : NSObject

@property (nonatomic, readonly, assign) NSUInteger userID;
@property (nonatomic, readonly, strong) NSString *displayName;
@property (nonatomic, readonly, strong) NSString *imageURL;
@property (nonatomic, readonly, copy) NSDate *dateCreated;
@property (nonatomic, strong) UIImage *profileImage;

- (instancetype)initWithDictionary:(NSDictionary *)data;

@end
