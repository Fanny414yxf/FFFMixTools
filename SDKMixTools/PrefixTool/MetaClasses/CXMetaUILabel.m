//
//  CXMetaUILabel.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaUILabel.h"

#define MODEL_UILABEL_1  @"   {OCINPUT1}.font = [UIFont systemFontOfSize:20];\n"
#define MODEL_UILABEL_2  @"   {OCINPUT1}.textColor = [UIColor redColor];\n"
#define MODEL_UILABEL_3  @"   {OCINPUT1}.textAlignment = NSTextAlignmentCenter;\n"
#define MODEL_UILABEL_4  @"   {OCINPUT1}.transform = CGAffineTransformMakeScale(0.9, 0.8);\n"
#define MODEL_UILABEL_5  @"   [{OCINPUT1} setFont:[UIFont fontWithName:@\"Bold\" size:12]];\n"
#define MODEL_UILABEL_6  @"   {OCINPUT1}.font = [UIFont fontWithName:@\"Arial\" size:14];\n"
#define MODEL_UILABEL_7  @"   [{OCINPUT1} setText:@\"{OCPARAM1}\"];\n"
#define MODEL_UILABEL_8  @"   {OCINPUT1}.text = @\"{OCPARAM1}\";\n"
#define MODEL_UILABEL_9  @"   [{OCINPUT1} setEnabled:TRUE];\n"
#define MODEL_UILABEL_10 @"  {OCINPUT1}.enabled = FALSE;\n"
#define MODEL_UILABEL_11 @"  [{OCINPUT1} setHighlighted:TRUE];\n"
#define MODEL_UILABEL_12 @"  {OCINPUT1}.highlighted = FALSE;\n"
#define MODEL_UILABEL_13 @"  [{OCINPUT1} setTextColor:[UIColor blueColor]];\n"
#define MODEL_UILABEL_14 @"  {OCINPUT1}.textColor = [UIColor blackColor];\n"
#define MODEL_UILABEL_15 @"  [{OCINPUT1} setShadowColor:[UIColor yellowColor]];\n"
#define MODEL_UILABEL_16 @"  {OCINPUT1}.shadowColor = [UIColor orangeColor];\n"
#define MODEL_UILABEL_17 @"  [{OCINPUT1} setNumberOfLines:100];\n"
#define MODEL_UILABEL_18 @"  {OCINPUT1}.numberOfLines = 36;\n"
#define MODEL_UILABEL_19 @"  [{OCINPUT1} setAdjustsFontSizeToFitWidth:TRUE];\n"
#define MODEL_UILABEL_20 @"  {OCINPUT1}.adjustsFontSizeToFitWidth = FALSE;\n"

@implementation CXMetaUILabel

static CXMetaUILabel *_instance;
+ (CXMetaUILabel *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMetaUILabel alloc] init];
    }
    return _instance;
}

- (CGFloat)methodBodyMacrosCount {
    return 20;
}

- (NSArray <NSString *>*)marosArr {
    return @[
        MODEL_UILABEL_1,
        MODEL_UILABEL_2,
        MODEL_UILABEL_3,
        MODEL_UILABEL_4,
        MODEL_UILABEL_5,
        MODEL_UILABEL_6,
        MODEL_UILABEL_7,
        MODEL_UILABEL_8,
        MODEL_UILABEL_9,
        MODEL_UILABEL_10,
        MODEL_UILABEL_11,
        MODEL_UILABEL_12,
        MODEL_UILABEL_13,
        MODEL_UILABEL_14,
        MODEL_UILABEL_15,
        MODEL_UILABEL_16,
        MODEL_UILABEL_17,
        MODEL_UILABEL_18,
        MODEL_UILABEL_19,
        MODEL_UILABEL_20
    ];
}
@end
