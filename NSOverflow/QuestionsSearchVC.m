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

@interface QuestionsSearchVC () <UITableViewDataSource, UISearchBarDelegate>

@property CRWStackOverflowClient *apiClient;
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation QuestionsSearchVC

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    return _dateFormatter;
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.center = self.searchBar.center;
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
    cell.titleLabel.text = question.title;
    cell.ownerNameLabel.text = question.ownerName;
    cell.dateCreatedLabel.text = [[self dateFormatter] stringFromDate:question.dateCreated];
}

@end
