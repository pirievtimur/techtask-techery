//
//  TweetCell.h
//  techtask-techery
//
//  Created by Timur Piriev on 1/27/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) UILabel *tweetText;

- (void)updateWithTweetModel:(TweetModel *)tweetModel;
+ (NSString *)identifier;



@end
