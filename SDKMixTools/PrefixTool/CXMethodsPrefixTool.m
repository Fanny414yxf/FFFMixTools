//
//  CXMethodsPrefixTool.m
//  SDKMixTools
//
//  Created by chr on 2020/3/16.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXNethodsMixtueTool.h"
#import "NSString+CXMixture.h"
#import "CXMethodGenerator.h"
#import "CXPropertyHelper.h"
#import "CXMethodsListHelper.h"
#import "CXRegularExpressionHelper.h"

#define CXFileManager [NSFileManager defaultManager]
static NSMutableArray *CXHeaderFilesArr;
static NSMutableArray <NSString *>*ignoredMethodFilters;        // 内置的一些默认的忽略方法
static NSMutableArray <NSString *>*defaultIgnoredHeaderFiles;   // 内置的一些默认的忽略文件
static NSMutableArray <NSString *>*defaultPrefixes;   // 内置的一些默认的忽略文件

static NSMutableArray <NSString *>*ignoredPropertyFilters;        // 内置的一些默认的忽略方法
static NSMutableArray <NSString *>*defaultPropertyIgnoredHeaderFiles;   // 内置的一些默认的忽略文件
static NSMutableArray <NSString *>*defaultPropertyPrefixes;   // 内置的一些默认的忽略文件
@interface CXNethodsMixtueTool ()

