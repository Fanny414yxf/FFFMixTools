//
//  CXMetaUITextField.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaUITextField.h"

#define MODEL_UITEXTFIELD_1 @"   [{OCINPUT1} becomeFirstResponder];\n"
#define MODEL_UITEXTFIELD_2 @"   {OCINPUT1}.placeholder = @\"Login\";\n"
#define MODEL_UITEXTFIELD_3 @"   {OCINPUT1}.secureTextEntry = YES;\n"

@implementation CXMetaUITextField

static CXMetaUITextField *_instance;
+ (CXMetaUITextField *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMetaUITextField alloc] init];
    }
    return _instance;
}

- (CGFloat)methodBodyMacrosCount {
    return 3;
}

- (NSArray <NSString *>*)marosArr {
    return @[
        MODEL_UITEXTFIELD_1,
        MODEL_UITEXTFIELD_2,
        MODEL_UITEXTFIELD_3
    ];
}
@end
