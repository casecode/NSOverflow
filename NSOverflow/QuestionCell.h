//
//  QuestionCell.h
//  NSOverflow
//
//  Created by Casey R White on 11/15/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *ownerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateCreatedLabel;

@end
