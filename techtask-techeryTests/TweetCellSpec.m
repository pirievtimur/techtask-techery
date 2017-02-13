#import "Kiwi.h"
#import "TweetCell.h"

SPEC_BEGIN(TweetCellSpec)

describe(@"TweetCell", ^{
    
    __block TweetCell *cell = nil;
    
    beforeAll(^{
        cell = [TweetCell new];
    });
    
    it(@"has correct identifier", ^{
        NSString *identifier = [TweetCell identifier];
        [[identifier should] equal:@"TweetCell"];
    });
    
    it(@"correctly updates textlabel", ^{
        TweetModel *model = [TweetModel new];
        model.tweetText = @"Tweet's text";
        [cell updateWithTweetModel:model];
        
        [[cell.tweetText.text should] equal:model.tweetText];
    });
});

SPEC_END
