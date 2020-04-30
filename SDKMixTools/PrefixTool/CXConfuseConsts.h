//
//  CXConfuseConsts.h
//  SDKMixTools
//
//  Created by chr on 2020/3/23.
//  Copyright © 2020 chr. All rights reserved.
//

#ifndef CXConfuseConsts_h
#define CXConfuseConsts_h




#define CXExternSourceFileRootPath @"/Users/cximac/Desktop/classes" // 生成方法调用时使用的外部垃圾文件存放的文件夹路径
#define CXExternSDKRootPath @"/Users/cximac/Desktop/Rlin/灵鹫宫主/SDK/CXGameSDK/SDK/classes"  // SDK的根目录路径

#define CXInvokedCountPerFile 2             //单个文件生成方法调用的次数

#define CXRandomMethodsCountToGenerate 3    //单个文件要生成的随机方法的个数

#define CXRandomMethodsPrefixMaxLength 6   //方法前缀的最大长度

//头文件完整的方法格式 eg: - (void)test; or + (NSString *)testWithParam1:(NSNumber *)p1 param2:(id)p2;
#define CXMethodSignaturePattern @"[+-][ ]*[(][A-Za-z0-9\\* _(\\^),<>]+[)][ ]*((([ ]*[A-Za-z0-9_]+[ ]*:[ ]*[(][A-Za-z0-9\\* _(\\^),<>]+[)][ ]*[A-Za-z0-9_]+[ ]*[\s]*)+)|[ ]*[A-Za-z0-9_]+)([ ]+[A-Za-z0-9_]+)?;"
// 方法名前缀格式 eg: - (void)
#define CXMethodsPrefixPattern @"[+-][ ]*[(][A-Za-z0-9\\* _(\\^),<>]+[)]"
// 参数格式 eg:(NSString *)name
#define CXMethodsParamPattern @":[ ]*[(][A-Za-z0-9\\* _(\\^),<>]+[)][ ]*[A-Za-z0-9_]+"
// 参数类型格式 eg:(NSString *)
#define CXMethodsParamTypePattern @":[ ]*[(][A-Za-z0-9\\* _(\\^),<>]+[)][ ]*"

#define CXPropertyFormatPattern @"@property[ ]*[(][ ]*[A-Za-z0-9_]+[ ]*([ ]*,[ ]*[A-Za-z0-9_]+[ ]*)*[)][ ]*[A-Za-z0-9_]+(([ ]*[\*]?[ ]*[A-Za-z0-9_]+[ ]*;)|([ ]*<[ ]*[A-Za-z0-9_]+[ ]*[\*][ ]*>[ ]*[\*][ ]*[A-Za-z0-9_]+[ ]*;))"

// 字符串常量开头格式
#define CXConstStringFormatBeginPattern @"@\"[A-Za-z0-9 =&%_@.]*"
// 字符串常量结尾格式
#define CXConstStringFormatEndPattern @"[A-Za-z0-9 =&%_@.]*\""


#define CXSourceIndexFileName @"include.md"
#define CXClassEndIdentifier @"@end"

#endif /* CXConfuseConsts_h */
