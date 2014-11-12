//
//  CRWStackOverflowClient.m
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "CRWStackOverflowClient.h"
#import "CRWConstants.h"
#import "CRWQuestion.h"

static NSString * const API_BASE_URL = @"https://api.stackexchange.com/2.2";
static NSString * const API_KEY = @"eecC8QAViP40PkTd16RXrQ((";

@interface CRWStackOverflowClient ()

- (void)fetchObjectsAtURL:(NSString *)url completion:(void (^)(NSData *data, NSError *error))completion;

@end


@implementation CRWStackOverflowClient

+ (id)sharedClient {
    static CRWStackOverflowClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CRWStackOverflowClient alloc] init];
    });
    
    return _sharedClient;
}

- (void)fetchQuestionsWithTag:(NSString *)tag completion:(void (^)(NSArray *, NSError *))completion {
    
    NSString *resourcePath = @"/questions";
    NSString *params = [NSString stringWithFormat:@"?order=desc&tagged=%@&site=stackoverflow&key=%@", tag, API_KEY];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", API_BASE_URL, resourcePath, params];
    
    [self fetchObjectsAtURL:url completion:^(NSData *data, NSError *error) {
        NSError *fetchError = nil;
        NSMutableArray *questions = nil;
        
        if (error) {
            fetchError = error;
        }
        else {
            id objs = [NSJSONSerialization JSONObjectWithData:data options:0 error:&fetchError];
            
            if (!fetchError) {
                questions = [NSMutableArray array];
                
                if ([objs isKindOfClass:[NSDictionary class]]) {
                    NSArray *items = [(NSDictionary *)objs objectForKey:@"items"];
                    
                    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            CRWQuestion *question = [CRWQuestion questionFromDictionary:(NSDictionary *)obj];
                            [questions addObject:question];
                        }
                    }];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(questions, fetchError);
        });
    }];
}

- (void)fetchObjectsAtURL:(NSString *)url completion:(void (^)(NSData *, NSError *))completion {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSError *fetchError = nil;
        NSData *fetchData = nil;
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            fetchError = error;
        }
        else {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode >= 400) {
                    NSDictionary *userInfo = @{
                        @"statusCode": @(httpResponse.statusCode),
                        @"error": [error localizedDescription]
                    };
                    
                    fetchError = [NSError errorWithDomain:NSOVERFLOW_DOMAIN code:0 userInfo:userInfo];
                }
                else {
                    fetchData = data;
                }
            }
        }
        
        completion(fetchData, fetchError);
        
    }];
    
    [task resume];
}

@end
