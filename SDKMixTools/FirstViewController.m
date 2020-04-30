//
//  FirstViewController.m
//  SDKMixTools
//
//  Created by chr on 2020/3/16.
//  Copyright © 2020 chr. All rights reserved.
//

#import "FirstViewController.h"
#import "CXNethodsMixtueTool.h"
#import "CXMethodGenerator.h"
#import "CXRegularExpressionHelper.h"
#import "CXMetaUIView.h"
#import "NSString+CXMixture.h"


@interface FirstViewController ()

@end

@implementation FirstViewController

/// 添加前后缀
- (IBAction)cx_addPrefixes:(id)sender {
    [CXNethodsMixtueTool cx_addMethodsPrefixesForClassesAtPath:CXExternSDKRootPath prefixesArray:@[@"ling",@"jiu",@"five",@"zhuai",@"wei",@"gong",@"qiuzu",@"valuns",@"onebr",] ignoredClassNames:@[] ignoredMethodsBeginWords:@[]];
}

/// 方法乱序
- (IBAction)cx_mixUp:(id)sender {
    [CXNethodsMixtueTool cx_mixUpOrdersBetweenMethodsForClassesAtPath:CXExternSDKRootPath ignoredClassNames:@[] ignoredMethodsBeginWords:@[]];
}

/// 自动调用随机文件的随机方法
- (IBAction)cx_autoInvoke:(id)sender {
    [CXNethodsMixtueTool cx_autoInvokeRandomMethodsWithFilePath:CXExternSDKRootPath ignoredClassNames:@[
        @"CXPrivateRole.m",
        @"CXAFNetworkReachabilityManager.m",
        @"CXAFURLRequestSerialization.m",
        @"CXAFHTTPSessionManager.m",
        @"CXAFURLSessionManager.m",
        @"CXAFSecurityPolicy.m",
        @"CXHttpRequest.m",
        @"CXAFURLResponseSerialization.m",
        @"RNDecryptor.m",
        @"RNEncryptor.m"
    ]];
}

/// 在当前文件中生成随机方法并调用
- (IBAction)cx_autoGenerateMethodsAndInvoking:(id)sender {
    [CXNethodsMixtueTool cx_autoGenerateMethodsAndInvokingAtRootPath:CXExternSDKRootPath ignoredClassNames:@[
        @"CXPrivateRole.h",
        @"CXHelperFunc.h",
        @"CXGamePrivateProxy.h",
        @"CXGameDelegate.h"
    ]];
}

/// 添加属性前缀
- (IBAction)cx_addPropertyPrefixes:(id)sender {
    [CXNethodsMixtueTool cx_addPropertyPrefixesForPropertiesAtPath:CXExternSDKRootPath prefixesArray:@[@"mamo",@"ratio",@"myhome",@"sunmera" ,@"gontin"] ignoredClassNames:@[] ignoredMethodsBeginWords:@[]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    return;
    
//    NSString *testStr = [NSString cx_fileDataStrAtPath:@"/Users/chrnb/unity/SDKMixTools/SDKMixTools/FirstViewController.m"];
    __block NSString *testStr = @"[CXVar instance].sjzmeUser.uname = [[dataJson infoDict] objectForKey:P_CX_UNAME];";
    __block int count = 1;
    NSString *targetStr = @"uname";
    [CXRegularExpressionHelper cx_regularExpressionWithPatetrn:[NSString stringWithFormat:@"\\b%@\\b", targetStr] options:NSRegularExpressionDotMatchesLineSeparators sourceString:testStr usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSLog(@"第 %d 处: [ %@ ] - %@", count, [testStr substringWithRange:NSMakeRange(result.range.location-20, result.range.length + 20)], NSStringFromRange(result.range));
        testStr = [testStr stringByReplacingCharactersInRange:result.range withString:[NSString stringWithFormat:@"cxtest%@", targetStr]];
        NSLog(@"%@", testStr);
        count++;
    }];
}

@end
