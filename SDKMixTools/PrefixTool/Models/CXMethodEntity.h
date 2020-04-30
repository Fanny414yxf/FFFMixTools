//
//  CXMethodEntity.h
//  SDKMixTools
//
//  Created by chr on 2020/3/25.
//  Copyright © 2020 chr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXMethodMetaDataHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXMethodParam : NSObject
@property (nonatomic, assign) CXMethodParamType paramType;
@property (nonatomic, copy) NSString *paramTypeName;
@property (nonatomic, copy) NSString *paramName;
@property (nonatomic, copy, readonly) NSString *returnedValue;
- (NSString *)cx_description;
@end

@interface CXMethodEntity : NSObject

/// 返回值类型
@property (nonatomic, strong) CXMethodParam *returnType;

/// 参数数组
@property (nonatomic, strong) NSMutableArray <CXMethodParam *>*params;

/// 方法签名段数组
@property (nonatomic, strong) NSMutableArray <NSString *>*methodNameSegments;

/// 方法签名
@property (nonatomic, copy, readonly) NSString *methodsSignature;

/// 方法实现
@property (nonatomic, copy, readonly) NSString *methodsImplementation;

/// 参数个数
@property (nonatomic, assign, readonly) NSInteger paramsCount;

@property (nonatomic, copy, readonly) NSString *invokingString;
@end

NS_ASSUME_NONNULL_END
