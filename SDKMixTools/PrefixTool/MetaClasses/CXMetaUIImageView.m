//
//  CXMetaUIImage.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaUIImageView.h"


#define MODEL_UIIMAGEVIEW_1 @"\
    UIImageView *{OCPARAM1} = [UIImageView new];\n\
    {OCPARAM1}.image = {OCINPUT1}.image;\n"

#define MODEL_UIIMAGEVIEW_2 @"   {OCINPUT1}.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;\n"

#define MODEL_UIIMAGEVIEW_3 @"   {OCINPUT1}.image = [UIImage imageNamed:@\"{OCPARAM1}\"];\n"

#define MODEL_UIIMAGEVIEW_4 @"   {OCINPUT1}.hidden = YES;\n"

@implementation CXMetaUIImageView

static CXMetaUIImageView *_instance;
+ (CXMetaUIImageView *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMetaUIImageView alloc] init];
    }
    return _instance;
}


- (CGFloat)methodBodyMacrosCount {
    return 4;
}

- (NSArray <NSString *>*)marosArr {
    return @[
        MODEL_UIIMAGEVIEW_1,
        MODEL_UIIMAGEVIEW_2,
        MODEL_UIIMAGEVIEW_3,
        MODEL_UIIMAGEVIEW_4
    ];
}
@end
