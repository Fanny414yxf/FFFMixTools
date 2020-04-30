//
//  CXMethodEntity.m
//  SDKMixTools
//
//  Created by chr on 2020/3/25.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMethodEntity.h"
#import "CXMetaData.h"
#import "NSString+CXMixture.h"
#import "CXMethodMetaDataHelper.h"
#import "NSMutableString+CXMixture.h"


@interface CXMethodParam ()
@end
@implementation CXMethodParam

- (NSString *)cx_description {
    if (self.paramType == CXMethodParamTypeObject) return [NSString stringWithFormat:@"(%@ *)", self.paramTypeName];
    return [NSString stringWithFormat:@"(%@)", self.paramTypeName];
}

- (NSString *)returnedValue {
    switch (self.paramType) {
        case CXMethodParamTypeVoid:
            return @"";
            break;

        case CXMethodParamTypeBase: {
            return [NSString stringWithFormat:@"\n\treturn %u;\n", arc4random_uniform(10)%2];
        }
            break;
            
        default: {
            return [NSString stringWithFormat:@"\n\treturn [[%@ alloc] init];\n", self.paramTypeName];
        }
            break;
    }
}

@end

@interface CXMethodEntity ()
@end
@implementation CXMethodEntity

/// 同步方法实现，在添加完方法签名后，手动调用该方法
- (void)cx_synchronizeMethodsImplementation {
    
}

#pragma mark - setters vs getters
- (NSInteger)paramsCount {
    return self.params.count;
}

- (NSString *)methodsSignature {
    NSMutableString *signatureStr = [NSMutableString stringWithString:@"- "];
    [signatureStr appendString:self.returnType.cx_description];
    if (self.methodNameSegments.count == 0) return @"";
    
    if (self.paramsCount == 0) {
        [signatureStr appendString:self.methodNameSegments.firstObject];
    } else {
        [self.methodNameSegments enumerateObjectsUsingBlock:^(NSString * _Nonnull segName, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *paramName = self.params[idx].paramName;
            [signatureStr appendFormat:@"%@:%@%@ ", segName, self.params[idx].cx_description, paramName];
        }];
        [signatureStr cx_mutableStringByDeletingTrailingCharactersWithCount:1]; // 删除末尾空格
    }
    
    [signatureStr appendString:@";"];
    return signatureStr;
}

- (NSString *)invokingString {
    NSMutableString *invokingStr = [NSMutableString stringWithFormat:@"\n\t"];
    if (self.params.count) {
        NSMutableArray *paramNames = [NSMutableArray arrayWithCapacity:self.params.count];
        for (CXMethodParam *param in self.params) {
            NSMutableString *paramStr = [NSMutableString stringWithString:param.paramTypeName];
            NSString *paramName = [[CXMethodMetaDataHelper sharedInstance] cx_generateARandomMethodSegmentNameAtIndex:1];
            param.paramType == CXMethodParamTypeBase ?
                ([paramStr appendFormat:@" %@ = arc4random_uniform(10);\n\t", paramName]) :
                ([paramStr appendFormat:@" *%@ = [[%@ alloc] init];\n\t", paramName, param.paramTypeName]);
            [invokingStr appendFormat:@"%@", paramStr];
            [paramNames addObject:paramName];
        }
        [invokingStr appendString:@"[self"];
        
        [self.methodNameSegments enumerateObjectsUsingBlock:^(NSString * _Nonnull seg, NSUInteger idx, BOOL * _Nonnull stop) {
            [invokingStr appendFormat:@" %@:%@", seg, paramNames[idx]];
        }];
        [invokingStr appendString:@"];\n"];
    } else {
        [invokingStr appendFormat:@"[self %@];\n", self.methodNameSegments.firstObject];
    }
    return invokingStr;
}

