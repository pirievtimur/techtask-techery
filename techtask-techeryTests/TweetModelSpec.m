//
//  TweetModelSpec.m
//  techtask-techery
//
//  Created by Timur Piriev on 2/12/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import "Kiwi.h"
#import "TweetModel.h"
#import "JSONLoader.h"

SPEC_BEGIN(TweetModelSpec)

    describe(@"TweetModel", ^{
        it(@"should be correctly initialized from JSON values", ^{
            NSDictionary *json = [JSONLoader JSONFromResource:@"TweetModel" ofType:@"json"];
            
            NSError *error = nil;
            TweetModel *model = [MTLJSONAdapter modelOfClass:[TweetModel class] fromJSONDictionary:json error:&error];
            [[model shouldNot] beNil];
            [[error should] beNil];
            
            [[model.tweetId should] equal:@"1234567890"];
            [[model.tweetText should] equal:@"tweet's text"];
        });
    });

SPEC_END
