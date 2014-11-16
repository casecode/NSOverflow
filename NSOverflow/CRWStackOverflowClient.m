//
//  CRWStackOverflowClient.m
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "CRWStackOverflowClient.h"
#import "CRWStackOverflowClient_Private.h"
#import "CRWConstants.h"
#import "CRWNSOverflowError.h"
#import "CRWQuestion.h"

static NSString * const kAPIBaseURL = @"https://api.stackexchange.com/2.2";
static NSString * const kPublicKey = @"eecC8QAViP40PkTd16RXrQ((";
static NSString * const kClientID = @"3822";
static NSString * const kOAuthURL = @"https://stackexchange.com/oauth/dialog";
static NSString * const kOAuthRedirectURI = @"https://stackexchange.com/oauth/login_success";

@interface CRWStackOverflowClient ()

@property (nonatomic, strong) NSString *token;

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

#pragma mark - Authentication

- (BOOL)isAuthenticated {
    if (self.token) { return YES; }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kSOTokenKey];
    if (token) {
        self.token = token;
        return YES;
    }
    
    return NO;
}

- (NSURL *)oAuthRequestURL {
    NSDictionary *params = @{@"client_id": kClientID,
                             @"scope": @"read_inbox",
                             @"redirect_uri": kOAuthRedirectURI};
    NSString *queryString = [self buildQueryStringWithParams:params];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kOAuthURL, queryString];
    return [NSURL URLWithString:urlString];
}


#pragma mark - Fetch Requests

- (void)fetchQuestionsWithTag:(NSString *)tag completion:(void (^)(NSArray *, NSError *))completion {
    
    NSURL *url = [self questionURLForTag:tag];
    
    [self fetchObjectsAtURL:url completion:^(NSData *data, NSError *error) {
        NSError *requestError = nil;
        NSArray *questions = nil;
        
        if (error) {
            requestError = error;
        }
        else {
            questions = [self parseQuestionsFromJSON:data error:&requestError];
        }
        
        if (requestError) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(questions, requestError);
        });
    }];
}

- (void)fetchAuthenticatedUser:(void (^)(CRWUser *, NSError *))completion {
    
    NSURL *url = [self authenticatedUserURL];
    
    [self fetchObjectsAtURL:url completion:^(NSData *data, NSError *error) {
        NSError *requestError = nil;
        CRWUser *user = nil;
        
        if (error) {
            requestError = error;
        }
        else {
            user = [self parseUserFromJSON:data error:&requestError];
        }
        
        if (requestError) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(user, requestError);
        });
    }];
}

#pragma mark - Private

- (void)fetchObjectsAtURL:(NSURL *)url completion:(void (^)(NSData *, NSError *))completion {
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSError *requestError = nil;
        NSData *fetchData = nil;
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            requestError = error;
        }
        else {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode >= 400) {
                    NSDictionary *userInfo = @{@"statusCode": @(httpResponse.statusCode),
                                               NSLocalizedDescriptionKey: @"Error fetching data"};
                    requestError = [CRWNSOverflowError fetchErrorWithUserInfo:userInfo];
                }
                else {
                    fetchData = data;
                }
            }
        }
        
        completion(fetchData, requestError);
        
    }];
    
    [task resume];
}

- (NSMutableArray *)parseQuestionsFromJSON:(NSData *)questionData error:(NSError *__autoreleasing *)error {
    NSMutableArray *questions = nil;
    id objs = [NSJSONSerialization JSONObjectWithData:questionData options:0 error:error];
    
    if (!*error) {
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
        else {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Error parsing question data"};
            *error = [CRWNSOverflowError parseErrorWithUserInfo:userInfo];
        }
    }
    
    return questions;
}

- (CRWUser *)parseUserFromJSON:(NSData *)userData error:(NSError *__autoreleasing *)error {
    CRWUser *user = nil;
    
    id jsonData = [NSJSONSerialization JSONObjectWithData:userData options:0 error:error];
    
    if (!*error) {
        if ([jsonData isKindOfClass:[NSDictionary class]]) {
            NSArray *items = [(NSDictionary *)jsonData objectForKey:@"items"];
            if ([items.firstObject isKindOfClass:[NSDictionary class]]) {
                user = [[CRWUser alloc] initWithDictionary:(NSDictionary *)items.firstObject];
            }
        }
    }
    else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Error parsing user data"};
        *error = [CRWNSOverflowError parseErrorWithUserInfo:userInfo];
    }
    
    return user;
}

- (NSString *)buildQueryStringWithParams:(NSDictionary *)params {
    
    __block NSString *queryString = [NSString stringWithFormat:@"?site=stackoverflow&key=%@", kPublicKey];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"&%@=%@", key, obj];
        queryString = [queryString stringByAppendingString:param];
    }];
    
    if (self.token) {
        NSString *tokenParam = [NSString stringWithFormat:@"&access_token=%@", self.token];
        queryString = [queryString stringByAppendingString:tokenParam];
    }
    
    return queryString;
}

- (NSURL *)questionURLForTag:(NSString *)tag {
    NSString *resourcePath = @"/questions";
    NSDictionary *params = @{@"order": @"desc",
                             @"sort": @"activity",
                             @"tagged": tag};
    NSString *queryString = [self buildQueryStringWithParams:params];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", kAPIBaseURL, resourcePath, queryString];

    return [NSURL URLWithString:urlString];
}

- (NSURL *)authenticatedUserURL {
    NSString *resourcePath = @"/me";
    NSDictionary *params = @{@"order": @"desc",
                             @"sort": @"reputation"};
    NSString *queryString = [self buildQueryStringWithParams:params];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", kAPIBaseURL, resourcePath, queryString];
    NSLog(@"%@", urlString);
    return [NSURL URLWithString:urlString];
}

@end
