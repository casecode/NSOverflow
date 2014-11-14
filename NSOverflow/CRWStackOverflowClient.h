//
//  CRWStackOverflowClient.h
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRWStackOverflowClient : NSObject

+ (id)sharedClient;

- (BOOL)isAuthenticated;

- (NSURL *)oAuthRequestURL;

- (void)fetchQuestionsWithTag:(NSString *)tag completion:(void (^)(NSArray *questions, NSError *error))completion;

@end
