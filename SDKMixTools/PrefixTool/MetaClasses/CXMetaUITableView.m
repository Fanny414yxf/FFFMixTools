//
//  CXMetaUITableView.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaUITableView.h"
#import "NSObject+CXMetaInit.h"
#import "CXMethodMetaDataHelper.h"

#define MODEL_UITABLEVIEW_1  @"   [{OCINPUT1} setRowHeight:120];\n"
#define MODEL_UITABLEVIEW_2  @"   {OCINPUT1}.rowHeight = 140;\n"
#define MODEL_UITABLEVIEW_3  @"   [{OCINPUT1} setEditing:TRUE];\n"
#define MODEL_UITABLEVIEW_4  @"   {OCINPUT1}.editing = FALSE;\n"
#define MODEL_UITABLEVIEW_5  @"   [{OCINPUT1} setAllowsSelection:TRUE];\n"
#define MODEL_UITABLEVIEW_6  @"   {OCINPUT1}.allowsSelection = FALSE;\n"
#define MODEL_UITABLEVIEW_7  @"   [{OCINPUT1} setSeparatorColor:[UIColor blackColor]];\n"
#define MODEL_UITABLEVIEW_8  @"   {OCINPUT1}.separatorColor = [UIColor blackColor];\n"
#define MODEL_UITABLEVIEW_9  @"   [{OCINPUT1} setEditing:TRUE animated:TRUE];\n"
#define MODEL_UITABLEVIEW_10 @"   [{OCINPUT1} setDelegate:NULL];\n"
#define MODEL_UITABLEVIEW_11 @"   {OCINPUT1}.delegate = NULL;\n"
#define MODEL_UITABLEVIEW_12 @"   [{OCINPUT1} setDataSource:NULL];\n"
#define MODEL_UITABLEVIEW_13 @"   {OCINPUT1}.dataSource = NULL;\n"

@implementation CXMetaUITableView

static CXMetaUITableView *_instance;
+ (CXMetaUITableView *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMetaUITableView alloc] init];
    }
    return _instance;
}


- (CGFloat)methodBodyMacrosCount {
    return 13;
}

- (NSArray <NSString *>*)marosArr {
    return @[
        MODEL_UITABLEVIEW_1,
        MODEL_UITABLEVIEW_2,
        MODEL_UITABLEVIEW_3,
        MODEL_UITABLEVIEW_4,
        MODEL_UITABLEVIEW_5,
        MODEL_UITABLEVIEW_6,
        MODEL_UITABLEVIEW_7,
        MODEL_UITABLEVIEW_8,
        MODEL_UITABLEVIEW_9,
        MODEL_UITABLEVIEW_10,
        MODEL_UITABLEVIEW_11,
        MODEL_UITABLEVIEW_12,
        MODEL_UITABLEVIEW_13
    ];
}
@end


