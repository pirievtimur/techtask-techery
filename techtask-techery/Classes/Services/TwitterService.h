//
//  TwitterService.h
//  techtask-techery
//
//  Created by Timur Piriev on 1/27/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TwitterService : NSObject

- (RACSignal *)loadTweetsFor:(NSString *)userId count:(NSInteger)count before:(NSString *)tweetId;
- (RACSignal *)updateStatus:(NSString *)status;
- (RACSignal *)authorize;

@end
