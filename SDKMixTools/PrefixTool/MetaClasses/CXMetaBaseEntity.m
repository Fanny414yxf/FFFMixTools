//
//  CXMetaBaseEntity.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaBaseEntity.h"
#import "CXMethodMetaDataHelper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types-discards-qualifiers"

@interface CXMetaBaseEntity ()
@property (nonatomic, assign) CGFloat macrosCount;
@end
@implementation CXMetaBaseEntity

+ (CXMetaBaseEntity *)sharedInstance {return nil;}

- (NSString *)cx_getRandomMethodBodyWithParamName:(NSString *)paramName {
    NSString *methodBody = @"";
    NSInteger methodBodyMacros = 1;
    NSInteger count = self.methodBodyMacrosCount < methodBodyMacros ? self.methodBodyMacrosCount : methodBodyMacros;
    NSMutableArray *idxArr = [@[] mutableCopy];
    for (int i=0; i<count; i++) {
        //去重
        NSInteger idx = arc4random_uniform((uint32_t)(self.methodBodyMacrosCount));
        while ([idxArr containsObject:@(idx)]) {
            idx = arc4random_uniform((uint32_t)(self.methodBodyMacrosCount));
        }
        [idxArr addObject:@(idx)];
        
        methodBody = [methodBody stringByAppendingString:[self marosArr][idx]];
        if (paramName.length) {
            methodBody = [methodBody stringByReplacingOccurrencesOfString:CXInputParamPlaceholder withString:paramName];
        }
        
        for (int j=0; j<CXInnerParamsMaxCount; j++) {
            NSString *inputParamName = [NSString stringWithFormat:@"%@%d}", CXInnerParamPlaceholder, j];
            NSString *randomName = [[CXMethodMetaDataHelper sharedInstance] cx_generateARandomMethodSegmentNameAtIndex:2];
            methodBody = [methodBody stringByReplacingOccurrencesOfString:inputParamName withString:randomName];
        }
    }
    return methodBody;
}

- (NSArray <NSString *>*)marosArr {
    return @[
    ];
}
@end
#pragma clang diagnostic pop
