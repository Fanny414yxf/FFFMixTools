//
//  CXMethodGenerator.h
//  SDKMixTools
//
//  Created by chr on 2020/3/17.
//  Copyright © 2020 chr. All rights reserved.
//
//  动态方法生成器：旨在实现在现有类中动态添加随机方法，并实现方法调用用以更改类中的函数调用栈

#import <Foundation/Foundation.h>
#import "CXConfuseConsts.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 过程分析：
 * 1、定位到 h 文件，随机生成一组带随机前缀的方法签名；（容易实现）
 * 2、如何定位到对应的 m 文件？在 m 文件生成对应的方法体 （可能存在难度）
 * 3、如何处理一个文件包含多个类的情况？确保不出现错乱 （难度较大）
 * 4、在合适的位置调用生成的方法
 */

@interface CXMethodGenerator : NSObject
+ (__kindof CXMethodGenerator *)sharedInstance;

#pragma mark - 打乱方法顺序
/// 清除缓存的信息，以便重新为新的类生成方法，切换类之后务必调用该方法
- (void)cx_clean;

/// 打乱文件中方法的顺序
/// @param filePath 文件路径
- (void)cx_confuseMethodsWithFilePath:(NSString *)filePath;

#pragma mark - 调用已有文件的方法
/// 生成自动调用脚本生成的垃圾文件的方法的字符串（文件中只包含一个类，不存在多个类的情况）
/// @param rootPath 要添加方法调用的文件路径（会被递归遍历）
- (void)cx_invokeRandomMothodInRandomFileAtRootFilePath:(NSString *)rootPath
                                      ignoredClassNames:(NSArray <NSString *>*)ignoredClassNames;

/// @param importedStr importe字符串
- (NSString *)cx_generateRandomMethodInvokedStringForHeaderFileImportedString:(NSString *)importedStr;

#pragma mark - 自动生成方法并调用

/// 在指定的f文件中生成无关方法，并在本类中进行调用
/// @param rootPath 文件路径
/// @param ignoredClassNames 忽略的文件名列表
/// @param headersArr rootPath下所有头文件列表
- (void)cx_autoGenerateMethodsAndInvokingAtRootPath:(NSString *)rootPath
                                  ignoredClassNames:(NSArray<NSString *> *)ignoredClassNames
                                        headerFiles:(NSArray *)headersArr;
@end

NS_ASSUME_NONNULL_END
