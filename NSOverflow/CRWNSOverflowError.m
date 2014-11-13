//
//  CRWNSOverflowError.m
//  NSOverflow
//
//  Created by Casey R White on 11/12/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "CRWNSOverflowError.h"
#import "CRWConstants.h"

typedef NS_ENUM(NSInteger, NSOverflowErrorCode) {
    NSOverflowErrorCode_FetchError = -1,
    NSOverflowErrorCode_ParsingError
};

@interface CRWNSOverflowError ()

+ (NSString *)domain;

+ (NSError *)errorWithErrorCode:(NSInteger)errorCode userInfo:(NSDictionary *)userInfo;

@end

@implementation CRWNSOverflowError

+ (NSError *)fetchErrorWithUserInfo:(NSDictionary *)userInfo {
    return [self errorWithErrorCode:NSOverflowErrorCode_FetchError userInfo:userInfo];
}

+ (NSError *)parseErrorWithUserInfo:(NSDictionary *)userInfo {
    return [self errorWithErrorCode:NSOverflowErrorCode_ParsingError userInfo:userInfo];
}

+ (NSString *)domain {
    return [NSString stringWithFormat:@"%@ErrorDomain", kNSOverflowDomain];
}

+ (NSError *)errorWithErrorCode:(NSInteger)errorCode userInfo:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:[self domain] code:errorCode userInfo:userInfo];
}

@end
