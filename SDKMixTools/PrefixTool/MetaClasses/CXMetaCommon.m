//
//  CXMetaCommon.m
//  SDKMixTools
//
//  Created by chr on 2020/4/3.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMetaCommon.h"

#define MODEL_COMMON_1 @"\
    NSCalendar *{OCPARAM1} = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];\n\
    NSDateComponents *{OCPARAM2} = [[NSDateComponents alloc] init];\n\
    NSInteger {OCPARAM3} = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;\n\
    {OCPARAM2} = [{OCPARAM1} components:{OCPARAM3} fromDate:[NSDate date]];\n\
    NSUInteger {OCPARAM4} = [{OCPARAM2} weekday];\n\
    NSString* {OCPARAM5};\n\
    switch ({OCPARAM4}) {\n\
        case 2:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"]; \n\
            break;\n\
        case 3:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"];\n\
            break;\n\
        case 4:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"];\n\
            break;\n\
        case 5:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"];\n\
            break;\n\
        case 6:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"];\n\
            break;\n\
        case 7:\n\
           {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"];\n\
            break;\n\
        case 1:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"];\n\
            break;\n\
        default:\n\
            break;\n\
    }\n"
#define MODEL_COMMON_2 @"\
    unsigned long long {OCPARAM1};\n\
    NSDate * {OCPARAM2} = [NSDate date];\n\
    {OCPARAM1} = [{OCPARAM2} timeIntervalSince1970];\n"
#define MODEL_COMMON_3 @"\
    NSDateFormatter *{OCPARAM1}=[[NSDateFormatter alloc] init];\n\
    [{OCPARAM1} setDateFormat:@\"yyyy-MM-dd HH:mm:ss\"];\n"
#define MODEL_COMMON_4 @"\
    NSCalendar *{OCPARAM1} = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];\n\
    NSDateComponents *{OCPARAM2} = [[NSDateComponents alloc] init];\n\
    [{OCPARAM2} day];\n\
    [{OCPARAM1} firstWeekday];\n"
#define MODEL_COMMON_5 @"\
    NSCalendar *{OCPARAM1} = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];\n\
    NSDateComponents *{OCPARAM2} = [[NSDateComponents alloc] init];\n\
    NSInteger {OCPARAM3} = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;\n\
    {OCPARAM2} = [{OCPARAM1} components:{OCPARAM3} fromDate:[NSDate date]];\n"
#define MODEL_COMMON_6 @"\
    NSCalendar *{OCPARAM1} = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];\n\
    NSDateComponents *{OCPARAM2} = [[NSDateComponents alloc] init];\n\
    NSInteger {OCPARAM3} = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;\n\
    {OCPARAM2} = [{OCPARAM1} components:{OCPARAM3} fromDate:[NSDate date]];\n\
    NSUInteger {OCPARAM4} = [{OCPARAM2} weekday];\n"
#define MODEL_COMMON_7 @"\
    NSCalendar *{OCPARAM1} = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];\n\
    NSDateComponents *{OCPARAM2} = [[NSDateComponents alloc] init];\n\
    NSInteger {OCPARAM3} = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;\n\
    {OCPARAM2} = [{OCPARAM1} components:{OCPARAM3} fromDate:[NSDate date]];\n\
    NSUInteger {OCPARAM4} = [{OCPARAM2} weekday];\n\
    NSString* {OCPARAM5};\n\
    switch ({OCPARAM4}) {\n\
        case 2:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"]; \n\
            break;\n\
        case 1:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"];\n\
            break;\n\
        default:\n\
            break;\n\
    }\n"
#define MODEL_COMMON_8 @"\
    NSCalendar *{OCPARAM1} = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];\n\
    NSDateComponents *{OCPARAM2} = [[NSDateComponents alloc] init];\n\
    NSInteger {OCPARAM3} = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;\n\
    {OCPARAM2} = [{OCPARAM1} components:{OCPARAM3} fromDate:[NSDate date]];\n\
    NSUInteger {OCPARAM4} = [{OCPARAM2} weekday];\n\
    NSString* {OCPARAM5};\n\
    switch ({OCPARAM4}) {\n\
        case 6:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"];\n\
            break;\n\
        case 7:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"];\n\
            break;\n\
        case 1:\n\
            {OCPARAM5} =[NSString stringWithFormat:@\"%@\",@\"{OCPARAM5}\"];\n\
            break;\n\
        default:\n\
            break;\n\
    }\n"
#define MODEL_COMMON_9 @"\
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\n\
        int timer = 0;\n\
        timer ++;\n\
    });\n"
