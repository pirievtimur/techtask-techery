//
//  TweetCell.m
//  techtask-techery
//
//  Created by Timur Piriev on 1/27/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import "TweetCell.h"
#import <Masonry/Masonry.h>

@interface TweetCell()

@property (nonatomic, strong) UILabel *tweetText;

@end

@implementation TweetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCellView];
    }
    return self;
}

+ (NSString *)identifier {
    return @"TweetCell";
}

- (void)updateWithTweetModel:(TweetModel *)tweetModel {
    self.tweetText.text = tweetModel.tweetText;
}

- (void)setUpCellView {
    [self setUpTextLabel];
    [self addSeparatorView];
}

- (void)setUpTextLabel {
    self.tweetText = [UILabel new];
    [self.contentView addSubview:self.tweetText];
    [self.tweetText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
}

- (void)addSeparatorView {
    UIView *separator = [UIView new];
    separator.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.offset(0);
        make.rightMargin.offset(0);
        make.bottomMargin.offset(0);
        make.height.offset(1);
    }];
}


@end