@end
@implementation CXNethodsMixtueTool
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-escape-sequence"
#pragma mark - 添加方法前缀
#pragma mark public
/// 给指定目录下的所有类添加随机方法前缀，简单起见，初步让每个类的方法前缀保持一致
/// @param rootPath 需要添加方法前缀的目录
/// @param prefixes 传入的方法前缀列表，若为空则使用默认的前缀列表
/// @param ignoredClassNames 需要忽略的类名列表
/// @param ignoredBegins 需要忽略的方法列表（只需要方法的第一段字符串），初步用于避免多个方法的第一段字符串相同的情况
+ (void)cx_addMethodsPrefixesForClassesAtPath:(NSString *)rootPath
                                prefixesArray:(NSArray<NSString *> *)prefixes
                            ignoredClassNames:(NSArray<NSString *> *)ignoredClassNames
                     ignoredMethodsBeginWords:(NSArray<NSString *> *)ignoredBegins {
    
    if (CXHeaderFilesArr == nil) {
        CXHeaderFilesArr = [NSMutableArray array];
    }
    
    if (defaultPrefixes == nil) {
#warning YL:此处为默认的类名前缀，可以清空，从调用处传入新的前缀数组，或者修改此处
        defaultPrefixes = [@[] mutableCopy];
    }
    
//    NSAssert(ignoredClassNames.count, @"Fatal error:请传入前缀数组!");
    
    [self cx_concatSourceArray:prefixes toDestinationArray:defaultPrefixes];
    
    if (ignoredMethodFilters == nil) {
        // 主要是排除系统自带api，避免冲突导致报错
        //@"will", @"did", @"enableDebug", @"scrollView", @"textField", @"tableView" etc..
        ignoredMethodFilters = [@[@"init", @"load", @"viewDidLoad", @"viewWillAppear", @"viewDidAppear",
                                  @"viewWillDisappear", @"viewDidDisappear", @"layoutSubviews", @"test", 
                                  @"instancetype", @"instance", @"addTarget", @"setValue", @"md5", @"is",
                                  @"addAttribute", @"bindPhone", @"value", @"set", @"clear", @"topCap",
                                  @"top", @"left", @"bottom", @"right", @"pop", @"push", @"base64", @"string",
                                  @"date", @"show", @"button", @"valid", @"invalid", @"addButtonWithTitle",
                                  @"textFieldAtIndex", @"finish", @"hide", @"enable", @"log", @"get",
                                  @"reset", @"with", @"send", @"will", @"did", @"shared", @"regist"] mutableCopy];
        //, @"prase", @"save", @"regist", @"check",
    }
    [self cx_concatSourceArray:ignoredBegins toDestinationArray:ignoredMethodFilters];
    
    if (defaultIgnoredHeaderFiles == nil) {
        defaultIgnoredHeaderFiles = [@[ @"CXHelperFunc.h",
                                        @"CXGameDelegate.h",
                                        @"CXGamePrivateProxy.h"] mutableCopy];
    }
    [self cx_concatSourceArray:ignoredClassNames toDestinationArray:defaultIgnoredHeaderFiles];
    
    // 获取所有的头文件路径
    if (CXHeaderFilesArr.count == 0) {
        NSLog(@"开始获取所有头文件");
        [self cx_fetchAllHeaderFilesAtPath:rootPath];
        NSLog(@"获取所有头文件完毕");
    }
    NSLog(@"所有的头文件：\n%@", CXHeaderFilesArr);
    
    // 遍历所有头文件
    [CXHeaderFilesArr enumerateObjectsUsingBlock:^(NSString *_Nonnull headerFile, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fileName = [headerFile lastPathComponent];
        if (![defaultIgnoredHeaderFiles containsObject:fileName]) {
            //获取文件夹下的所有方法
            NSArray <NSString *>*methodsList = [CXMethodsListHelper cx_methodsArrayForHeaderFile:headerFile];
            
//            NSLog(@"methodsList = \n%@", methodsList);
            [methodsList enumerateObjectsUsingBlock:^(NSString * _Nonnull someMethod, NSUInteger idx, BOOL * _Nonnull stop) {
                // 判断是否需要忽略该方法
                NSString *methodSegFirst = [CXMethodsListHelper cx_truncateMethodFirstSegmentWithMethodString:someMethod];
                
                // 判断是否需要忽略该方法
                BOOL shouldAddPrefix = ![self cx_addedPrefixAlready:someMethod];
                
                __block BOOL shouldIgnore = NO;
                [ignoredMethodFilters enumerateObjectsUsingBlock:^(NSString * _Nonnull filter, NSUInteger idx, BOOL * _Nonnull stop) {
#warning YL: 过滤忽略方法优化
                    // 之前出于担心iOS方法交换导致系统方法在方法交换后无法被调用，所以判断是否被添加忽略时使用了 contain 策略，经过对SDK的方法交换使用的排查，现改回为判断是否以 忽略字符串 开头进行忽略判断
                    if ([methodSegFirst hasPrefix:filter]) {//[someMethod containsString:filter]
                        shouldIgnore = YES;
                        *stop = YES;
                    }
                }];
                
                // 不在忽略名单内 且 没有添加前缀
                if (!shouldIgnore && shouldAddPrefix) {
                    // 遍历所有文件，替换该方法的第一段
                    NSInteger index = arc4random_uniform((uint32_t)(defaultPrefixes.count));
                    NSString *prefixStr = defaultPrefixes[index];
                    NSString *replacedStr = [NSString stringWithFormat:@"%@%@", prefixStr, methodSegFirst];
                    
                    // 全局替换
                    [self cx_relpaceMethodsInAllFilesAtPath:rootPath originalMethodFirstSegment:methodSegFirst replacedMethodSegment:replacedStr];
                }
            }];
        }
    }];
}

