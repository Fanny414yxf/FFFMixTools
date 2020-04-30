//
//  NSString+CXMixture.h
//  SDKMixTools
//
//  Created by chr on 2020/4/2.
//  Copyright © 2020 chr. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CXMixture)

/// 将字符串按照大写字母拆分成单词数组
- (NSMutableArray <NSString *>*)cx_componentsSeperatedByFirstCapitalizedLetter;

/// 将字符串按照大写字母拆分成单词后，获取后 count 个组成的数组
/// @param count 单词个数
- (NSMutableArray <NSString *>*)cx_componentsSeperatedByFirstCapitalizedLetterWithReverseWordsCount:(NSInteger)count;

/// 获取字符串中最后 count 个单词组成的小驼峰字符串
/// @param count 单词个数
- (NSString *)cx_stringWithReversedFirstCapitalizedLetterComponentsCount:(NSInteger)count;

/// 删除末尾 count 个字符
/// @param count 字符个数
- (NSString *)cx_stringByDeletingTrailingCharactersWithCount:(NSInteger)count;

/// 检测目标字符串（firstSeg）在 源字符串（sourceStr）中的位置是否处于字符串常量内
/// @param sourceStr 目标字符串
/// @param firstSeg firstSeg description 源字符串
+ (NSArray <NSTextCheckingResult *>*)cx_constStringsRangeArrWithSourceString:(NSString *)sourceStr methodFirstSeg:(NSString *)firstSeg;

/// 获取目标数组中包含自身的文件名，避免在全局替换时将文件名替换掉
/// @param fileNamesArr 目标数组
- (NSMutableArray <NSString *>*)cx_fetchExludeHeaderFilesInFileNamesArray:(NSArray <NSString *>*)fileNamesArr;

/// 是否包含条件编译的内容
- (BOOL)cx_hasConditionCompiles;

- (void)cx_writeToFile:(NSString *)filePath;

- (BOOL)cx_hasMultiClasses;

- (NSString *)cx_capitalizedString;

//note：后续添加方法调用时应排除第一个方法，避免随机到第一个方法时会报错（第一个不是方法）
/// 检测方法自身包含的方法实现，放入数组后返回
- (NSArray <NSString *>*)cx_detectMethodsImplementations;

+ (NSString *)cx_fileDataStrAtPath:(NSString *)filePath;

/// 根据头文件路径查找m文件的路径
/// @param filePath 头文件路径
/// @param rootPath 根目录
+ (void)cx_implementationFilePathWithHeaderFilePath:(NSString *)filePath
                                             rootFilePath:(NSString *)rootPath
                                               pathResult:(NSString **)resultpath;

@end

NS_ASSUME_NONNULL_END
