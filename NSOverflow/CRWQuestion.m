//
//  CRWQuestion.m
//  NSOverflow
//
//  Created by Casey R White on 11/11/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "CRWQuestion.h"

@interface CRWQuestion ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;

@end

@implementation CRWQuestion

+ (CRWQuestion *)questionFromDictionary:(NSDictionary *)dictionary {
        
    CRWQuestion *question = [[self alloc] init];
    
    question.title = [dictionary objectForKey:@"title"];
    question.link = [dictionary objectForKey:@"link"];
    
    return question;
}

@end
