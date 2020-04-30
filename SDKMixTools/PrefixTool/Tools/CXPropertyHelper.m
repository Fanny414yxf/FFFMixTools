//
//  CXPropertyHelper.m
//  SDKMixTools
//
//  Created by chr on 2020/4/13.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXPropertyHelper.h"
#import "CXConfuseConsts.h"
#import "NSString+CXMixture.h"
#import "CXRegularExpressionHelper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-escape-sequence"

@implementation CXPropertyHelper

+ (NSArray<NSString *> *)cx_propertyListForHeaderFilePath:(NSString *)headerFilePath {
    NSError *error = nil;
    NSString *declaration = [NSString stringWithContentsOfFile:headerFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error || declaration.length == 0) return @[];
    
    NSString *propertyPattern = CXPropertyFormatPattern;
    __block NSError *errorPattern = nil;
    NSMutableArray <NSString *>*propertyArr = [NSMutableArray array];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:propertyPattern options:NSRegularExpressionCaseInsensitive error:&errorPattern];
    [regex enumerateMatchesInString:declaration options:NSMatchingReportCompletion range:NSMakeRange(0, [declaration length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (errorPattern) {
                NSLog(@"属性格式匹配出错：%@", errorPattern);
                return;
            }
            if (result && result.range.location != NSNotFound) {
                [propertyArr addObject:[declaration substringWithRange:result.range]];
            }
    }];
    
    return propertyArr;
}

+ (NSString *)cx_truncatePropertyNameWithPropertyStr:(NSString *)propertyStr {
    __block NSString *resultStr = @"";
    [CXRegularExpressionHelper cx_regularExpressionFirstMatchWithPatetrn:@"[A-Za-z0-9_]+[ ]*;" sourceString:propertyStr usingBlock:^(NSTextCheckingResult * _Nullable result) {
        if (result.range.location != NSNotFound) {
            resultStr = [[propertyStr substringWithRange:result.range] stringByReplacingOccurrencesOfString:@" " withString:@""];
            resultStr = [resultStr stringByReplacingOccurrencesOfString:@";" withString:@""];
        }
    }];
    return resultStr;
}

#pragma clang diagnostic pop
@end
