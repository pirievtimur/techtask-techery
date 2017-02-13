//
//  JSONLoader.m
//  techtask-techery
//
//  Created by Timur Piriev on 2/12/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

#import "JSONLoader.h"

@implementation JSONLoader

+ (NSDictionary *)JSONFromResource:(NSString *)resource ofType:(NSString *)type {
    NSError *error;
    NSDictionary *json;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:resource ofType:type];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if(content) {
        NSData *objectData = [content dataUsingEncoding:NSUTF8StringEncoding];
        json = [NSJSONSerialization JSONObjectWithData:objectData
                                               options:NSJSONReadingMutableContainers
                                                 error:&error];
    }
    if(error) {
        [NSException raise:NSStringFromClass([self class]) format:@"Unable to load JSON from file %@.%@", resource, type];
    }
    
    return json;
}

@end