- (NSString *)methodsImplementation {
    NSMutableString *implementationStr = [[self.methodsSignature cx_stringByDeletingTrailingCharactersWithCount:1] mutableCopy];
    [implementationStr appendString:@" {\n\t"];
    // 打印方法名
//    [implementationStr appendFormat:@"NSLog(@\"%%s\", __func__);\n"];
    
    // 拼接随机方法
    if (self.params.count == 0) {
        // 没有参数
        NSString *commonMethodBody = [[CXMetaCommon sharedInstance] cx_getRandomMethodBodyWithParamName:@""];
        [implementationStr appendFormat:@"\n\t%@", commonMethodBody];
    } else {
        // 有参数
        for (CXMethodParam *param in self.params) {
            NSString *typeName = param.paramTypeName;
            NSString *methodBody = [self cx_randomMethodBodyWithTypeName:typeName paramName:param.paramName];
            [implementationStr appendFormat:@"\n\t%@", methodBody];
        }
        NSString *commonMethodBody = [[CXMetaCommon sharedInstance] cx_getRandomMethodBodyWithParamName:@""];
        [implementationStr appendFormat:@"\n\t%@", commonMethodBody];
    }
    
    // 品尚返回值
    [implementationStr appendFormat:@"\t%@\n", self.returnType.returnedValue];
    [implementationStr appendString:@"}\n"];
    return implementationStr;
}

- (UIImage *)fundingFollowingJobsWestWhether {
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int timer = 0;
        timer ++;
    });
    UILabel* buildingMortalityLabel = [[UILabel alloc] init];
    buildingMortalityLabel.text = @"strokeTeaching";
    CGFloat yearSeveral = 100.0f;
    CGFloat earthFindingsJournal = 200.0f;
    NSMutableDictionary *fungiResearch = [NSMutableDictionary dictionary];
    CGRect greaterLink = [buildingMortalityLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fungiResearch context:nil];
    CGFloat investingGroup = (yearSeveral - earthFindingsJournal) * 0.5;
    CGPoint valuableAgain = buildingMortalityLabel.center;
    valuableAgain.x = investingGroup + greaterLink.size.height;
    buildingMortalityLabel.center = valuableAgain;
    unsigned long long leadDevelop;
    NSDate * timelyResearchFocus = [NSDate date];
    leadDevelop = [timelyResearchFocus timeIntervalSince1970];
    
    return [[UIImage alloc] init];

}

- (NSString *)cx_randomMethodBodyWithTypeName:(NSString *)typeName paramName:(NSString *)paramName {
    CXMetaBaseEntity *metaEntity = nil;
    if ([typeName isEqualToString:@"UIView"]) {
        metaEntity = [CXMetaUIView sharedInstance];
    }
    else if ([typeName isEqualToString:@"UITableView"]) {
        metaEntity = [CXMetaUITableView sharedInstance];
    }
    else if ([typeName isEqualToString:@"NSArray"]) {
        metaEntity = [CXMetaNSArray sharedInstance];
    }
    else if ([typeName isEqualToString:@"NSData"]) {
        metaEntity = [CXMetaNSData sharedInstance];
    }
    else if ([typeName isEqualToString:@"UIButton"]) {
        metaEntity = [CXMetaUIButton sharedInstance];
    }
    else if ([typeName isEqualToString:@"UIImage"]) {
        metaEntity = [CXMetaUIImageView sharedInstance];
    }
    else if ([typeName isEqualToString:@"UILabel"]) {
        metaEntity = [CXMetaUILabel sharedInstance];
    }
    else if ([typeName isEqualToString:@"UITextField"]) {
        metaEntity = [CXMetaUITextField sharedInstance];
    }
    else if ([typeName isEqualToString:@"NSString"]) {
        metaEntity = [CXMetaNSString sharedInstance];
    }
    if (metaEntity == nil) return @"";
    return [metaEntity cx_getRandomMethodBodyWithParamName:paramName];
}

#pragma mark - lazy
- (NSMutableArray<CXMethodParam *> *)params {
    if (_params == nil) {
        _params = [NSMutableArray array];
    }
    return _params;
}

- (NSMutableArray<NSString *> *)methodNameSegments {
    if (_methodNameSegments == nil) {
        _methodNameSegments = [NSMutableArray array];
    }
    return _methodNameSegments;
}

@end
