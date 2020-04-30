//
//  CXParamEntity.h
//  SDKMixTools
//
//  Created by chr on 2020/3/19.
//  Copyright © 2020 chr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXObjectEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXParamEntity : CXObjectEntity

/// 参数类型名称 eg：NSString、Person etc
//@property (nonatomic, copy) NSString *className;

/// 是否为对象类型：YES - 是  NO - 基本数据类型
@property (nonatomic, assign) BOOL isObjectType;
@end

NS_ASSUME_NONNULL_END
