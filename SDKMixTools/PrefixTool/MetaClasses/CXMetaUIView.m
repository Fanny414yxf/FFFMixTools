//
//  CXMetaUIView.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaUIView.h"
#import "NSObject+CXMetaInit.h"

#define MODEL_UIVIEW_1 @"\
    {OCINPUT1} = [[UIView alloc] init];\n\
    {OCINPUT1}.frame = CGRectMake(0, 0, {OCINPUT1}.bounds.size.width, 1);\n\
    CGPoint cenP = {OCINPUT1}.center;\n\
    cenP.y -= 22;\n\
    {OCINPUT1}.center = cenP;\n\
    cenP.y += 44;\n\
    {OCINPUT1}.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];\n"

#define MODEL_UIVIEW_2 @"\
    [UIView animateWithDuration:0.5 animations:^{\n\
        {OCINPUT1}.frame = CGRectMake(0, {OCINPUT1}.bounds.size.height - 210, {OCINPUT1}.bounds.size.width, 210);\n\
    }];\n"

#define MODEL_UIVIEW_3 @"\
    [UIView animateWithDuration:0.5 animations:^{\n\
        {OCINPUT1}.frame = CGRectMake(0, {OCINPUT1}.bounds.size.height, {OCINPUT1}.bounds.size.width, 210);\n\
    } completion:^(BOOL finished) {\n\
        [{OCINPUT1} removeFromSuperview];\n\
    }];\n"

#define MODEL_UIVIEW_4 @"\
    CABasicAnimation *{OCPARAM1} = [CABasicAnimation animationWithKeyPath:@\"{OCPARAM2}\"];\n\
    {OCPARAM1}.fromValue = [NSNumber numberWithFloat:1.0];\n\
    {OCPARAM1}.toValue = [NSNumber numberWithFloat:0.0];\n\
    {OCPARAM1}.autoreverses = YES;\n\
    {OCPARAM1}.repeatCount = FLT_MAX;\n\
    {OCPARAM1}.removedOnCompletion = NO;\n\
    {OCPARAM1}.fillMode = kCAFillModeForwards;\n"

#define MODEL_UIVIEW_5 @"    {OCINPUT1}.frame = CGRectMake(0, 0, 200, 400);\n"

#define MODEL_UIVIEW_6 @"\
    for (UIView *{OCPARAM1} in {OCINPUT1}.subviews) {\n\
        [{OCPARAM1} removeFromSuperview];\n\
    }\n"

#define MODEL_UIVIEW_7 @"\
    UIView* _{OCPARAM1}View = [[UIView alloc] initWithFrame:{OCINPUT1}.bounds];\n\
    _{OCPARAM1}View.layer.anchorPoint = CGPointMake(0.5, 0);\n"

#define MODEL_UIVIEW_8 @"\
    int {OCPARAM2} = 0;\n\
    if (0 == {OCINPUT1}.frame.size.height) {\n\
        {OCPARAM2}++;\n\
    }\n\
    CGFloat {OCPARAM1} = MAX({OCINPUT1}.frame.size.height, 10);\n"

#define MODEL_UIVIEW_9 @"\
    if ([{OCINPUT1} isKindOfClass:[UIImageView class]]\n\
        || [{OCINPUT1} isKindOfClass:[UITextField class]]\n\
        || [{OCINPUT1} isKindOfClass:[UITextView class]]) {\n\
        [{OCINPUT1} description];\n\
    }\n"

#define MODEL_UIVIEW_10 @"   [{OCINPUT1} setTag:100];\n"
#define MODEL_UIVIEW_11 @"   {OCINPUT1}.tag = 100;\n"
#define MODEL_UIVIEW_12 @"   [{OCINPUT1} setAlpha:0.5f];\n"
#define MODEL_UIVIEW_13 @"   {OCINPUT1}.alpha = 0.5f;\n"
#define MODEL_UIVIEW_14 @"   [{OCINPUT1} setFrame:CGRectMake(0,0,100,100)];\n"
#define MODEL_UIVIEW_15 @"   {OCINPUT1}.frame = CGRectMake(0,0,100,100);\n"
#define MODEL_UIVIEW_16 @"   [{OCINPUT1} setBounds:CGRectMake(10,10,200,200)];\n"
#define MODEL_UIVIEW_17 @"   {OCINPUT1}.bounds = CGRectMake(10,10,200,200);\n"
#define MODEL_UIVIEW_18 @"   [{OCINPUT1} setHidden:TRUE];\n"
#define MODEL_UIVIEW_19 @"   {OCINPUT1}.hidden = TRUE;\n"
#define MODEL_UIVIEW_20 @"   [{OCINPUT1} setHidden:FALSE];\n"
#define MODEL_UIVIEW_21 @"   {OCINPUT1}.hidden = FALSE;\n"
#define MODEL_UIVIEW_22 @"   [{OCINPUT1} setTintColor:[UIColor whiteColor]];\n"
#define MODEL_UIVIEW_23 @"   {OCINPUT1}.tintColor = [UIColor whiteColor];\n"
#define MODEL_UIVIEW_24 @"   [{OCINPUT1} setExclusiveTouch:FALSE];\n"
#define MODEL_UIVIEW_25 @"   {OCINPUT1}.exclusiveTouch = FALSE;\n"
#define MODEL_UIVIEW_26 @"   [{OCINPUT1} setUserInteractionEnabled:FALSE];\n"
#define MODEL_UIVIEW_27 @"   {OCINPUT1}.userInteractionEnabled = FALSE;\n"
#define MODEL_UIVIEW_28 @"   [{OCINPUT1} setCenter:CGPointMake(255,255)];\n"
#define MODEL_UIVIEW_29 @"   {OCINPUT1}.center = CGPointMake(255,255);\n"

#define CX_UIVIEW(index) MODEL_UIVIEW_##index

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types-discards-qualifiers"
@implementation CXMetaUIView

static CXMetaUIView *_instance;
+ (CXMetaUIView *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMetaUIView alloc] init];
    }
    return _instance;
}

