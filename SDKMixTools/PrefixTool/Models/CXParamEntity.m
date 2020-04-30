//
//  CXParamEntity.m
//  SDKMixTools
//
//  Created by chr on 2020/3/19.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXParamEntity.h"

@implementation CXParamEntity

- (NSString *)cx_getInitializitionString {
    NSString *createrStr = nil;
    if (self.isObjectType) {
        createrStr = [NSString stringWithFormat:@"\n\t// 生成 %@ 类的对象\n\t%@ *%@ = [[%@ alloc] init];\n\t", self.className, self.className, self.objectName, self.className];
    } else {
        createrStr = [NSString stringWithFormat:@"\n\t%@ %@ = 0;\n\t", self.className, self.objectName];
    }
    return createrStr;
}
@end
