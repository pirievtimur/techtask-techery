//
//  FeedViewController.h
//  techtask-techery
//
//  Created by Timur Piriev on 1/27/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterViewModel.h"

@interface FeedViewController : UIViewController

- (instancetype)initWithViewModel:(TwitterViewModel *)model;

@property (nonatomic, assign) BOOL statusUpdateEnabled;

@end
