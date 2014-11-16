//
//  QuestionsSearchVC.m
//  NSOverflow
//
//  Created by Casey R White on 11/15/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import "QuestionsSearchVC.h"
#import "CRWConstants.h"
#import "CRWStackOverflowClient.h"
#import "QuestionCell.h"
#import "CRWQuestion.h"
#import "NSString+Regex.h"
#import "QuestionWebVC.h"
#import <MONActivityIndicatorView/MONActivityIndicatorView.h>

@interface QuestionsSearchVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MONActivityIndicatorViewDelegate>

@property CRWStackOverflowClient *apiClient;
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) MONActivityIndicatorView *activityIndicator;

@end

@implementation QuestionsSearchVC

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    return _dateFormatter;
}

- (MONActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[MONActivityIndicatorView alloc] init];
        _activityIndicator.center = self.searchBar.center;
        _activityIndicator.numberOfCircles = 3;
        _activityIndicator.delegate = self;
        [self.searchBar addSubview:_activityIndicator];
    }
    
    return _activityIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Search Questions", nil);

    UINib *menuCellNib = [UINib nibWithNibName:kReIDQuestionCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:menuCellNib forCellReuseIdentifier:kReIDQuestionCell];
    
    self.apiClient = [CRWStackOverflowClient sharedClient];
    
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [text validate];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [[self activityIndicator] startAnimating];
    
    NSString *tagQuery = searchBar.text;
    
    if (tagQuery.length > 0) {

        [_apiClient fetchQuestionsWithTag:tagQuery completion:^(NSArray *questions, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
            else {
                self.questions = questions;
                [self.tableView reloadData];
                [[self activityIndicator] stopAnimating];
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReIDQuestionCell];
    CRWQuestion *question = self.questions[indexPath.row];
    [self configureCell:cell withQuestion:question];
    
    return cell;
}

- (void)configureCell:(QuestionCell *)cell withQuestion:(CRWQuestion *)question {
    cell.titleLabel.text = [question sanitizedTitle];
    cell.ownerNameLabel.text = question.ownerName;
    cell.dateCreatedLabel.text = [[self dateFormatter] stringFromDate:question.dateCreated];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRWQuestion *question = self.questions[indexPath.row];
    QuestionWebVC *webVC = [[QuestionWebVC alloc] initWithURL:[NSURL URLWithString:question.link]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webVC];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - MONActivityIndicatorViewDelegate

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    // For a random background color for a particular circle
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
