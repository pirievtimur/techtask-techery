//
//  AppDelegate.h
//  techtask-techery
//
//  Created by Timur Piriev on 1/24/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

