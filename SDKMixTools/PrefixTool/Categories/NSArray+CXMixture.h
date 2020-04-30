//
//  NSArray+CXMixture.h
//  SDKMixTools
//
//  Created by chr on 2020/4/2.
//  Copyright © 2020 chr. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CXMixture)


/// 小驼峰形式的字符串
- (NSString *)cx_lowerCamelCaseString;

/// 随机获取其中一个元素
- (NSString *)cx_randomComponentString;

/// 获取数组中 count 个元素，并按照小驼峰命名方式组装
/// @param count 需要的元素个数
- (NSString *)cx_randomLowerCamelCaseStringWithComponentCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
