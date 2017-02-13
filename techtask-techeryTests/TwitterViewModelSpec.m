//
//  TwitterViewModelSpec.m
//  techtask-techery
//
//  Created by Timur Piriev on 2/12/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import "Kiwi.h"
#import "TwitterViewModel.h"
#import "TwitterService.h"

SPEC_BEGIN(TwitterViewModelSpec)

describe(@"TwitterViewModel", ^{
    
    __block TwitterViewModel *model = nil;
    
    beforeAll(^{
        TwitterService *service = [TwitterService new];
        model = [[TwitterViewModel alloc] initWithTwitterService:service userName:@"twitterUser"];
    });
    
    it(@"should be properly initialized", ^{
        [[model.twitterUser should] equal:@"twitterUser"];
        [[theValue(model.tweets.count) should] equal:theValue(0)];
        [[theValue(model.isAbleToPost) should] beFalse];
    });
});

SPEC_END
