//
//  TweetModel.h
//  techtask-techery
//
//  Created by Timur Piriev on 1/27/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TweetModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *tweetText;

@end
