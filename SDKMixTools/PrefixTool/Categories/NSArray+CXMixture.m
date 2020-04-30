//
//  NSArray+CXMixture.m
//  SDKMixTools
//
//  Created by chr on 2020/4/2.
//  Copyright © 2020 chr. All rights reserved.
//

#import "NSArray+CXMixture.h"
#import <UIKit/UIKit.h>


@implementation NSArray (CXMixture)

- (NSString *)cx_lowerCamelCaseString {
    if (self.count == 0) return @"";
    
    NSMutableString *resultStr = [NSMutableString string];
    [self enumerateObjectsUsingBlock:^(NSString *_Nonnull component, NSUInteger idx, BOOL * _Nonnull stop) {
        [resultStr appendString:idx ? component.capitalizedString : component];
    }];
    return resultStr;
}

- (NSString *)cx_randomComponentString {
    return self[arc4random_uniform((uint32_t)(self.count))];
}

- (NSString *)cx_randomLowerCamelCaseStringWithComponentCount:(NSInteger)count {
    if (count >= self.count) return self.cx_lowerCamelCaseString;
    
    NSMutableArray *componentsArr = [NSMutableArray arrayWithCapacity:count];
    for (int i=0; i<count; i++) {
        [componentsArr addObject:self.cx_randomComponentString];
    }
    return componentsArr.cx_lowerCamelCaseString;
}

@end
