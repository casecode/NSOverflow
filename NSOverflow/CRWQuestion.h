//
//  CRWQuestion.h
//  NSOverflow
//
//  Created by Casey R White on 11/11/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRWQuestion : NSObject

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *link;

+ (CRWQuestion *)questionFromDictionary:(NSDictionary *)dictionary;

@end
