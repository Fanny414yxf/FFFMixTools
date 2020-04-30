//
//  CXMetaNSArray.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaNSArray.h"
#import "NSObject+CXMetaInit.h"
#import "CXMethodMetaDataHelper.h"

#define MODEL_NSARRAY_1 @"\
    // 加载plist文件\n\
    NSURL *{OCPARAM1}URL = [[NSBundle mainBundle]URLForResource:@\"{OCPARAM1}.plist\" withExtension:@\"plist\"];\n\
    // 读取plist的数据，并保存在数组中\n\
    NSArray *{OCPARAM2}Array = [NSArray arrayWithContentsOfURL:{OCPARAM1}URL];\n\
    NSMutableArray *{OCPARAM3} = [NSMutableArray arrayWithCapacity:{OCPARAM2}Array.count];\n\
    for (NSDictionary *dict in {OCPARAM2}Array)\n\
    {\n\
        [{OCPARAM3} addObject:[dict objectForKey:@\"key\"]];\n\
    }\n"
#define MODEL_NSARRAY_2 @"   [{OCINPUT1} setValue:@\"{OCPARAM1}\" forKey:@\"{OCPARAM1}\"];\n"
#define MODEL_NSARRAY_3 @"   [{OCINPUT1} count];\n"
#define MODEL_NSARRAY_4 @"\
    for (NSObject* obj in {OCINPUT1}) {\n\
        BOOL {OCPARAM1} = [obj isKindOfClass:[NSString class]];\n\
        if({OCPARAM1}){\n\
            break;\n\
        }\n\
    }\n"
#define MODEL_NSARRAY_5 @"\
    int {OCPARAM1} = 0;\n\
    if(10 >= [{OCINPUT1} count]){\n\
        {OCPARAM1} = [{OCINPUT1} count];\n\
    }\n"
#define MODEL_NSARRAY_6 @"\
    NSMutableArray* array = [[NSMutableArray alloc] init];\n\
    int count = array.count ?: 0;\
    for (int i=0; i<count; i++) {\n\
        [array addObject:[{OCINPUT1} objectAtIndex:i]];\n\
    }\n"

@implementation CXMetaNSArray

static CXMetaNSArray *_instance;
+ (CXMetaNSArray *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMetaNSArray alloc] init];
    }
    return _instance;
}

- (CGFloat)methodBodyMacrosCount {
    return 6;
}

- (NSArray <NSString *>*)marosArr {
    return @[
    MODEL_NSARRAY_1,
    MODEL_NSARRAY_2,
    MODEL_NSARRAY_3,
    MODEL_NSARRAY_4,
    MODEL_NSARRAY_5,
    MODEL_NSARRAY_6
    ];
}
@end
