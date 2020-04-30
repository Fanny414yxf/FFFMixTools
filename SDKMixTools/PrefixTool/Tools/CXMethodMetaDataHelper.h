//
//  CXMethodMetaDataHelper.h
//  SDKMixTools
//
//  Created by chr on 2020/4/1.
//  Copyright © 2020 chr. All rights reserved.
//
//  主要用来完成对方法元数据的组装

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CXMethodParam;
/// 参数类型
typedef NS_ENUM(NSUInteger, CXMethodParamType) {
    CXMethodParamTypeVoid,      // 无
    CXMethodParamTypeBase,      // 基本数据类型
    CXMethodParamTypeObject     // 对象类型
};

/// 参数位置类型
typedef NS_ENUM(NSUInteger, CXMethodParamPositionType) {
    CXMethodParamPositionTypeReturn,      // 返回值
    CXMethodParamPositionTypeParam        // 参数
};


@interface CXMethodMetaDataHelper : NSObject
+ (__kindof CXMethodMetaDataHelper *)sharedInstance;


/// 生成一个随机的方法签名段（去2-3个单词组合）
- (NSString *)cx_generateARandomMethodSegmentNameAtIndex:(NSInteger)idx;

/// 根据方法签名段生成一个随机的方法参数对象
/// @param methodSeg 参数对象
- (CXMethodParam *)cx_generateARandomMethodParamWithMethodSegString:(NSString *)methodSeg;

/// 随机生成一个返回值参数对象
- (CXMethodParam *)cx_generateARandomReturnTypeParam;

/// 随机产生一个参数个数的值
- (NSInteger)cx_randomParamsCount;

@end

NS_ASSUME_NONNULL_END
