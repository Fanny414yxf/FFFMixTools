//
//  CXMethodsListHelper.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMethodsListHelper.h"
#import "CXConfuseConsts.h"
#import "NSString+CXMixture.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-escape-sequence"
@implementation CXMethodsListHelper


/// 获取指定的.h文件的方法列表
/// @param filePath 传入的头文件
+ (NSArray <NSString *>*)cx_methodsArrayForHeaderFile:(NSString *)filePath {
    NSError *error = nil;
    NSString *declaration = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error || declaration.length == 0) return @[];
    // 有条件编译 -- 略过
//    if ([filePath cx_hasConditionCompiles]) return @[];
    
    // 匹配前缀
    NSString *methodBeginsPattern = CXMethodSignaturePattern;
    __block NSError *errorPattern = nil;
    NSMutableArray <NSString *>*methodsArr = [NSMutableArray array];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:methodBeginsPattern options:NSRegularExpressionCaseInsensitive error:&errorPattern];
    [regex enumerateMatchesInString:declaration options:NSMatchingReportCompletion range:NSMakeRange(0, [declaration length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (errorPattern) {
                NSLog(@"方法格式匹配出错：%@", errorPattern);
                return;
            }
            if (result && result.range.location != NSNotFound) {
//                    NSString *prefixStr = [declaration substringWithRange:result.range];
//                    NSLog(@"%@:%@", prefixStr, NSStringFromRange(result.range));
                [methodsArr addObject:[declaration substringWithRange:result.range]];
            }
    }];
    
    return methodsArr;
}

+ (NSArray<NSString *> *)cx_methodsArrayForImplemetationFilePath:(NSString *)filePath {
    NSString *implementationStr = [NSString cx_fileDataStrAtPath:filePath];
    return [self cx_methodsArrayWithImplementationFileDataStr:implementationStr];
}


/// 根据方法名的字符串找出方法的第一段字符串
/// @param methodStr 方法名字符串
+ (NSString *)cx_truncateMethodFirstSegmentWithMethodString:(NSString *)methodStr {
    // 去除空格
    methodStr = [methodStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 匹配
    NSString *patternPrefix = CXMethodsPrefixPattern;   // 匹配 -(void)类似的格式
    NSError *errorPrefix = NULL;
    NSString *prefixStr;
    
    // 匹配前缀
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternPrefix options:NSRegularExpressionCaseInsensitive error:&errorPrefix];
    NSTextCheckingResult *resultPrefix = [regex firstMatchInString:methodStr options:0 range:NSMakeRange(0, [methodStr length])];
    if (errorPrefix) {
        NSLog(@"方法格式匹配出错：%@", errorPrefix);
        return nil;
    }
    if (resultPrefix) {
//        NSLog(@"$$$:%@", [methodStr substringWithRange:resultPrefix.range]);
        prefixStr = [methodStr substringWithRange:resultPrefix.range];
    }
    
    BOOL hasParams = [methodStr containsString:@":"];
    // 匹配方法的第一段
    if (!hasParams) {
        // 没有参数
        return [methodStr substringWithRange:NSMakeRange(prefixStr.length, methodStr.length - prefixStr.length -1)];
    }
    
    // 有参数
    NSString *patternSeg = [NSString stringWithFormat:@"%@[A-Za-z0-9_]+[ ]*[:]", CXMethodsPrefixPattern];
    NSError *errorSeg = NULL;
    NSString *segStr;
    
    NSRegularExpression *regexSeg = [NSRegularExpression regularExpressionWithPattern:patternSeg options:NSRegularExpressionCaseInsensitive error:&errorSeg];
    NSTextCheckingResult *resultSeg = [regexSeg firstMatchInString:methodStr options:0 range:NSMakeRange(0, [methodStr length])];
    if (errorPrefix) {
        NSLog(@"方法第一段格式匹配出错：%@", errorPrefix);
        return nil;
    }
    if (resultSeg) {
//        NSLog(@"%@", [methodStr substringWithRange:resultSeg.range]);
        segStr = [methodStr substringWithRange:NSMakeRange(resultSeg.range.location, resultSeg.range.length-1)];
    }
    
    return [segStr substringFromIndex:prefixStr.length];
}

+ (NSArray<NSString *> *)cx_methodsArrayWithImplementationFileDataStr:(NSString *)implementationStr {
    if (implementationStr.length == 0) return @[];
    
    NSMutableArray <NSTextCheckingResult *>*resultsArr = [NSMutableArray array];
    NSMutableArray <NSString *>*methodsArr = [NSMutableArray array];
    NSString *methodBeginsPattern = CXMethodsPrefixPattern;
    __block NSError *errorPattern = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:methodBeginsPattern options:NSRegularExpressionCaseInsensitive error:&errorPattern];
//            NSLog(@"当前方法实现：\n%@", singleImp);
    
    [regex enumerateMatchesInString:implementationStr options:NSMatchingReportCompletion range:NSMakeRange(0, [implementationStr length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (errorPattern) {
                NSLog(@"方法格式匹配出错：%@", errorPattern);
            }
            if (result) {
//                        NSString *prefixStr = [singleImp substringWithRange:result.range];
//                        NSLog(@"%@:%@", prefixStr, NSStringFromRange(result.range));
                [resultsArr addObject:result];
            }
    }];
    
    // rangesArr 保存除去首尾之外的所有方法的起始位置的range值
    NSMutableArray <NSString *>*rangesArr = [NSMutableArray arrayWithCapacity:resultsArr.count];
    if (resultsArr.count == 0) return @[];
    [rangesArr addObject:NSStringFromRange(resultsArr[0].range)];
    // 处理方法注释、空白换行ect..
    NSInteger resultsCount = resultsArr.count;
    for (int i=0; i<resultsCount-1; i++) {
        
        NSTextCheckingResult *currentResult = resultsArr[i];
        NSTextCheckingResult *nextResult = resultsArr[i+1];
        
        NSUInteger currentLoc = currentResult.range.location;
        NSUInteger nextLoc = nextResult.range.location;
        
        NSString *currentMethod = [implementationStr substringWithRange:NSMakeRange(currentLoc, nextLoc - currentLoc)];
        NSRange endRange = [currentMethod rangeOfString:i==resultsCount-1 ? CXClassEndIdentifier : @"}" options:NSBackwardsSearch];
        if (endRange.location != NSNotFound) {
            NSRange range = NSMakeRange(currentResult.range.location + endRange.location + 1, nextResult.range.length);
            [rangesArr addObject:NSStringFromRange(range)];
        }
    }
    
    __block NSInteger location = 0;
    
    [rangesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull rangeStr, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = NSRangeFromString(rangeStr);
        NSString *method = [implementationStr substringWithRange:NSMakeRange(location, range.location - location)];
        [methodsArr addObject:method];
        location += method.length;
        if (idx == rangesArr.count-1) {
            NSString *lastMethod = [implementationStr substringFromIndex:location];
            NSRange endRange = [lastMethod rangeOfString:@"}" options:NSBackwardsSearch];
            if (endRange.location != NSNotFound) {
                [methodsArr addObject:[implementationStr substringWithRange:NSMakeRange(location, endRange.location+1)]];
            }
        }
    }];
    return methodsArr;
}

#pragma clang diagnostic pop
@end
