//
//  NSString+CXMixture.m
//  SDKMixTools
//
//  Created by chr on 2020/4/2.
//  Copyright © 2020 chr. All rights reserved.
//

#import "NSString+CXMixture.h"
#import "NSArray+CXMixture.h"
#import "CXConfuseConsts.h"
#import "CXRegularExpressionHelper.h"


@implementation NSString (CXMixture)

- (NSMutableArray<NSString *> *)cx_componentsSeperatedByFirstCapitalizedLetter {
    NSMutableArray <NSString *>*resultArr = [NSMutableArray array];
    __block NSInteger count = 0;
    [CXRegularExpressionHelper cx_regularExpressionWithPatetrn:@"[A-Z][a-z]+" options:NSRegularExpressionAllowCommentsAndWhitespace sourceString:self usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (count == 0) {
            [resultArr addObject:[self substringToIndex:result.range.location]];
        }
        [resultArr addObject:[[self substringWithRange:result.range] lowercaseString]];
        count++;
    }];
    return resultArr;
}

- (NSArray<NSString *> *)cx_componentsSeperatedByFirstCapitalizedLetterWithReverseWordsCount:(NSInteger)count {
    NSMutableArray<NSString *> * results = [self cx_componentsSeperatedByFirstCapitalizedLetter];
    NSInteger totalCount = results.count;
    if (totalCount <= count)  return results;
    
    for (int i=0; i< totalCount-count; i++) {
        [results removeObjectAtIndex:0];
    }
    return results;
}

- (NSString *)cx_stringWithReversedFirstCapitalizedLetterComponentsCount:(NSInteger)count {
    NSMutableArray<NSString *> * results = [self cx_componentsSeperatedByFirstCapitalizedLetterWithReverseWordsCount:count];
    if (results.count < count) return self.lowercaseString;
    
    return [results cx_lowerCamelCaseString];
}

- (NSString *)cx_stringByDeletingTrailingCharactersWithCount:(NSInteger)count {
    return [self substringToIndex:self.length-count];
}

- (NSString *)cx_capitalizedString {
    if (self.length == 0) return @"";
    
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] capitalizedString]];
}

- (void)cx_writeToFile:(NSString *)filePath {
    NSError *errorWritten = nil;
    [self writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&errorWritten];
    if (errorWritten) {
        NSLog(@"fatal error：写入文件失败:\n\t文件名:%@ ", [filePath lastPathComponent]);
    } else {
        NSLog(@"写入文件成功:\n\t文件名:%@", [filePath lastPathComponent]);
    }
}

- (BOOL)cx_hasMultiClasses {
    __block NSInteger count = 0;
    [CXRegularExpressionHelper cx_regularExpressionWithPatetrn:@"@implementation" sourceString:self usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        count++;
    }];
    return count>1;
}

//todo ？
/// 检测目标字符串（firstSeg）在 源字符串（sourceStr）中的位置是否处于字符串常量内
/// @param sourceStr 目标字符串
/// @param firstSeg firstSeg description 源字符串
+ (NSArray <NSTextCheckingResult *>*)cx_constStringsRangeArrWithSourceString:(NSString *)sourceStr methodFirstSeg:(NSString *)firstSeg {
    NSMutableArray <NSTextCheckingResult *>*resultsArr = [NSMutableArray array];
    NSString *pattern = [NSString stringWithFormat:@"%@%@%@", CXConstStringFormatBeginPattern, firstSeg, CXConstStringFormatEndPattern];
    [CXRegularExpressionHelper cx_regularExpressionWithPatetrn:pattern sourceString:sourceStr usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [resultsArr addObject:result];
    }];
    return resultsArr;
}

/// 获取目标数组中包含自身的文件名，避免在全局替换时将文件名替换掉
/// @param fileNamesArr 目标数组
- (NSMutableArray <NSString *>*)cx_fetchExludeHeaderFilesInFileNamesArray:(NSArray <NSString *>*)fileNamesArr {
    NSMutableArray *excludeArr = [NSMutableArray array];
    [fileNamesArr enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fileName = obj.lastPathComponent;
        fileName = [fileName cx_stringByDeletingTrailingCharactersWithCount:2];
        if ([fileName.lowercaseString containsString:self.lowercaseString]) {
            [excludeArr addObject:fileName];
        }
    }];
    return excludeArr;
}

/// 是否包含条件编译的内容
- (BOOL)cx_hasConditionCompiles {
    return [self containsString:@"#endif"];
}


