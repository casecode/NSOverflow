//
//  CRWStackOverflowClient.h
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRWStackOverflowClient : NSObject

- (void)fetchObjectsAtPath:(NSString *)path withParams:(NSDictionary *)params completion:(void (^)(NSData *data, NSString *errorMessage))callback;

@end
