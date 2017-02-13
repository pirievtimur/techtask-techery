//
//  TwitterViewModel.h
//  techtask-techery
//
//  Created by Timur Piriev on 1/27/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterService.h"
#import "TweetModel.h"

@interface TwitterViewModel : NSObject

@property (nonatomic, strong) NSArray <TweetModel *>* tweets;
@property (nonatomic, strong) RACCommand *loadTweetsCommand;
@property (nonatomic, strong) RACCommand *reloadTweetsCommand;
@property (nonatomic, strong) NSString *twitterUser;
@property (nonatomic, assign) BOOL isAbleToPost;

- (instancetype)initWithTwitterService:(TwitterService *)service userName:(NSString *)name;
- (RACSignal *)updateStatusWithText:(NSString *)text;

@end