//note：后续添加方法调用时应排除第一个方法，避免随机到第一个方法时会报错（第一个不是方法）
- (NSArray <NSString *>*)cx_detectMethodsImplementations {
    
    NSString *methodBeginsPattern = CXMethodsPrefixPattern;
    __block NSError *errorPattern = nil;
    
    NSMutableArray <NSTextCheckingResult *>*resultsArr = [NSMutableArray array];
    NSMutableArray <NSString *>*methodsArr = [NSMutableArray array];
    
    // 匹配前缀
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:methodBeginsPattern options:NSRegularExpressionCaseInsensitive error:&errorPattern];
    NSString *singleImp = self;
    [regex enumerateMatchesInString:singleImp options:NSMatchingReportCompletion range:NSMakeRange(0, [singleImp length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (errorPattern) {
                NSLog(@"方法格式匹配出错：%@", errorPattern);
            }
            if (result) {
//                NSString *prefixStr = [singleImp substringWithRange:result.range];
//                NSLog(@"%@:%@", prefixStr, NSStringFromRange(result.range));
                [resultsArr addObject:result];
            }
    }];
    
    // rangesArr 保存除去首尾之外的所有方法的起始位置的range值
    NSMutableArray <NSString *>*rangesArr = [NSMutableArray arrayWithCapacity:resultsArr.count];
    
    if (resultsArr.count == 0) {
        return methodsArr;
    }
    [rangesArr addObject:NSStringFromRange(resultsArr[0].range)];
    
    NSInteger resultsCount = resultsArr.count;
    for (int i=0; i<resultsCount-1; i++) {
        NSTextCheckingResult *currentResult = resultsArr[i];
        NSTextCheckingResult *nextResult = resultsArr[i+1];
        NSUInteger currentLoc = currentResult.range.location;
        NSUInteger nextLoc = nextResult.range.location;
        NSString *currentMethod = [singleImp substringWithRange:NSMakeRange(currentLoc, nextLoc - currentLoc)];
        NSRange endRange = [currentMethod rangeOfString:@"}" options:NSBackwardsSearch];
        if (endRange.location != NSNotFound) {
            NSRange range = NSMakeRange(currentResult.range.location + endRange.location + 1, nextResult.range.length);
            [rangesArr addObject:NSStringFromRange(range)];
        }
    }
    
    __block NSInteger location = 0;
    [rangesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull rangeStr, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = NSRangeFromString(rangeStr);
        NSString *method = [singleImp substringWithRange:NSMakeRange(location, range.location - location)];
        [methodsArr addObject:method];
        location += method.length;
        if (idx == rangesArr.count-1) {
            NSString *lastMethod = [singleImp substringFromIndex:location];
            [methodsArr addObject:lastMethod];
        }
    }];
    
    NSLog(@"方法体列表：%@", methodsArr);
    return methodsArr;
}

+ (NSString *)cx_fileDataStrAtPath:(NSString *)filePath {
    NSError *error = nil;
    NSString *fileDataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    return fileDataStr;
}

+ (void)cx_implementationFilePathWithHeaderFilePath:(NSString *)filePath
                                             rootFilePath:(NSString *)rootPath
                                               pathResult:(NSString **)resultpath {
    NSString *destinationFile = [NSString stringWithFormat:@"%@.m", [filePath.lastPathComponent cx_stringByDeletingTrailingCharactersWithCount:2]];
    NSString *destinationFileCPP = [NSString stringWithFormat:@"%@.mm", [filePath.lastPathComponent cx_stringByDeletingTrailingCharactersWithCount:2]];
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:&isDir];
    if (!isExist) return;
    if(*resultpath) return;
    
    if (isDir) {
        NSLog(@"开始在 %@ 下寻找 %@ 或者 %@ 路径", rootPath.lastPathComponent, destinationFile, destinationFileCPP);
        NSArray * dirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:rootPath error:nil];
        NSString * subPath = nil;
        for (NSString * str in dirArray) {
            subPath  = [rootPath stringByAppendingPathComponent:str];
            [self cx_implementationFilePathWithHeaderFilePath:filePath rootFilePath:subPath pathResult:resultpath];
        }
    } else {
        NSLog(@"当前文件: %@ --- 寻找文件: %@ 或者 %@", rootPath.lastPathComponent, destinationFile, destinationFileCPP);
        if ([rootPath.lastPathComponent isEqualToString:destinationFile] || [rootPath.lastPathComponent isEqualToString:destinationFileCPP]) {
            NSLog(@"===============找到  %@ 或者 %@  文件", destinationFile, destinationFileCPP);
            *resultpath = rootPath;
        }
    }
}

@end
