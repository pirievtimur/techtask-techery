//
//  JSONLoader.h
//  techtask-techery
//
//  Created by Timur Piriev on 2/12/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONLoader : NSObject

+ (NSDictionary *)JSONFromResource:(NSString *)resource ofType:(NSString *)type;

@end
