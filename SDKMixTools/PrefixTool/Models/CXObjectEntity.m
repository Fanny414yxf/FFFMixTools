//
//  CXObjectEntity.m
//  SDKMixTools
//
//  Created by chr on 2020/3/19.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXObjectEntity.h"
#import "CXParamEntity.h"
#import "CXRegularExpressionHelper.h"
#import "NSString+CXMixture.h"
#import "NSArray+CXMixture.h"
#import "CXConfuseConsts.h"
#import "CXMethodMetaDataHelper.h"

@interface CXObjectEntity ()
@property (nonatomic, copy, readwrite) NSString *objectName;
@end
@implementation CXObjectEntity

- (NSString *)objectName {
    if (_objectName.length == 0) {
//        uint32_t index = arc4random_uniform(31)+arc4random_uniform(31)+arc4random_uniform(31)+arc4random_uniform(31)+arc4random_uniform(31) +arc4random_uniform(31)+arc4random_uniform(31)+arc4random_uniform
//            (31)+arc4random_uniform(31)+arc4random_uniform(31);
//        _objectName = [NSString stringWithFormat:@"%@%u", [self.className cx_stringWithReversedFirstCapitalizedLetterComponentsCount:2], index];
        _objectName = [[CXMethodMetaDataHelper sharedInstance] cx_generateARandomMethodSegmentNameAtIndex:2];
    }
    return _objectName;
}

- (NSMutableString *)cx_getInitializitionString {
    NSMutableString *createrStr = [NSMutableString stringWithFormat:@"\n\t// 生成 %@ 类的对象\n\t%@ *%@ = [[%@ alloc] %@];\n\t", self.className, self.className, self.objectName, self.className, self.methodsList.firstObject];
    return createrStr;
}

- (NSMutableString *)cx_getRandomMethodInvokedString {
//    NSMutableString *createrStr = [self cx_getInitializitionString];
    NSMutableString *createrStr = [NSMutableString stringWithFormat:@"\n\t// 生成 %@ 类的对象\n\t%@ *%@ = [[%@ alloc] init];\n\t[%@ %@];\n\t", self.className, self.className, self.objectName, self.className, self.objectName, [self cx_discardMethodPrefixWithMethodString:self.methodsList.firstObject]];
    /*
    // 随机获取一个方法
    NSInteger methodIdx = arc4random_uniform((uint32_t)(self.methodsList.count));
    NSString *randmomMethod = self.methodsList[methodIdx];
    __block NSString *randomMethodCopy = [randmomMethod copy];
    
    // 获取所有参数类型
    // 1、获取所有参数类型，并声成对应的实参
    NSString *paramsPattern = CXMethodsParamTypePattern;
    
    NSMutableArray <CXParamEntity *>*paramsArr = [NSMutableArray array];
    [CXRegularExpressionHelper cx_regularExpressionWithPatetrn:paramsPattern sourceString:randmomMethod usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *paramClassStr = [randmomMethod substringWithRange:result.range];
        CXParamEntity *param = [[CXParamEntity alloc] init];
        if (![paramClassStr containsString:@"*"]) {
            // 基本数据类型
            param.className = [paramClassStr substringWithRange:NSMakeRange(2, paramClassStr.length-3)];
            param.isObjectType = NO;
        } else {
            // 对象类型
            param.className = [paramClassStr substringWithRange:NSMakeRange(2, paramClassStr.length-4)];
            param.isObjectType = YES;
        }
        [createrStr appendFormat:@"%@", [param cx_getInitializitionString]];
        [paramsArr addObject:param];
    }];
    
    NSString *rangesPattern = [NSString stringWithFormat:@"%@[A-Za-z0-9_]+", CXMethodsParamPattern];
    
    // 2、替换形参为实参 ??
    __block NSInteger count = 0;
    while (count < paramsArr.count) {
        [CXRegularExpressionHelper cx_regularExpressionFirstMatchWithPatetrn:rangesPattern sourceString:randomMethodCopy usingBlock:^(NSTextCheckingResult * _Nullable result) {
            if (count < paramsArr.count) {
                CXParamEntity *param = paramsArr[count];
                randomMethodCopy = [randomMethodCopy stringByReplacingCharactersInRange:NSMakeRange(result.range.location+1, result.range.length-1) withString:param.objectName];
                count++;
            }
        }];
    }
    randomMethodCopy = [self cx_discardMethodPrefixWithMethodString:randomMethodCopy];
        
    // 3、组装调用格式
    if ([randmomMethod containsString:@"+"]) {
        [createrStr appendString:[NSString stringWithFormat:@"[%@ %@];", self.className, randomMethodCopy]];
    } else {
        [createrStr appendString:[NSString stringWithFormat:@"[%@ %@];", self.objectName, randomMethodCopy]];
    }
    */
    return createrStr;
}

- (NSString *)cx_discardMethodPrefixWithMethodString:(NSString *)methodStr {
    NSString *methodBeginsPattern = CXMethodsPrefixPattern;
    __block NSString *resultStr = nil;
    [CXRegularExpressionHelper cx_regularExpressionWithPatetrn:methodBeginsPattern sourceString:methodStr usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *prefixStr = [methodStr substringWithRange:result.range];
        resultStr = [methodStr stringByReplacingOccurrencesOfString:prefixStr withString:@""];
    }];
    return [resultStr substringToIndex:resultStr.length-1];
}

/**
 [regex enumerateMatchesInString:randmomMethod options:NSMatchingReportCompletion range:NSMakeRange(0, [randmomMethod length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
         if (errorPattern) {
             NSLog(@"import格式匹配出错：%@", errorPattern);
             return;
         }

         if (result) {
             [rangesArr addObject:NSStringFromRange(result.range)];
             NSString *paramClassStr = [randmomMethod substringWithRange:result.range];
             CXParamEntity *param = [[CXParamEntity alloc] init];

             if (![paramClassStr containsString:@"*"]) {
                 // 基本数据类型
                 param.className = [paramClassStr substringWithRange:NSMakeRange(2, paramClassStr.length-3)];
                 param.isObjectType = NO;
             } else {
                 // 对象类型
                 param.className = [paramClassStr substringWithRange:NSMakeRange(2, paramClassStr.length-4)];
                 param.isObjectType = YES;
             }
             [paramsArr addObject:param];
         }
 }];
 */


@end
