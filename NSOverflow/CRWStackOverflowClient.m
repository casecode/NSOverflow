//
//  CRWStackOverflowClient.m
//  NSOverflow
//
//  Created by Casey R White on 11/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "CRWStackOverflowClient.h"

@interface CRWStackOverflowClient ()

@property (nonatomic, strong) NSString * const apiBaseURL;
@property (nonatomic, strong) NSString * const apiKey;

@end


@implementation CRWStackOverflowClient

- (instancetype)init {
    if (self = [super init]) {
        self.apiBaseURL = @"https://api.stackexchange.com/2.2";
        self.apiKey = @"eecC8QAViP40PkTd16RXrQ((";
    }

    return self;
}

- (void)fetchObjectsAtPath:(NSString *)path withParams:(NSDictionary *)params completion:(void (^)(NSData *, NSString *))callback {
    
    NSMutableString *builtURL = [[NSMutableString alloc] initWithString:self.apiBaseURL];
    
    if (path != nil)
    {
        [builtURL appendString:path];
    }
    
    NSLog(@"%@", builtURL);
    
    NSURL *url = [NSURL URLWithString:builtURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    id dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        
        NSUInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            switch (statusCode)
            {
                case 200:
                case 201:
                case 204:
                {
//                    errorMessage = nil;
//                    NSError *parseError;
//                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
//                    if (parseError == nil) {
//                        
//                    }
                    callback(data, nil);
                }
                    break;
                default:
                {
                    callback(nil, @"Error with request");
                }
                break;
            }
        }
        
    }];
    
    [dataTask resume];
    
    callback(nil, @"Was there an error?");
}

@end
