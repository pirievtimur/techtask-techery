//
//  RootViewController.m
//  techtask-techery
//
//  Created by Timur Piriev on 2/4/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import "RootViewController.h"
#import "FeedViewController.h"
#import "TwitterService.h"
#import "TwitterViewModel.h"

#import <Masonry/Masonry.h>
#import <Accounts/Accounts.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTextField];
    [self setUpButton];
    [self setUpObservers];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setUpTextField {
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.placeholder = @"Twitter user";
    
    [self.view addSubview:self.usernameTextField];
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.bounds.size.width / 2.f);
        make.height.mas_equalTo(20.f);
        make.center.equalTo(self.view);
    }];
}

- (void)setUpButton {
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(onNextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextButton];
    [self.nextButton setHidden:YES];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.view);
        make.rightMargin.equalTo(self.view);
        make.bottomMargin.equalTo(self.view);
        make.height.mas_equalTo(100.f);
    }];
}

- (void)setUpObservers {
    @weakify(self);
    [self.usernameTextField.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        [self.nextButton setHidden:text.length >= 4 ? NO : YES];
    }];
}

- (void)onNextButtonClick {
    TwitterService *service = [TwitterService new];
    TwitterViewModel *viewModel = [[TwitterViewModel alloc] initWithTwitterService:service userName:self.usernameTextField.text];
    FeedViewController *feedVC = [[FeedViewController alloc] initWithViewModel:viewModel];
    
    [self.navigationController pushViewController:feedVC animated:YES];
}

@end
