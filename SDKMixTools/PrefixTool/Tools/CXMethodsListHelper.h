//
//  CXMethodsListHelper.h
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//
//  主要用户处理文件内方法列表的操作

#import <Foundation/Foundation.h>
#import "CXConfuseConsts.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXMethodsListHelper : NSObject

/// 获取指定的.h文件的方法列表
/// @param filePath 传入的头文件
+ (NSArray <NSString *>*)cx_methodsArrayForHeaderFile:(NSString *)filePath;

/// 根据方法名的字符串找出方法的第一段字符串
/// @param methodStr 方法名字符串
+ (NSString *)cx_truncateMethodFirstSegmentWithMethodString:(NSString *)methodStr;

+ (NSArray <NSString *>*)cx_methodsArrayForImplemetationFilePath:(NSString *)filePath;

+ (NSArray <NSString *>*)cx_methodsArrayWithImplementationFileDataStr:(NSString *)fileDataStr;

@end

NS_ASSUME_NONNULL_END