/// 给指定目录下的所有类头文件中的属性添加随机前缀
/// @param rootPath 需要添加属性前缀的目录
/// @param prefixes 传入的属性前缀列表，若为空则使用默认的前缀列表
/// @param ignoredClassNames  需要忽略的类名列表
/// @param ignoredPropertyBegins 需要忽略的属性列表（或者属性前缀）
+ (void)cx_addPropertyPrefixesForPropertiesAtPath:(NSString *)rootPath
                                    prefixesArray:(NSArray<NSString *> *)prefixes
                                ignoredClassNames:(NSArray<NSString *> *)ignoredClassNames
                         ignoredMethodsBeginWords:(NSArray<NSString *> *)ignoredPropertyBegins {
                                 
    if (CXHeaderFilesArr == nil) {
        CXHeaderFilesArr = [NSMutableArray array];
    }
    
    if (defaultPropertyPrefixes == nil) {
        defaultPropertyPrefixes = [@[] mutableCopy];
    }
    
    [self cx_concatSourceArray:prefixes toDestinationArray:defaultPropertyPrefixes];
    NSAssert(defaultPropertyPrefixes.count, @"Fatal error:请传入属性前缀数组!");
    
    if (ignoredPropertyFilters == nil) {
        // 主要是排除系统自带属性，避免冲突导致报错
        /**
         * iOS系统定义的 utsname文件中有定义 uname 函数
         * CXUtils -> getDeviceMachineName -> struct utsname systemInfo; uname(&systemInfo);
         */
        ignoredPropertyFilters = [@[
                                    @"queue", @"code", @"userInfo", @"border", @"title", @"size", @"width",
                                    @"error", @"location", @"options", @"serverId", @"color", @"count",
                                    @"timer", @"format", @"info", @"servers", @"time", @"msg", @"session",
                                    @"transaction", @"contentView", @"alertViewStyle", @"productId",
                                    @"handler", @"rmbFen", @"roleName", @"roleLevel", @"roleId",
                                    @"serverId", @"serverName", @"uid", @"vipLevel", @"productCount",
                                    @"productName", @"accountId", @"region", @"account", @"itemName",
                                    @"itemId", @"amount", @"callBackInfo", @"detail", @"itemCount", @"level",
                                    @"vipLevel", @"p_OrderId", @"uname"]mutableCopy];
    }
    [self cx_concatSourceArray:ignoredPropertyBegins toDestinationArray:ignoredPropertyFilters];
    
    if (defaultPropertyIgnoredHeaderFiles == nil) {
        defaultPropertyIgnoredHeaderFiles = [@[@"CXProgressHUD.h", @"CXProgressHUD.h"] mutableCopy];
    }
    [self cx_concatSourceArray:ignoredClassNames toDestinationArray:defaultPropertyIgnoredHeaderFiles];
    
    // 获取所有的头文件路径
    if (CXHeaderFilesArr.count == 0) {
        NSLog(@"开始获取所有头文件");
        [self cx_fetchAllHeaderFilesAtPath:rootPath];
        NSLog(@"获取所有头文件完毕");
    }
    NSLog(@"所有的头文件：\n%@", CXHeaderFilesArr);
    
    // 遍历所有头文件
    [CXHeaderFilesArr enumerateObjectsUsingBlock:^(NSString *_Nonnull headerFile, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *fileName = [headerFile lastPathComponent];
        if (![defaultPropertyIgnoredHeaderFiles containsObject:fileName]) {
            
            NSArray <NSString *>*propertyList = [CXPropertyHelper cx_propertyListForHeaderFilePath:headerFile];
//            NSLog(@"propertyList = \n%@", propertyList);
            
            [propertyList enumerateObjectsUsingBlock:^(NSString * _Nonnull someProperty, NSUInteger idx, BOOL *_Nonnull stop) {
                someProperty = [CXPropertyHelper cx_truncatePropertyNameWithPropertyStr:someProperty];
                
                // 判断是否已经添加了前缀
                // 没有添加前缀 - YES 已添加 - NO
                BOOL shouldAddPrefix = ![self cx_propertyAddedPrefixAlready:someProperty];
                
                // 判断是否在忽略列表
                __block BOOL shouldIgnore = NO;
                [ignoredPropertyFilters enumerateObjectsUsingBlock:^(NSString * _Nonnull filter, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([someProperty hasPrefix:filter]) {//[someMethod containsString:filter]
                        shouldIgnore = YES;
                        *stop = YES;
                    }
                }];
                
                // 不在忽略名单内 且 没有添加前缀
                if (!shouldIgnore && shouldAddPrefix) {
                    // 遍历所有文件，替换该方法的第一段
                    NSInteger index = arc4random_uniform((uint32_t)(defaultPropertyPrefixes.count));
                    NSString *prefixStr = defaultPropertyPrefixes[index];
                    NSString *replacedPropertyStr = [NSString stringWithFormat:@"%@%@", prefixStr, someProperty];
                    
                    // 全局替换
                    // 替换属性本身
                    [self cx_relpacePropertiesInAllFilesAtPath:rootPath originalMethodFirstSegment:someProperty replacedMethodSegment:replacedPropertyStr];
                    
                    // 替换 setters
                    NSString *setterMethod = [NSString stringWithFormat:@"set%@", someProperty.cx_capitalizedString];
                    NSString *replacedSetterMethod = [NSString stringWithFormat:@"set%@", replacedPropertyStr.cx_capitalizedString];
                    NSString *memberString = [NSString stringWithFormat:@"_%@", someProperty];
                    NSString *replacedMemberString = [NSString stringWithFormat:@"_%@", replacedPropertyStr];
                    
                    [self cx_relpacePropertiesSetterMethodsInAllFilesAtPath:rootPath originalMethodFirstSegment:setterMethod replacedMethodSegment:replacedSetterMethod];
                    
                    [self cx_relpacePropertiesSetterMethodsInAllFilesAtPath:rootPath originalMethodFirstSegment:memberString replacedMethodSegment:replacedMemberString];
                }
            }];
        }
    }];
}