#define MODEL_COMMON_10 @"\
    CGFloat device{OCPARAM1}Width = CGRectGetWidth([[UIScreen mainScreen] bounds]);\n\
    CGFloat device{OCPARAM2}Height = CGRectGetHeight([[UIScreen mainScreen] bounds]);\n\
    [NSString stringWithFormat:@\"Device {OCPARAM1} Width: %f Device {OCPARAM2} Height:%f \", device{OCPARAM1}Width, device{OCPARAM2}Height];\n"
#define MODEL_COMMON_11 @"\
    NSMutableArray *{OCPARAM1} = [[NSMutableArray alloc]init];\n\
    NSInteger {OCPARAM2}Count = 100;\n\
    CGRect {OCPARAM4} = CGRectZero;\n\
    CGFloat {OCPARAM3} = 0.0;\n\
\
    for (NSInteger item = 0; item < 1; item ++ ) {\n\
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];\n\
        [{OCPARAM1} addObject:indexPath];\n\
        {OCPARAM3} = CGRectGetMaxY({OCPARAM4});\n\
    }\n"
#define MODEL_COMMON_12 @"\
    UIButton *{OCPARAM1} = [[UIButton alloc]init];\n\
    [{OCPARAM1} setContentMode:UIViewContentModeCenter];\n"
#define MODEL_COMMON_13 @"\
    UIButton *{OCPARAM3} = [[UIButton alloc]init];\n\
    UIImage *{OCPARAM2} = [UIImage imageNamed:@\"{OCPARAM1}.png\"];\n\
    {OCPARAM3}.frame = CGRectMake(0, 0, {OCPARAM2}.size.width, {OCPARAM2}.size.height);\n"
#define MODEL_COMMON_14 @"\
    UIScrollView* _{OCPARAM1}scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,200,600)];\n\
    _{OCPARAM1}scrollView.delegate = NULL;\n\
    _{OCPARAM1}scrollView.minimumZoomScale = 1.0f;\n\
    _{OCPARAM1}scrollView.maximumZoomScale = 5.0f;\n"
#define MODEL_COMMON_15 @"\
    UILabel* {OCPARAM2}Label = [[UILabel alloc] init];\n\
    {OCPARAM2}Label.text = @\"{OCPARAM1}\";\n\
    CGFloat {OCPARAM3} = 100.0f;\n\
    CGFloat {OCPARAM4} = 200.0f;\n\
    NSMutableDictionary *{OCPARAM8} = [NSMutableDictionary dictionary];\n\
    CGRect {OCPARAM7} = [{OCPARAM2}Label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:{OCPARAM8} context:nil];\n\
    CGFloat {OCPARAM5} = ({OCPARAM3} - {OCPARAM4}) * 0.5;\n\
    CGPoint {OCPARAM6} = {OCPARAM2}Label.center;\n\
    {OCPARAM6}.x = {OCPARAM5} + {OCPARAM7}.size.height;\n\
    {OCPARAM2}Label.center = {OCPARAM6};\n"
@implementation CXMetaCommon

static CXMetaCommon *_instance;
+ (CXMetaCommon *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMetaCommon alloc] init];
    }
    return _instance;
}

- (CGFloat)methodBodyMacrosCount {
    return 15;
}

- (NSArray <NSString *>*)marosArr {
    return @[
        MODEL_COMMON_1,
        MODEL_COMMON_2,
        MODEL_COMMON_3,
        MODEL_COMMON_4,
        MODEL_COMMON_5,
        MODEL_COMMON_6,
        MODEL_COMMON_7,
        MODEL_COMMON_8,
        MODEL_COMMON_9,
        MODEL_COMMON_10,
        MODEL_COMMON_11,
        MODEL_COMMON_12,
        MODEL_COMMON_13,
        MODEL_COMMON_14,
        MODEL_COMMON_15
    ];
}
@end
