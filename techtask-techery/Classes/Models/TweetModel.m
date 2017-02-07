//
//  TweetModel.m
//  techtask-techery
//
//  Created by Timur Piriev on 1/27/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import "TweetModel.h"

@implementation TweetModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tweetId" : @"id_str",
             @"tweetText" : @"text",
            };
}

@end