#pragma mark private

+ (void)cx_concatSourceArray:(NSArray *)sourceArr toDestinationArray:(NSMutableArray *)destArr {
    if (sourceArr.count == 0) return;
    [sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![destArr containsObject:obj]) {
            [destArr addObject:obj];
        }
    }];
}

/// 递归获取指定目录下的所有.h文件路径
/// @param path 指定目录
+ (void)cx_fetchAllHeaderFilesAtPath:(NSString *)path {
    BOOL isDir = NO;
    BOOL isExist = [CXFileManager fileExistsAtPath:path isDirectory:&isDir];
    // 文件或者目录不存在，返回空数组
    if (!isExist) return;
    
    // 目录存在
    if (isDir) {
        NSArray * dirArray = [CXFileManager contentsOfDirectoryAtPath:path error:nil];
        NSString * subPath = nil;
        for (NSString * str in dirArray) {
            subPath  = [path stringByAppendingPathComponent:str];
            
            [self cx_fetchAllHeaderFilesAtPath:subPath];
        }
    }else{
        NSString *fileName = [path lastPathComponent];
        if ([fileName hasSuffix:@".h"]) {
            [CXHeaderFilesArr addObject:path];
        }
    }
}

/// 替换指定目录下所有文件的方法
/// @param filePath 文件目录
/// @param firstSeg 方法首段
/// @param replacedSeg 方法前缀+方法首段
+ (void)cx_relpaceMethodsInAllFilesAtPath:(NSString *)filePath
               originalMethodFirstSegment:(NSString *)firstSeg
                    replacedMethodSegment:(NSString *)replacedSeg {
    
    BOOL isDir = NO;
    BOOL isExist = [CXFileManager fileExistsAtPath:filePath isDirectory:&isDir];
    // 文件或者目录不存在，返回空数组
    if (!isExist) return;
    
    // 目录存在
    if (isDir) {
        NSArray * dirArray = [CXFileManager contentsOfDirectoryAtPath:filePath error:nil];
        NSString * subPath = nil;
        for (NSString * str in dirArray) {
            subPath  = [filePath stringByAppendingPathComponent:str];
            [self cx_relpaceMethodsInAllFilesAtPath:subPath originalMethodFirstSegment:firstSeg replacedMethodSegment:replacedSeg];
        }
    }else{
        // 是 .h 或者 .m 文件
        if ([filePath.lastPathComponent hasSuffix:@".h"] || [filePath.lastPathComponent hasSuffix:@".m"] || [filePath.lastPathComponent hasSuffix:@".mm"]) {
            NSError *error = nil;
            NSString *fileDataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            
            // 需要替换
            if ([self cx_whetherShouldAddPrefixStringWithContentString:fileDataStr methodFirstSeg:firstSeg]) {
                NSArray <NSTextCheckingResult *>*constStrArr = [NSString cx_constStringsRangeArrWithSourceString:fileDataStr methodFirstSeg:firstSeg];
                //todo ？
                NSMutableArray <NSString *>*rangesArr = [NSMutableArray array];
                [CXRegularExpressionHelper cx_regularExpressionWithPatetrn:[NSString stringWithFormat:@"\\b%@\\b", firstSeg] options:NSRegularExpressionDotMatchesLineSeparators sourceString:fileDataStr usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    NSRange preRange = NSMakeRange(result.range.location - CXRandomMethodsPrefixMaxLength, CXRandomMethodsPrefixMaxLength);
                    NSString *preRangeStr = [fileDataStr substringWithRange:preRange];
                    // 排除字符串常量中的内容 例如拼接的参数字段、定义的key etc...
                    BOOL insideConstStr = [self cx_someRange:result.range includedInRangesArr:constStrArr];
                    // 前面的字符不是给定的随机前缀，排除类名，避免修改到类名
                    if (![self cx_addedPrefixAlready:preRangeStr] && !insideConstStr) {
                        [rangesArr addObject:NSStringFromRange(result.range)];
                    }
                }];

                // 4、反向替换掉需要添加前缀的位置
                NSInteger count = rangesArr.count;
                if (count) {
                    for (int i=0; i<count; i++) {
                        NSRange lastRange = NSRangeFromString(rangesArr[count-i-1]);
                        fileDataStr = [fileDataStr stringByReplacingCharactersInRange:lastRange withString:replacedSeg];
                    }
                }
                
                
                NSError *errorWritten = nil;
                [fileDataStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&errorWritten];
                if (errorWritten) {
                    NSLog(@"fatal error：方法替换后写入文件失败:\n\t文件名:%@ - 方法名:%@ - 替换后的方法名:%@", [filePath lastPathComponent], firstSeg, replacedSeg);
                } else {
                    NSLog(@"方法替换成功:\n\t文件名:%@ - 方法名:%@ - 替换后的方法名:%@", [filePath lastPathComponent], firstSeg, replacedSeg);
                }
            }
        }
        
    }
}

