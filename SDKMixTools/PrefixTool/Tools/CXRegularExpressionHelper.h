//
//  CXRegularExpressionHelper.h
//  SDKMixTools
//
//  Created by chr on 2020/3/19.
//  Copyright © 2020 chr. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXRegularExpressionHelper : NSObject

+ (void)cx_regularExpressionWithPatetrn:(NSString *)pattern sourceString:(NSString *)sourceStr usingBlock:(void (^)(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL *stop))block;

+ (void)cx_regularExpressionFirstMatchWithPatetrn:(NSString *)pattern sourceString:(NSString *)sourceStr usingBlock:(void (^)(NSTextCheckingResult * _Nullable result))block;

+ (void)cx_regularExpressionWithPatetrn:(NSString *)pattern options:(NSRegularExpressionOptions)options sourceString:(NSString *)sourceStr usingBlock:(void (^)(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
