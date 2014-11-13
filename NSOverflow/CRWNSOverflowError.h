//
//  CRWNSOverflowError.h
//  NSOverflow
//
//  Created by Casey R White on 11/12/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRWNSOverflowError : NSObject

+ (NSError *)fetchErrorWithUserInfo:(NSDictionary *)userInfo;

+ (NSError *)parseErrorWithUserInfo:(NSDictionary *)userInfo;

@end
