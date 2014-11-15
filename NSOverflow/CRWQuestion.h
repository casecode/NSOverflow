//
//  CRWQuestion.h
//  NSOverflow
//
//  Created by Casey R White on 11/11/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRWQuestion : NSObject

@property (nonatomic, readonly, assign) NSUInteger questionID;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *link;
@property (nonatomic, readonly, copy) NSArray *tags;
@property (nonatomic, readonly, copy) NSDate *dateCreated;

@property (nonatomic, readonly, copy) NSString *ownerName;
@property (nonatomic, readonly, copy) NSString *ownerID;

+ (CRWQuestion *)questionFromDictionary:(NSDictionary *)dictionary;

@end
