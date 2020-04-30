//
//  CXMethodsPrefixTool.h
//  SDKMixTools
//
//  Created by chr on 2020/3/16.
//  Copyright © 2020 chr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXNethodsMixtueTool : NSObject

/**
 * 添加方法前缀大致流程：
 * 1、本地维护一个前缀数组（可以外部传入），需要时可以随机从中获取一个方法前缀；
 * 2、根据传入的文件目录，递归遍历找出所有.h文件，放入数组中；
 * 3、遍历所有.h文件，从传入的目录下找到该.h文件，随机获取一个方法前缀，将当前文件的内容转化成字符串，获取出所有方法列表
 * 4、遍历所有文件，替换掉文件中所有出现的上述方法列表中的方法（复杂度n^2）
 */


#pragma mark - 添加方法前缀
/// 给指定目录下的所有类添加随机方法前缀
/// @param rootPath 需要添加方法前缀的目录
/// @param prefixes 传入的方法前缀列表，若为空则使用默认的前缀列表
/// @param ignoredClassNames 需要忽略的类名列表
/// @param ignoredBegins 需要忽略的方法列表（只需要方法的第一段字符串），初步用于避免多个方法的第一段字符串相同的情况
+ (void)cx_addMethodsPrefixesForClassesAtPath:(NSString *)rootPath
                                prefixesArray:(NSArray <NSString *>*)prefixes
                            ignoredClassNames:(NSArray <NSString *>*)ignoredClassNames
                     ignoredMethodsBeginWords:(NSArray <NSString *>*)ignoredBegins;

/**
大致步骤如下：
1、遍历所有头文件，获取每个文件的属性列表；
2、遍历属性列表，根据每个属性，遍历 rootPath 下所有文件，给所有用到该属性的地方加上随机前缀；
3、根据某个属性，生成器对应的setter方法的格式，遍历所有文件，将所有用到该setter方法的地方添加上随机前缀；
目前问题：部分 setter 方法在s调用处修改不成功！！！
*/

/// 给指定目录下的所有类头文件中的属性添加随机前缀
/// @param rootPath 需要添加属性前缀的目录
/// @param prefixes 传入的属性前缀列表，若为空则使用默认的前缀列表
/// @param ignoredClassNames  需要忽略的类名列表
/// @param ignoredBegins 需要忽略的属性列表（或者属性前缀）
+ (void)cx_addPropertyPrefixesForPropertiesAtPath:(NSString *)rootPath
                                prefixesArray:(NSArray <NSString *>*)prefixes
                            ignoredClassNames:(NSArray <NSString *>*)ignoredClassNames
                     ignoredMethodsBeginWords:(NSArray <NSString *>*)ignoredBegins;

#pragma mark -----------------------------------------------------------------------------------------------------
#pragma mark - 打乱方法之间的顺序
/**
 * problems：
 * 1、首先 .h 与 .m 文件可能需要分开处理（ .m 较为复杂）
 * 2、存在诸多干扰因素（注释内容、统一文件存在多个类、协议、方法体内部类型转换的干扰ect..）
 * 3、区分函数与方法？是否需要保持原有注释顺序？
 * 4、注释掉的完整方法带来的BUG
 * 5、类扩展内部的方法
 * 6、条件编译带来的问题 - 目前可以暂时先屏蔽掉带有条件编译的类（通常为第三方库，由于业务逻辑复杂可先做屏蔽处理，如若 实在需要处理的个别文件，可以手动乱序）
 * 7、...
 */

/// 将指定目录下的 .h 与 .m 文件内的方法相互之间打乱顺序
/// @param rootPath 文件l目录
/// @param ignoredClassNames 忽略的类名数组
/// @param ignoredBegins 忽略的方法列表
+ (void)cx_mixUpOrdersBetweenMethodsForClassesAtPath:(NSString *)rootPath
                                   ignoredClassNames:(NSArray <NSString *>*)ignoredClassNames
                            ignoredMethodsBeginWords:(NSArray <NSString *>*)ignoredBegins;

#pragma mark -  自动调用已知类的方法
+ (void)cx_autoInvokeRandomMethodsWithFilePath:(NSString *)filePath
                             ignoredClassNames:(NSArray <NSString *>*)ignoredClassNames;

#pragma mark - 自动生成方法并调用
+ (void)cx_autoGenerateMethodsAndInvokingAtRootPath:(NSString *)rootPath
                                  ignoredClassNames:(NSArray <NSString *>*)ignoredClassNames;

@end

NS_ASSUME_NONNULL_END