/// 替换指定目录下符合条件的所有属性
/// @param filePath 文件目录
/// @param propertyName 属性名称
/// @param replacedPropertyName 方法前缀+方法首段
+ (void)cx_relpacePropertiesInAllFilesAtPath:(NSString *)filePath
               originalMethodFirstSegment:(NSString *)propertyName
                    replacedMethodSegment:(NSString *)replacedPropertyName {
    
    BOOL isDir = NO;
    BOOL isExist = [CXFileManager fileExistsAtPath:filePath isDirectory:&isDir];
    // 文件或者目录不存在，返回空数组
    if (!isExist) return;
    
    // 目录存在
    if (isDir) {
        NSArray * dirArray = [CXFileManager contentsOfDirectoryAtPath:filePath error:nil];
        NSString * subPath = nil;
        for (NSString * str in dirArray) {
            subPath  = [filePath stringByAppendingPathComponent:str];
            [self cx_relpacePropertiesInAllFilesAtPath:subPath originalMethodFirstSegment:propertyName replacedMethodSegment:replacedPropertyName];
        }
    }else{
        // 是 .h 或者 .m 文件
        if ([filePath.lastPathComponent hasSuffix:@".h"] || [filePath.lastPathComponent hasSuffix:@".m"] || [filePath.lastPathComponent hasSuffix:@".mm"]) {
            NSError *error = nil;
            NSString *fileDataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            
            // 需要替换
            if ([self cx_whetherShouldAddPrefixStringWithContentString:fileDataStr methodFirstSeg:propertyName]) {
                NSArray <NSTextCheckingResult *>*constStrArr = [NSString cx_constStringsRangeArrWithSourceString:fileDataStr methodFirstSeg:propertyName];
                
                NSMutableArray <NSString *>*rangesArr = [NSMutableArray array];
                [CXRegularExpressionHelper cx_regularExpressionWithPatetrn:[NSString stringWithFormat:@"\\b%@\\b", propertyName] options:NSRegularExpressionDotMatchesLineSeparators sourceString:fileDataStr usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    NSRange preRange = NSMakeRange(result.range.location - CXRandomMethodsPrefixMaxLength, CXRandomMethodsPrefixMaxLength);
                    NSString *preRangeStr = [fileDataStr substringWithRange:preRange];
                    // 排除字符串常量中的内容 例如拼接的参数字段、定义的key etc...
                    BOOL insideConstStr = [self cx_someRange:result.range includedInRangesArr:constStrArr];
                    // 前面的字符不是给定的随机前缀，排除类名，避免修改到类名
                    if (![self cx_addedPrefixAlready:preRangeStr] && !insideConstStr) {
                        [rangesArr addObject:NSStringFromRange(result.range)];
                    }
                }];

                // 4、反向替换掉需要添加前缀的位置
                NSInteger count = rangesArr.count;
                if (count) {
                    for (int i=0; i<count; i++) {
                        NSRange lastRange = NSRangeFromString(rangesArr[count-i-1]);
//                        NSRange preRange = NSMakeRange(lastRange.location - 3, 3);
//                        NSString *preRangeStr = [fileDataStr substringWithRange:preRange];
//                        BOOL isSetter = [preRangeStr isEqualToString:@"set"];
                        fileDataStr = [fileDataStr stringByReplacingCharactersInRange:lastRange withString:replacedPropertyName];
                    }
                }
                
                
                NSError *errorWritten = nil;
                [fileDataStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&errorWritten];
                if (errorWritten) {
                    NSLog(@"fatal error：方法替换后写入文件失败:\n\t文件名:%@ - 方法名:%@ - 替换后的方法名:%@", [filePath lastPathComponent], propertyName, replacedPropertyName);
                } else {
                    NSLog(@"方法替换成功:\n\t文件名:%@ - 方法名:%@ - 替换后的方法名:%@", [filePath lastPathComponent], propertyName, replacedPropertyName);
                }
            }
        }
        
    }
}

