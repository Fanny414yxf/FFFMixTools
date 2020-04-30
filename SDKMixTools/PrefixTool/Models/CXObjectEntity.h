//
//  CXObjectEntity.h
//  SDKMixTools
//
//  Created by chr on 2020/3/19.
//  Copyright © 2020 chr. All rights reserved.
//
//  某个类的对象实体

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXObjectEntity : NSObject

/// 类名
@property (nonatomic, copy) NSString *className;

/// 生成对象时的名称
@property (nonatomic, copy, readonly) NSString *objectName;

/// 包含的方法列表
@property (nonatomic, strong) NSArray <NSString *>*methodsList;

/// 此方法只是针对目前 unity 脚本生成的垃圾注入文件有效，用于其他的类中会报错
- (NSMutableString *)cx_getRandomMethodInvokedString;

@end

NS_ASSUME_NONNULL_END
