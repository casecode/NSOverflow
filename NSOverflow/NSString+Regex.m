//
//  NSString+Regex.m
//  NSOverflow
//
//  Created by Casey R White on 11/15/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

- (BOOL)validate {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9a-zA-Z\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger match = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (match > 0) {
        return NO;
    }
    return YES;
}

@end