/// 替换指定目录下符合条件的所有属性
/// @param filePath 文件目录
/// @param setterName set方法名称
/// @param replacedSetterName 带前缀的 set 方法名称
+ (void)cx_relpacePropertiesSetterMethodsInAllFilesAtPath:(NSString *)filePath
               originalMethodFirstSegment:(NSString *)setterName
                    replacedMethodSegment:(NSString *)replacedSetterName {
    
    BOOL isDir = NO;
    BOOL isExist = [CXFileManager fileExistsAtPath:filePath isDirectory:&isDir];
    // 文件或者目录不存在，返回空数组
    if (!isExist) return;
    
    // 目录存在
    if (isDir) {
        NSArray * dirArray = [CXFileManager contentsOfDirectoryAtPath:filePath error:nil];
        NSString * subPath = nil;
        for (NSString * str in dirArray) {
            subPath  = [filePath stringByAppendingPathComponent:str];
            [self cx_relpacePropertiesSetterMethodsInAllFilesAtPath:subPath originalMethodFirstSegment:setterName replacedMethodSegment:replacedSetterName];
        }
    }else{
        // 是 .h 或者 .m 文件
        if ([filePath.lastPathComponent hasSuffix:@".h"] || [filePath.lastPathComponent hasSuffix:@".m"] || [filePath.lastPathComponent hasSuffix:@".mm"]) {
            NSError *error = nil;
            NSString *fileDataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            NSLog(@"开始替换set方法：类名:%@, setter:%@, newSetter:%@", filePath.lastPathComponent, setterName, replacedSetterName);
            // 需要替换
            if ([self cx_whetherShouldAddPrefixStringWithContentString:fileDataStr methodFirstSeg:setterName]) {
                NSArray <NSTextCheckingResult *>*constStrArr = [NSString cx_constStringsRangeArrWithSourceString:fileDataStr methodFirstSeg:setterName];
                
                NSMutableArray <NSString *>*rangesArr = [NSMutableArray array];
                [CXRegularExpressionHelper cx_regularExpressionWithPatetrn:[NSString stringWithFormat:@"\\b%@\\b", setterName] options:NSRegularExpressionDotMatchesLineSeparators sourceString:fileDataStr usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    NSRange preRange = NSMakeRange(result.range.location - CXRandomMethodsPrefixMaxLength, CXRandomMethodsPrefixMaxLength);
                    NSString *preRangeStr = [fileDataStr substringWithRange:preRange];
                    // 排除字符串常量中的内容 例如拼接的参数字段、定义的key etc...
                    BOOL insideConstStr = [self cx_someRange:result.range includedInRangesArr:constStrArr];
                    // 前面的字符不是给定的随机前缀，排除类名，避免修改到类名
                    if (![self cx_propertyAddedPrefixAlready:preRangeStr] && !insideConstStr) {
                        [rangesArr addObject:NSStringFromRange(result.range)];
                    }
                }];

                // 4、反向替换掉需要添加前缀的位置
                NSInteger count = rangesArr.count;
                
                if (count) {
                    for (int i=0; i<count; i++) {
                        NSRange lastRange = NSRangeFromString(rangesArr[count-i-1]);
//                        NSRange preRange = NSMakeRange(lastRange.location - 3, 3);
//                        NSString *preRangeStr = [fileDataStr substringWithRange:preRange];
//                        BOOL isSetter = [preRangeStr isEqualToString:@"set"];
                        fileDataStr = [fileDataStr stringByReplacingCharactersInRange:lastRange withString:replacedSetterName];
                    }
                }
                NSLog(@"替换set方法结束!替换数量：%zd", count);
                NSError *errorWritten = nil;
                [fileDataStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&errorWritten];
                if (errorWritten) {
                    NSLog(@"fatal error：方法替换后写入文件失败:\n\t文件名:%@ - 方法名:%@ - 替换后的方法名:%@", [filePath lastPathComponent], setterName, replacedSetterName);
                } else {
                    NSLog(@"方法替换成功:\n\t文件名:%@ - 方法名:%@ - 替换后的方法名:%@", [filePath lastPathComponent], setterName, replacedSetterName);
                }
            }
        }
        
    }
}


