//
//  QuestionTests.m
//  NSOverflow
//
//  Created by Casey R White on 11/15/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CRWStackOverflowClient.h"
#import "CRWStackOverflowClient_Private.h"
#import "CRWQuestion.h"

@interface ParsingTests : XCTestCase

@end

@implementation ParsingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQuestionDataParsing {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *testDataPath = [bundle pathForResource:@"questions" ofType:@"json"];
    NSError *readError = nil;
    NSData *testData = [NSData dataWithContentsOfFile:testDataPath options:NSDataReadingUncached error:&readError];
    
    if (readError) {
        XCTFail(@"Error reading test json");
    }
    else {
        CRWStackOverflowClient *apiClient = [CRWStackOverflowClient sharedClient];
        NSError *parseError = nil;
        NSArray *questions = [apiClient parseQuestionsFromJSON:testData error:&parseError];
        
        XCTAssertEqual(questions.count, 2, @"should be equal");
        
        CRWQuestion *question = questions.firstObject;
        
        XCTAssertEqual(question.questionID, 26951039, @"should be equal");
        XCTAssertNotNil(question.title, @"should not be nil");
    }
}

@end
