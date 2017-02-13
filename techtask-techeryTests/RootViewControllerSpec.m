#import "Kiwi.h"
#import "RootViewController.h"

SPEC_BEGIN(RootViewControllerSpec)

describe(@"Root view controller", ^{
    
    __block RootViewController *rootVC = nil;
    
    beforeAll(^{
        rootVC = [RootViewController new];
        [rootVC performSelector:@selector(setUpTextField)];
        [rootVC performSelector:@selector(setUpButton)];
    });
    
    it(@"has correct text field", ^{
        [[rootVC.usernameTextField.placeholder should] equal:@"Twitter user"];
        [[theValue(rootVC.usernameTextField.borderStyle) should] equal:theValue(UITextBorderStyleRoundedRect)];
        [[theValue(rootVC.usernameTextField.autocorrectionType) should] equal:theValue(UITextAutocorrectionTypeNo)];
    });
    
    it(@"has correct next button", ^{
        [[theValue(rootVC.nextButton.hidden) should] beYes];
        [[rootVC.nextButton.currentTitleColor should] equal:[UIColor blueColor]];
        [[rootVC.nextButton.titleLabel.text should] equal:@"Next"];
    });
});

SPEC_END
