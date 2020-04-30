//
//  CXMetaUIButton.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaUIButton.h"

#define MODEL_UIBUTTON_1 @"\
    UIButton* _{OCPARAM1} = [UIButton buttonWithType:UIButtonTypeCustom];\n\
    _{OCPARAM1}.frame = CGRectMake(20, CGRectGetMaxY(_{OCPARAM1}.frame)+15, 110, 40);\n\
    [_{OCPARAM1} setTitle:@\"{OCPARAM1}\" forState:UIControlStateNormal];\n\
    [_{OCPARAM1} setTitleColor:[UIColor colorWithRed:153*0.04 green:153*0.04 blue:153*0.04 alpha:1] forState:UIControlStateNormal];\n\
    _{OCPARAM1}.layer.cornerRadius = _{OCPARAM1}.bounds.size.height*0.5;\n\
    _{OCPARAM1}.layer.borderWidth = 1;\n\
    _{OCPARAM1}.layer.borderColor = [UIColor colorWithRed:242*0.04 green:242*0.04 blue:242*0.04 alpha:1].CGColor;\n\
    \n\
    [{OCINPUT1} addSubview:_{OCPARAM1}];\n"
#define MODEL_UIBUTTON_2 @"   [{OCINPUT1} setImage:[UIImage imageNamed:@\"{OCPARAM1}.png\"] forState:UIControlStateNormal];\n"
#define MODEL_UIBUTTON_3 @"   [{OCINPUT1} setImageEdgeInsets:UIEdgeInsetsZero];\n"
#define MODEL_UIBUTTON_4 @"   {OCINPUT1}.imageEdgeInsets = UIEdgeInsetsZero;\n"
#define MODEL_UIBUTTON_5 @"   [{OCINPUT1} setContentEdgeInsets:UIEdgeInsetsZero];\n"
#define MODEL_UIBUTTON_6 @"   {OCINPUT1}.contentEdgeInsets = UIEdgeInsetsZero;\n"
#define MODEL_UIBUTTON_7 @"   [{OCINPUT1} setBackgroundImage:[UIImage imageNamed:@\"{OCPARAM1}.png\"] forState:UIControlStateDisabled];\n"
#define MODEL_UIBUTTON_8 @"   [{OCINPUT1} setShowsTouchWhenHighlighted:TRUE];\n"
#define MODEL_UIBUTTON_9 @"   {OCINPUT1}.showsTouchWhenHighlighted = FALSE;\n"

@implementation CXMetaUIButton

static CXMetaUIButton *_instance;
+ (CXMetaUIButton *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMetaUIButton alloc] init];
    }
    return _instance;
}


- (CGFloat)methodBodyMacrosCount {
    return 9;
}

- (NSArray <NSString *>*)marosArr {
    return @[
    MODEL_UIBUTTON_1,
    MODEL_UIBUTTON_2,
    MODEL_UIBUTTON_3,
    MODEL_UIBUTTON_4,
    MODEL_UIBUTTON_5,
    MODEL_UIBUTTON_6,
    MODEL_UIBUTTON_7,
    MODEL_UIBUTTON_8,
    MODEL_UIBUTTON_9
    ];
}
@end
