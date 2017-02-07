//
//  TwitterViewModel.m
//  techtask-techery
//
//  Created by Timur Piriev on 1/27/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import "TwitterViewModel.h"

#import <Accounts/Accounts.h>
#import <Reachability.h>

@interface TwitterViewModel()

@property (nonatomic, strong) TwitterService *twitterService;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) NSString *lastTweetId;

@end

@implementation TwitterViewModel

- (instancetype)initWithTwitterService:(TwitterService *)service userName:(NSString *)name {
    self = [super init];
    if (self) {
        self.twitterService = service;
        self.twitterUser = name;
        
        [self checkAvailableToPost];
        [self setUpCommand];
        [self setUpConnectionNotifier];
        
        self.reachability = [Reachability reachabilityForInternetConnection];
        self.tweets = @[];
    }
    
    return self;
}

- (void)setUpConnectionNotifier {
    self.reachability = [Reachability reachabilityForInternetConnection];
    @weakify(self);
    self.reachability.reachableBlock = ^(Reachability * reachability) {
        @strongify(self);
        [self.loadTweetsCommand execute:nil];
    };
    [self.reachability startNotifier];
}

- (void)setUpCommand {
    @weakify(self);
    self.loadTweetsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self loadTweets] doNext:^(NSMutableArray *tweets) {
            self.tweets = [self.tweets arrayByAddingObjectsFromArray:tweets];
        }];
    }];
    
    self.reloadTweetsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.lastTweetId = nil;
        return [[self loadTweets] doNext:^(NSMutableArray *tweets) {
            self.tweets = tweets;
        }];
    }];
}

- (void)checkAvailableToPost {
    @weakify(self);
    [[self.twitterService authorize] subscribeNext:^(ACAccount *twitterAccount) {
        @strongify(self);
        self.isAbleToPost = [self.twitterUser.lowercaseString isEqualToString:twitterAccount.username.lowercaseString];
    }];
}

- (RACSignal *)updateStatusWithText:(NSString *)text {
    @weakify(self);
    return [[self.twitterService updateStatus:text] doNext:^(TweetModel *tweet) {
        @strongify(self);
        NSArray *tweetsArray = [NSArray arrayWithObject:tweet];
        self.tweets = [tweetsArray arrayByAddingObjectsFromArray:self.tweets];
    }];
}

- (RACSignal *)loadTweets {
    @weakify(self);
    return [[[self.twitterService loadTweetsFor:self.twitterUser count:20 before:self.lastTweetId] map:^id(NSMutableArray *newTweets) {
        @strongify(self);
        if ([newTweets.firstObject isEqual:self.tweets.lastObject]) {
            [newTweets removeObjectAtIndex:0];
        }
        
        return newTweets;
    }] doNext:^(NSMutableArray<TweetModel*> *newTweets) {
        @strongify(self);
        self.lastTweetId = newTweets.lastObject.tweetId;
    }];
}

@end
