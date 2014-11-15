//
//  CRWStackOverflowClient_Private.h
//  NSOverflow
//
//  Created by Casey R White on 11/15/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRWStackOverflowClient (Private)

- (NSMutableArray *)parseQuestionsFromJSON:(NSData *)questionData error:(NSError **)error;

@end