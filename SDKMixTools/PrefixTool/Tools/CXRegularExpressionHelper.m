//
//  CXRegularExpressionHelper.m
//  SDKMixTools
//
//  Created by chr on 2020/3/19.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXRegularExpressionHelper.h"

@implementation CXRegularExpressionHelper

+ (void)cx_regularExpressionWithPatetrn:(NSString *)pattern sourceString:(NSString *)sourceStr usingBlock:(void (^)(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop))block {
    NSString *importsPattern = pattern;
    __block NSError *errorPattern = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:importsPattern options:NSRegularExpressionCaseInsensitive error:&errorPattern];
    [regex enumerateMatchesInString:sourceStr options:NSMatchingReportCompletion range:NSMakeRange(0, [sourceStr length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (errorPattern) {
                NSLog(@"格式匹配出错：%@", errorPattern);
                return;
            }
            if (result) {
                if (block) {
                    block(result, flags, stop);
                }
            }
    }];
}

+ (void)cx_regularExpressionFirstMatchWithPatetrn:(NSString *)pattern sourceString:(NSString *)sourceStr usingBlock:(void (^)(NSTextCheckingResult * _Nullable result))block {
    NSString *importsPattern = pattern;
    __block NSError *errorPattern = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:importsPattern options:NSRegularExpressionCaseInsensitive error:&errorPattern];
    NSTextCheckingResult *result = [regex firstMatchInString:sourceStr options:NSMatchingReportCompletion range:NSMakeRange(0, [sourceStr length])];
    if (result && result.range.location != NSNotFound) {
        if (block) {
            block(result);
        }
    } else {
        NSLog(@"格式匹配出错：%@", errorPattern);
        return;
    }
    
}


+ (void)cx_regularExpressionWithPatetrn:(NSString *)pattern options:(NSRegularExpressionOptions)options sourceString:(NSString *)sourceStr usingBlock:(void (^)(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL *stop))block {
    NSString *importsPattern = pattern;
    __block NSError *errorPattern = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:importsPattern options:options error:&errorPattern]; // NSRegularExpressionIgnoreMetacharacters
    [regex enumerateMatchesInString:sourceStr options:NSMatchingReportCompletion range:NSMakeRange(0, [sourceStr length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (errorPattern) {
                NSLog(@"格式匹配出错：%@", errorPattern);
                return;
            }
            if (result) {
                if (block) {
                    block(result, flags, stop);
                }
            }
    }];
}


@end
