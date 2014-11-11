//
//  CCStackExchangeService.m
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "CCStackExchangeService.h"

@interface CCStackExchangeService ()

@property (nonatomic, strong) NSString * const apiBaseURL;
@property (nonatomic, strong) NSString * const apiKey;

@end


@implementation CCStackExchangeService

- (instancetype)init {
    if (self = [super init]) {
        self.apiBaseURL = @"https://stackexchange.com/";
        self.apiKey = @"eecC8QAViP40PkTd16RXrQ((";
    }

    return self;
}

- (void)fetchObjectsAtPath:(NSString *)path withParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSString *))callback {
    
    NSMutableString *builtURL = [[NSMutableString alloc] initWithString:self.apiBaseURL];
    
    if (path != nil) {
        [builtURL appendString:path];
    }
    
    NSLog(@"%@", builtURL);
    
    
    callback(nil, @"Was there an error?");
}

@end
