//
//  CRWQuestion.m
//  NSOverflow
//
//  Created by Casey R White on 11/11/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "CRWQuestion.h"

@interface CRWQuestion ()

@property (nonatomic, assign) NSUInteger questionID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSDate *dateCreated;

@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, assign) NSUInteger ownerID;

@end

@implementation CRWQuestion

+ (CRWQuestion *)questionFromDictionary:(NSDictionary *)dictionary {
        
    CRWQuestion *question = [[self alloc] init];
    
    question.questionID = [[dictionary objectForKey:@"question_id"] unsignedIntegerValue];
    question.title = [dictionary objectForKey:@"title"];
    question.link = [dictionary objectForKey:@"link"];
    question.tags = [dictionary objectForKey:@"tags"];
    
    NSTimeInterval interval = [[dictionary objectForKey:@"creation_date"] integerValue];
    question.dateCreated = [NSDate dateWithTimeIntervalSince1970:interval];
    
    question.ownerName = [dictionary valueForKeyPath:@"owner.display_name"];
    question.ownerID = [[dictionary valueForKeyPath:@"owner.user_id"] unsignedIntegerValue];
    
    return question;
}

@end
