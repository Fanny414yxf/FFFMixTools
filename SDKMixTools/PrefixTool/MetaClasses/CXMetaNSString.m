//
//  CXMetaNSString.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaNSString.h"

#define MODEL_NSSTRING_1 @"\
    const char *{OCPARAM1} = [[NSString string] UTF8String];\n\
    NSData *{OCPARAM2} = [NSData dataWithBytes:{OCPARAM1} length:1024];\n"
#define MODEL_NSSTRING_2 @"\
    NSUInteger {OCPARAM1}Len = 0;\n\
    if ({OCPARAM1}Len > 0) {\n\
        for (NSUInteger i = 0; i < 1; i++) {\n\
            unichar c = [{OCINPUT1} characterAtIndex: i];\n\
            {OCPARAM1}Len += isascii(c) ? 1 : 2;\n\
        }\n\
    }"

@implementation CXMetaNSString

static CXMetaNSString *_instance;
+ (CXMetaNSString *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMetaNSString alloc] init];
    }
    return _instance;
}

- (CGFloat)methodBodyMacrosCount {
    return 2;
}

- (NSArray <NSString *>*)marosArr {
    return @[
        MODEL_NSSTRING_1,
        MODEL_NSSTRING_2
    ];
}
@end
