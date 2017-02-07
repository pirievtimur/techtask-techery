//
//  TwitterService.m
//  techtask-techery
//
//  Created by Timur Piriev on 1/27/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import "TwitterService.h"

#import <Accounts/Accounts.h>
#import <Social/SLRequest.h>
#import <Mantle/Mantle.h>
#import "TweetModel.h"

NSString *const kTimelineUrl = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
NSString *const kStatusUpdateUrl = @"https://api.twitter.com/1.1/statuses/update.json";

@implementation TwitterService

- (RACSignal *)loadTweetsFor:(NSString *)userId count:(NSInteger)count before:(NSString *)tweetId {
    @weakify(self)
    return [[[self authorize] flattenMap:^RACStream *(ACAccount *twitterAcc) {
        @strongify(self)
        return [self requestWithAccount:twitterAcc forUser:userId count:count before:tweetId];
    }] flattenMap:^RACStream *(NSArray *response) {
        @strongify(self)
        return [self mapper:response];
    }];
}

- (RACSignal *)updateStatus:(NSString *)status {
    @weakify(self)
    return [[[self authorize] flattenMap:^RACStream *(ACAccount *twitterAcc) {
        @strongify(self)
        return [self updateStatus:status account:twitterAcc];
    }] flattenMap:^RACStream *(NSDictionary *response) {
        @strongify(self)
        return [self statusUpdateMapper:response];
    }];
}

- (RACSignal *)requestWithAccount:(ACAccount *)account forUser:(NSString *)user count:(NSInteger)count before:(NSString *)tweetId {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURL *URL = [NSURL URLWithString:kTimelineUrl];
        
        NSMutableDictionary *requestParams = [@{ @"screen_name" : user, @"count" : @(count).stringValue} mutableCopy];
        
        if (tweetId) { requestParams[@"max_id"] = tweetId; }
        
        SLRequest *feedRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:URL parameters:requestParams];
        feedRequest.account = account;
        
        [feedRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                NSError *serialisationError = nil;
                NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&serialisationError];
                if (serialisationError) {
                    [subscriber sendError:serialisationError];
                } else {
                    [subscriber sendNext:responseJSON];
                    [subscriber sendCompleted];
                }
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)updateStatus:(NSString *)status account:(ACAccount *)account {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURL *URL = [NSURL URLWithString:kStatusUpdateUrl];
        
        NSDictionary *parameters = @{@"status" : status};
        
        SLRequest *tweetRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:URL parameters:parameters];
        
        tweetRequest.account = account;
        
        [tweetRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                if (urlResponse.statusCode == 403) {
                    [subscriber sendError:[NSError errorWithDomain:NSStringFromClass([self class]) code:403 userInfo:nil]];
                } else {
                    NSError *serialisationError = nil;
                    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&serialisationError];
                    
                    if (serialisationError) {
                        [subscriber sendError:serialisationError];
                    } else {
                        [subscriber sendNext:responseJSON];
                        [subscriber sendCompleted];
                    }
                }
            }
        }];
        return nil;
    }];
    
}

- (RACSignal *)authorize {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        ACAccountStore *accStore = [[ACAccountStore alloc] init];
        ACAccountType *accType = [accStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter];
        
        void(^completion)(id<RACSubscriber>) = ^(id<RACSubscriber> subscriber) {
            NSArray *accounts = [accStore accountsWithAccountType:accType];
            
            if (accounts.count == 0) {
                [subscriber sendError:[NSError errorWithDomain:NSStringFromClass([self class]) code:404 userInfo:nil]];
            } else {
                [subscriber sendNext:accounts.lastObject];
                [subscriber sendCompleted];
            }
        };
        
        if (accType.accessGranted) {
            completion(subscriber);
        } else {
            //request account again
            [accStore requestAccessToAccountsWithType:accType options:nil completion:^(BOOL granted, NSError *error) {
                granted == YES ? completion(subscriber) : [subscriber sendError:error];
            }];
        }
        return nil;
    }];
}

- (RACSignal *)mapper:(NSArray *)response {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSError *mappingError = nil;
        
        NSMutableArray *responseTweets = [[MTLJSONAdapter modelsOfClass:[TweetModel class] fromJSONArray:response error:&mappingError] mutableCopy];
        
        if (mappingError) {
            [subscriber sendError:mappingError];
        } else {
            [subscriber sendNext:responseTweets];
            [subscriber sendCompleted];
        }
        
        return nil;
    }];
}

- (RACSignal *)statusUpdateMapper:(NSDictionary *)response {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *mappingError = nil;
        
        TweetModel *responseStatus = [MTLJSONAdapter modelOfClass:[TweetModel class] fromJSONDictionary:response error:&mappingError];
        
        if (mappingError) {
            [subscriber sendError:mappingError];
        } else {
            [subscriber sendNext:responseStatus];
            [subscriber sendCompleted];
        }
        
        return nil;
    }];
}


@end