//- (NSString *)cx_getRandomMethodBodyWithParamName:(NSString *)paramName {
//    NSString *methodBody = @"";
//    NSInteger count = arc4random_uniform(3)+1;
//    for (int i=0; i<count; i++) {
//        NSInteger idx = arc4random_uniform((uint32_t)(self.methodBodyMacrosCount));
//        methodBody = [methodBody stringByAppendingString:[self marosArr][idx]];
//        methodBody = [methodBody stringByReplacingOccurrencesOfString:CXInputParamPlaceholder withString:paramName];
//
//        for (int j=0; j<CXInnerParamsMaxCount; j++) {
//            NSString *inputParamName = [NSString stringWithFormat:@"%@%d}", CXInnerParamPlaceholder, j];
//            NSString *randomName = [[CXMethodMetaDataHelper sharedInstance] cx_generateARandomMethodSegmentNameAtIndex:2];
//            methodBody = [methodBody stringByReplacingOccurrencesOfString:inputParamName withString:randomName];
//        }
//    }
//    return methodBody;
//}

- (CGFloat)methodBodyMacrosCount {
    return 29;
}

- (NSArray <NSString *>*)marosArr {
    return @[
        MODEL_UIVIEW_1,
        MODEL_UIVIEW_2,
        MODEL_UIVIEW_3,
        MODEL_UIVIEW_4,
        MODEL_UIVIEW_5,
        MODEL_UIVIEW_6,
        MODEL_UIVIEW_7,
        MODEL_UIVIEW_8,
        MODEL_UIVIEW_9,
        MODEL_UIVIEW_10,
        MODEL_UIVIEW_11,
        MODEL_UIVIEW_12,
        MODEL_UIVIEW_13,
        MODEL_UIVIEW_14,
        MODEL_UIVIEW_15,
        MODEL_UIVIEW_16,
        MODEL_UIVIEW_17,
        MODEL_UIVIEW_18,
        MODEL_UIVIEW_19,
        MODEL_UIVIEW_20,
        MODEL_UIVIEW_21,
        MODEL_UIVIEW_22,
        MODEL_UIVIEW_23,
        MODEL_UIVIEW_24,
        MODEL_UIVIEW_25,
        MODEL_UIVIEW_26,
        MODEL_UIVIEW_27,
        MODEL_UIVIEW_28,
        MODEL_UIVIEW_29
    ];
}

@end
#pragma clang diagnostic pop

