//
//  FeedViewController.m
//  techtask-techery
//
//  Created by Timur Piriev on 1/27/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import "FeedViewController.h"
#import "TweetCell.h"
#import <Masonry/Masonry.h>

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) TwitterViewModel *viewModel;

@property (nonatomic, assign) BOOL isWorking;

@end

@implementation FeedViewController

- (instancetype)initWithViewModel:(TwitterViewModel *)model {
    self = [super init];
    if (self) {
        self.viewModel = model;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self setUpTableView];
    [self setUpRefreshControl];
    [self setObsevers];
    [self setUpUpdateButton];
    [self setUpTitle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self startLoading];
}

- (void)setObsevers {
    
    RAC(self, isWorking) = self.viewModel.loadTweetsCommand.executing;
    
    @weakify(self);
    [[RACObserve(self.viewModel, tweets) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.viewModel.reloadTweetsCommand.executing subscribeNext:^(NSNumber *isExecuting) {
        @strongify(self);
        isExecuting.boolValue ? [self.refreshControl beginRefreshing] : [self.refreshControl endRefreshing];
    }];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.tableView registerClass:[TweetCell class] forCellReuseIdentifier:[TweetCell identifier]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setUpRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(startReloading) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)setUpUpdateButton {
    if (self.viewModel.isAbleToPost == NO) { return; }
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(updateStatus)];
    self.navigationItem.rightBarButtonItem = updateButton;
}

- (void)setUpTitle {
    self.title = self.viewModel.twitterUser;
}

- (void)startLoading {
    if (self.isWorking) { return; }
    [self.viewModel.loadTweetsCommand execute:nil];
}

- (void)startReloading {
    [self.viewModel.reloadTweetsCommand execute:nil];
}

- (void)updateStatus {
    @weakify(self);
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"New tweet" message: nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Your tweet here";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        if (alertController.textFields[0].text.length > 0) {
            [[self.viewModel updateStatusWithText:alertController.textFields[0].text] subscribeError:^(NSError *error) {
                @strongify(self);
                [self presentViewController:[self alertWithText:error.localizedDescription] animated:YES completion:nil];
            }];
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (UIAlertController *)alertWithText:(NSString *)text {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:text message: nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    return alertController;
}

// MARK: - UITableView delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.viewModel.tweets.count - 1) {
        [self startLoading];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[TweetCell identifier]];
    cell.textLabel.text = [self.viewModel.tweets objectAtIndex:indexPath.row].tweetText;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
}

@end
