//
//  CXMetaBaseEntity.h
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *_Nonnull CXInputParamPlaceholder = @"{OCINPUT1}";
static const NSString *_Nonnull CXInnerParamPlaceholder = @"{OCPARAM";
static const NSInteger CXInnerParamsMaxCount = 10;

NS_ASSUME_NONNULL_BEGIN

@interface CXMetaBaseEntity : NSObject

/// 包含多少的方法片段宏定义个数，方便在子类中随机获取并添加片段以及在在外界知道方法组合的数量
@property (nonatomic, assign, readonly) CGFloat methodBodyMacrosCount;

+ (__kindof CXMetaBaseEntity *)sharedInstance;

/// 基类方法，有对应的子类自行实现具体的方法体内容
- (NSString *)cx_getRandomMethodBodyWithParamName:(NSString *)paramName;

@end

NS_ASSUME_NONNULL_END
