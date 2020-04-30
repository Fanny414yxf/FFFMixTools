//
//  CXMethodMetaDataHelper.m
//  SDKMixTools
//
//  Created by chr on 2020/4/1.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMethodMetaDataHelper.h"
#import "CXMethodEntity.h"
#import "CXWordsConsts.h"
#import "NSArray+CXMixture.h"

static CXMethodMetaDataHelper *_instance;

@interface CXMethodMetaDataHelper ()
/// 单词词库
@property (nonatomic, strong) NSArray <NSString *>*wordsLib;
@property (nonatomic, assign) NSInteger wordsCount;

/// 连接词词库
@property (nonatomic, strong) NSArray <NSString *>*jointLib;
@property (nonatomic, assign) NSInteger jointCount;

/// 动词词库
@property (nonatomic, strong) NSArray <NSString *>*verbLib;;
@property (nonatomic, assign) NSInteger verbCount;

/// 对象类型参数词库
@property (nonatomic, strong) NSArray <NSString *>*paramTypeObjectLib;
@property (nonatomic, assign) NSInteger typeObjectCount;

/// 基本数据类型参数词库
@property (nonatomic, strong) NSArray <NSString *>*paramTypeBaseLib;
@property (nonatomic, assign) NSInteger typeBaseCount;

@end
@implementation CXMethodMetaDataHelper

#pragma mark - public
+ (CXMethodMetaDataHelper *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMethodMetaDataHelper alloc] init];
    }
    return _instance;
}

- (NSString *)cx_generateARandomMethodSegmentNameAtIndex:(NSInteger)idx {
    NSInteger wordsCount = arc4random_uniform(2)+2; // 2~3
    if (idx == 0) {
        wordsCount = arc4random_uniform(3)+4;
    }
    return [self.wordsLib cx_randomLowerCamelCaseStringWithComponentCount:wordsCount];
}

- (CXMethodParam *)cx_generateARandomMethodParamWithMethodSegString:(NSString *)methodSeg {
    CXMethodParam *param = [[CXMethodParam alloc] init];
    CXMethodParamType type = [self cx_randomParamTypeWithPositionType:CXMethodParamPositionTypeParam];
    param.paramType = type;
    param.paramTypeName = [self cx_paramTypeNameWithType:type];
    return param;
}

- (CXMethodParam *)cx_generateARandomReturnTypeParam {
    CXMethodParam *param = [[CXMethodParam alloc] init];
    CXMethodParamType type = [self cx_randomParamTypeWithPositionType:CXMethodParamPositionTypeReturn];
    param.paramType = type;
    param.paramTypeName = [self cx_paramTypeNameWithType:type];
    return param;
}

- (NSInteger)cx_randomParamsCount {
    NSInteger randomIdx = arc4random_uniform(100);
    if (randomIdx < 20) return 0;   // 20%几率无参数
    if (randomIdx < 70) return 2;   // 50%几率 2 个参数
    if (randomIdx < 90) return 1;   // 20%几率 1 个参数
    return 3;                       // 10%几率 3 个参数
}
#pragma mark private

- (CXMethodParamType)cx_randomParamTypeWithPositionType:(CXMethodParamPositionType)positionType {
    NSInteger randomIdx = arc4random_uniform(100);
    switch (positionType) {
        case CXMethodParamPositionTypeReturn: {
            if (randomIdx < 60) return CXMethodParamTypeVoid;
            if (randomIdx < 80) return CXMethodParamTypeBase;
            return CXMethodParamTypeObject;
        }
            break;
            
        default: {
            if (randomIdx < 60) return CXMethodParamTypeObject;
            return CXMethodParamTypeBase;
        }
            break;
    }
}

- (NSString *)cx_paramTypeNameWithType:(CXMethodParamType)type {
    switch (type) {
            
        case CXMethodParamTypeVoid: // 无返回值
            return @"void";
            break;
            
        case CXMethodParamTypeBase: // 基本数据类型
            return self.paramTypeBaseLib.cx_randomComponentString;
            break;
            
        default:                    // 对象类型
            return self.paramTypeObjectLib.cx_randomComponentString;
            break;
    }
}

#pragma mark lazy

- (NSArray<NSString *> *)wordsLib {
    if (_wordsLib == nil) {
        _wordsLib = [wordsLibStr componentsSeparatedByString:@","];
        self.wordsCount = _wordsLib.count;
    }
    return _wordsLib;
}

- (NSArray<NSString *> *)jointLib {
    if (_jointLib == nil) {
        _jointLib = [jointLibStr componentsSeparatedByString:@","];
        self.jointCount = _jointLib.count;
    }
    return _jointLib;
}

- (NSArray<NSString *> *)verbLib {
    if (_verbLib == nil) {
        _verbLib = [verbLibStr componentsSeparatedByString:@","];
        self.verbCount = _verbLib.count;
    }
    return _verbLib;
}

- (NSArray<NSString *> *)paramTypeObjectLib {
    if (_paramTypeObjectLib == nil) {
        _paramTypeObjectLib = [paramTypeObjectLibStr componentsSeparatedByString:@","];
        self.typeObjectCount = _paramTypeObjectLib.count;
    }
    return _paramTypeObjectLib;
}

- (NSArray<NSString *> *)paramTypeBaseLib {
    if (_paramTypeBaseLib == nil) {
        _paramTypeBaseLib = [paramTypeBaseLibStr componentsSeparatedByString:@","];
        self.typeBaseCount = _paramTypeBaseLib.count;
    }
    return _paramTypeBaseLib;
}

@end