+ (BOOL)cx_someRange:(NSRange)range includedInRangesArr:(NSArray <NSTextCheckingResult *>*)rangeArr {
    __block BOOL result = NO;
    if (rangeArr.count == 0) return result;
    
    [rangeArr enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange someRange = obj.range;
        if (someRange.location<=range.location && someRange.location+someRange.length>=range.location+range.length ) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

+ (BOOL)cx_containsSomeHeaderFileName:(NSString *)str {
    __block BOOL contains = NO;
    [CXHeaderFilesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull path, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fileName = path.lastPathComponent;
        fileName = [fileName substringToIndex:fileName.length-2];
        if ([str containsString:fileName]) {
            contains = YES;
            *stop = YES;
        }
    }];
    return contains;
}

/// 判断是否需要添加了某个前缀,一旦添加了某个前缀则不再添加
/// @param fileDataStr 文件的内容
/// @param firstSeg 某个方法签名的第一段
+ (BOOL)cx_whetherShouldAddPrefixStringWithContentString:(NSString *)fileDataStr
                                          methodFirstSeg:(NSString *)firstSeg {
    // 不包含该方法
    if (![fileDataStr containsString:firstSeg]) return NO;
    
    return YES;
    __block BOOL contains = NO;
    [defaultPrefixes enumerateObjectsUsingBlock:^(NSString * _Nonnull somePrefix, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *replacedSeg = [NSString stringWithFormat:@"%@%@", somePrefix, firstSeg];
        if ([fileDataStr containsString:replacedSeg]) {
            contains = YES;
            *stop = YES;
        }
    }];
    return !contains;
}

+ (BOOL)cx_propertyAddedPrefixAlready:(NSString *)propertyStr {
    __block BOOL contains = NO;
    [defaultPropertyPrefixes enumerateObjectsUsingBlock:^(NSString * _Nonnull somePrefix, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([propertyStr containsString:somePrefix]) {
            contains = YES;
            *stop = YES;
        }
    }];
    return contains;
}

+ (BOOL)cx_addedPrefixAlready:(NSString *)str {
    __block BOOL contains = NO;
    [defaultPrefixes enumerateObjectsUsingBlock:^(NSString * _Nonnull somePrefix, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([str containsString:somePrefix]) {
            contains = YES;
            *stop = YES;
        }
    }];
    return contains;
}

#pragma mark - 打乱方法之间的顺序

/// 将指定目录下的 .h 与 .m 文件内的方法相互之间打乱顺序
/// @param rootPath 文件l目录
/// @param ignoredClassNames 忽略的类名数组
/// @param ignoredBegins 忽略的方法列表
+ (void)cx_mixUpOrdersBetweenMethodsForClassesAtPath:(NSString *)rootPath
                                   ignoredClassNames:(NSArray <NSString *>*)ignoredClassNames
                            ignoredMethodsBeginWords:(NSArray <NSString *>*)ignoredBegins  {
    // 1、遍历所有.m 文件
    BOOL isDir = NO;
    BOOL isExist = [CXFileManager fileExistsAtPath:rootPath isDirectory:&isDir];
    // 文件或者目录不存在，返回空数组
    if (!isExist) return;
    
    // 目录存在
    if (isDir) {
        NSArray * dirArray = [CXFileManager contentsOfDirectoryAtPath:rootPath error:nil];
        NSString * subPath = nil;
        for (NSString * str in dirArray) {
            subPath  = [rootPath stringByAppendingPathComponent:str];
            [self cx_mixUpOrdersBetweenMethodsForClassesAtPath:subPath ignoredClassNames:ignoredClassNames ignoredMethodsBeginWords:ignoredBegins];
        }
    }else{
        // 开始进行方法乱序
        [[CXMethodGenerator sharedInstance] cx_confuseMethodsWithFilePath:rootPath];
    }
}

#pragma mark -  自动调用已知类的方法
+ (void)cx_autoInvokeRandomMethodsWithFilePath:(NSString *)filePath
                             ignoredClassNames:(NSArray <NSString *>*)ignoredClassNames {
    [[CXMethodGenerator sharedInstance] cx_invokeRandomMothodInRandomFileAtRootFilePath:filePath ignoredClassNames:ignoredClassNames];
}

#pragma mark - 自动生成方法并调用
+ (void)cx_autoGenerateMethodsAndInvokingAtRootPath:(NSString *)rootPath
                                  ignoredClassNames:(NSArray<NSString *> *)ignoredClassNames {
    if (CXHeaderFilesArr == nil) {
        CXHeaderFilesArr = [NSMutableArray array];
    }
    
    if (CXHeaderFilesArr.count == 0) {
        [self cx_fetchAllHeaderFilesAtPath:rootPath];
    }
    
    [[CXMethodGenerator sharedInstance] cx_autoGenerateMethodsAndInvokingAtRootPath:rootPath ignoredClassNames:ignoredClassNames headerFiles:CXHeaderFilesArr];
}

#pragma mark - common


#pragma clang diagnostic pop

@end
