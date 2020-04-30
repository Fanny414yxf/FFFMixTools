//
//  CXMethodGenerator.m
//  SDKMixTools
//
//  Created by chr on 2020/3/17.
//  Copyright © 2020 chr. All rights reserved.
//

#import "CXMethodGenerator.h"
#import "CXObjectEntity.h"
#import "CXMethodEntity.h"
#import "NSString+CXMixture.h"
#import "CXMethodsListHelper.h"
#import "CXMethodMetaDataHelper.h"
#import "CXRegularExpressionHelper.h"
#import "NSString+CXMixture.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-escape-sequence"
static CXMethodGenerator *_instance;

@interface CXMethodGenerator ()
#pragma mark 生成方法
/// 存放该某个类下随机生成的方法签名
@property (nonatomic, strong) NSMutableArray *methodSignatures;
@property (nonatomic, strong) CXMethodMetaDataHelper *methodHelper;

#pragma mark - 打乱顺序

#pragma mark 调用随机文件的方法
@property (nonatomic, strong) NSMutableArray <NSString *>*importsArr;
@property (nonatomic, strong) NSMutableArray <NSString *>*ignoredClsArrForInvoking;

@end
@implementation CXMethodGenerator

#pragma mark public

+ (CXMethodGenerator *)sharedInstance {
    if (_instance == nil) {
        _instance = [[CXMethodGenerator alloc] init];
    }
    return _instance;
}

- (void)cx_clean {
    // 清空签名数组
    [self.methodSignatures removeAllObjects];
}

#pragma mark initializations
- (instancetype)init {
    if (self = [super init]) {
        [self cx_setup];
    }
    return self;
}

- (void)cx_setup {
    self.methodSignatures = [NSMutableArray array];
}

#pragma mark - 打乱方法顺序
/**
* 思路1:
* 1、通过 @implementation 标志符切割字符串 --> 得到各个类的实现部分的字符串数组（第一个元素不处理）
* 2、遍历各个类的实现字符串，先用找到所有 -(void)、+(void)之类的方法开始的位置并记录下来
* 3、然后交换中间方法的顺序
*/
/// 打乱指定路径下文件的方法顺序
/// @param filePath 文件路径
- (void)cx_confuseMethodsWithFilePath:(NSString *)filePath {
    NSError *error = nil;
    NSString *fileDataStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (fileDataStr.length == 0) return;
    // 过滤掉条包含件编译的文件
    if ([fileDataStr cx_hasConditionCompiles]) {
        NSLog(@"过滤掉含条件编译的文件: %@", filePath.lastPathComponent);
        return;
    }
    
    // .h 文件处理
    if ([filePath.lastPathComponent hasSuffix:@".h"]) {
        [self cx_confuseMethodsWithHeaderFilePath:filePath fileDataString:fileDataStr];
        return;
    }
    
    // .m 文件处理
    [self cx_confuseMethodsWithImplementationFilePath:filePath fileDataString:fileDataStr];
}

/// 处理 .m 文件
/// @param filePath 文件路径
/// @param fileDataStr 内容字符串
- (void)cx_confuseMethodsWithImplementationFilePath:(NSString *)filePath fileDataString:(NSString *)fileDataStr {
        NSArray <NSString *>*classesImpArr = [fileDataStr componentsSeparatedByString:@"@implementation"];
        if (classesImpArr.count<2) {
            NSLog(@"类实现切割失败:%@", filePath.lastPathComponent);
            return;
        }
        
        NSString *methodBeginsPattern = CXMethodsPrefixPattern;
        __block NSError *errorPattern = nil;
        NSMutableArray *confusedArr = [NSMutableArray arrayWithCapacity:classesImpArr.count];
        
        [classesImpArr enumerateObjectsUsingBlock:^(NSString * _Nonnull singleImp, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray <NSTextCheckingResult *>*resultsArr = [NSMutableArray array];
            NSMutableArray <NSString *>*methodsArr = [NSMutableArray array];
            
            // 匹配前缀
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:methodBeginsPattern options:NSRegularExpressionCaseInsensitive error:&errorPattern];
//            NSLog(@"当前方法实现：\n%@", singleImp);
            
            [regex enumerateMatchesInString:singleImp options:NSMatchingReportCompletion range:NSMakeRange(0, [singleImp length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    if (errorPattern) {
                        NSLog(@"方法格式匹配出错：%@", errorPattern);
                    }
                    if (result) {
//                        NSString *prefixStr = [singleImp substringWithRange:result.range];
//                        NSLog(@"%@:%@", prefixStr, NSStringFromRange(result.range));
                        [resultsArr addObject:result];
                    }
            }];
            
            // rangesArr 保存除去首尾之外的所有方法的起始位置的range值
            NSMutableArray <NSString *>*rangesArr = [NSMutableArray arrayWithCapacity:resultsArr.count];
            
            if (resultsArr.count == 0) {
                [confusedArr addObject:singleImp];
                return;
            }
            
            [rangesArr addObject:NSStringFromRange(resultsArr[0].range)];
            // 处理方法注释、空白换行ect..
            NSInteger resultsCount = resultsArr.count;
            for (int i=0; i<resultsCount-1; i++) {
                
                NSTextCheckingResult *currentResult = resultsArr[i];
                NSTextCheckingResult *nextResult = resultsArr[i+1];
                
                NSUInteger currentLoc = currentResult.range.location;
                NSUInteger nextLoc = nextResult.range.location;
                
                NSString *currentMethod = [singleImp substringWithRange:NSMakeRange(currentLoc, nextLoc - currentLoc)];
                NSRange endRange = [currentMethod rangeOfString:@"}" options:NSBackwardsSearch];
                if (endRange.location != NSNotFound) {
                    NSRange range = NSMakeRange(currentResult.range.location + endRange.location + 1, nextResult.range.length);
                    [rangesArr addObject:NSStringFromRange(range)];
                }
            }
            
            __block NSInteger location = 0;
            
            [rangesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull rangeStr, NSUInteger idx, BOOL * _Nonnull stop) {
                NSRange range = NSRangeFromString(rangeStr);
                NSString *method = [singleImp substringWithRange:NSMakeRange(location, range.location - location)];
                [methodsArr addObject:method];
                location += method.length;
                if (idx == rangesArr.count-1) {
                    NSString *lastMethod = [singleImp substringFromIndex:location];
                    [methodsArr addObject:lastMethod];
                }
            }];
            
//            NSLog(@"方法体列表：%@", methodsArr);
            NSInteger count = methodsArr.count;
            if (count<4) {
               [confusedArr addObject:singleImp];
               return;
           }
            
            if (count == 4) {
                // 总数为4 -> 交换中间两个方法顺序
                [methodsArr exchangeObjectAtIndex:1 withObjectAtIndex:2];
            } else {
                // 总数为n（n >= 5）-> 包含(n-2)的全排列即 (n-2)! 种顺序，简单起见随机交换10次
                for (int i=0; i<10; i++) {
                    NSInteger firstIndex = arc4random_uniform((uint32_t)(count)-2)+1;
                    NSInteger secondIndex = arc4random_uniform((uint32_t)(count)-2)+1;
                    while (secondIndex == firstIndex) {
                        secondIndex = arc4random_uniform((uint32_t)(count)-2)+1;
                    }
                    [methodsArr exchangeObjectAtIndex:firstIndex withObjectAtIndex:secondIndex];
                }
            }
            NSString *finalStr = [methodsArr componentsJoinedByString:@"\n"];

            [confusedArr addObject:finalStr];
        }];
        
        NSString *resultStr = [confusedArr componentsJoinedByString:@"@implementation"];
        NSError *errorWritten = nil;
        [resultStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&errorWritten];
        if (errorWritten) {
            NSLog(@"fatal error：方法打乱后写入文件失败:\n\t文件名:%@ ", [filePath lastPathComponent]);
        } else {
            NSLog(@"方法方法打乱后写入文件成功:\n\t文件名:%@", [filePath lastPathComponent]);
        }
    
}

/// 处理 .h 文件
/// @param filePath 文件路径
/// @param fileDataStr 内容字符串
- (void)cx_confuseMethodsWithHeaderFilePath:(NSString *)filePath fileDataString:(NSString *)fileDataStr {
    NSArray <NSString *>*classesDeclarationArr = [fileDataStr componentsSeparatedByString:@"@interface"];
    if (classesDeclarationArr.count<2) {
        NSLog(@"类声明文件切割失败:%@", filePath.lastPathComponent);
        return;
    }
    NSMutableArray *confusedArr = [NSMutableArray arrayWithCapacity:classesDeclarationArr.count];
    NSString *methodBeginsPattern = CXMethodSignaturePattern;
    __block NSError *errorPattern = nil;
    
    [classesDeclarationArr enumerateObjectsUsingBlock:^(NSString * _Nonnull declaration, NSUInteger idx, BOOL * _Nonnull stop) {
        if (declaration.length == 0) return;
        
        // 匹配前缀
        NSMutableArray <NSTextCheckingResult *>*resultsArr = [NSMutableArray array];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:methodBeginsPattern options:NSRegularExpressionCaseInsensitive error:&errorPattern];
//        NSLog(@"当前方法实现：\n%@", declaration);
        
        [regex enumerateMatchesInString:declaration options:NSMatchingReportCompletion range:NSMakeRange(0, [declaration length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                if (errorPattern) {
                    NSLog(@"方法格式匹配出错：%@", errorPattern);
                    return;
                }
                if (result) {
//                    NSString *prefixStr = [declaration substringWithRange:result.range];
//                    NSLog(@"%@:%@", prefixStr, NSStringFromRange(result.range));
                    [resultsArr addObject:result];
                }
        }];
        
        // rangesArr 保存除去首尾之外的所有方法的起始位置的range值
        if (resultsArr.count == 0) {
            [confusedArr addObject:declaration];
            return;
        }
        
        // 处理所有方法
        __block NSTextCheckingResult *lastResult = nil;
        NSMutableArray <NSString *>*methodsArr = [NSMutableArray array];
        [resultsArr enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull method, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                [methodsArr addObject:[declaration substringToIndex:method.range.location+method.range.length]];
                lastResult = method;
                return;
            }
            [methodsArr addObject:[declaration substringWithRange:NSMakeRange(lastResult.range.location + lastResult.range.length, method.range.location - lastResult.range.location - lastResult.range.length + method.range.length)]];
            lastResult = method;
        }];
                
//        NSLog(@"方法体列表：%@", methodsArr);
        NSInteger count = methodsArr.count;
        if (count<3) {
            [confusedArr addObject:declaration];
            return;
        }
        
        if (count == 3) {
            // 总数为3 -> 交换最后两个方法顺序
            [methodsArr exchangeObjectAtIndex:1 withObjectAtIndex:2];
        } else {
            // 总数为n（n >= 3）-> 包含(n-1)的全排列即 (n-1)! 种顺序，简单起见随机交换10次
            for (int i=0; i<10; i++) {
                NSInteger firstIndex = arc4random_uniform((uint32_t)(count)-1)+1;
                NSInteger secondIndex = arc4random_uniform((uint32_t)(count)-1)+1;
                while (secondIndex == firstIndex) {
                    secondIndex = arc4random_uniform((uint32_t)(count)-1)+1;
                }
                [methodsArr exchangeObjectAtIndex:firstIndex withObjectAtIndex:secondIndex];
            }
        }
        NSString *finalStr = [methodsArr componentsJoinedByString:@""];
        finalStr = [finalStr stringByAppendingString:[declaration substringFromIndex:lastResult.range.location+lastResult.range.length]];
        
        [confusedArr addObject:finalStr];
    }];
    NSString *resultStr = [confusedArr componentsJoinedByString:@"@interface"];
    
    [resultStr cx_writeToFile:filePath];
}

#pragma mark - 调用现有文件的方法

- (void)cx_invokeRandomMothodInRandomFileAtRootFilePath:(NSString *)rootPath
                                      ignoredClassNames:(NSArray <NSString *>*)ignoredClassNames {
    if (self.importsArr.count == 0) return;
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:&isDir];
    if (!isExist) return;
    if (isDir) {
        NSArray * dirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:rootPath error:nil];
        NSString * subPath = nil;
        for (NSString * str in dirArray) {
            subPath  = [rootPath stringByAppendingPathComponent:str];
            [self cx_invokeRandomMothodInRandomFileAtRootFilePath:subPath ignoredClassNames:ignoredClassNames];
        }
    }else{  // 是 m 文件
        if ([rootPath hasSuffix:@".m"] && ![ignoredClassNames containsObject:rootPath.lastPathComponent]) {
            
            BOOL isPreloginViewCls = [rootPath.lastPathComponent containsString:@"CXPreLoginView"];
            BOOL isPreRegisterViewCls = [rootPath.lastPathComponent containsString:@"CXPreRegistView"];
//            BOOL isCoreCls = [rootPath containsString:@"/core/"];
            BOOL isCXSDKCls = [rootPath.lastPathComponent isEqualToString:@"CXSDK.m"];
            
            BOOL shouldAdd = isCXSDKCls ||isPreloginViewCls || isPreRegisterViewCls;
            // 测试只在 core目录下文件 跟 审核UI类中调用
            if (!shouldAdd) return;
            
            // 最后一个 import
            NSError *error = nil;
            NSString *fileDataStr = [NSString stringWithContentsOfFile:rootPath encoding:NSUTF8StringEncoding error:&error];
            if (fileDataStr.length == 0) return;
            
            NSArray <NSString *>*methodsArr = [fileDataStr cx_detectMethodsImplementations];
            NSInteger count = [self cx_invokedMethodsCountWithCurrentMethodsCount:methodsArr.count];
            for (int i=0; i<count; i++) {
                NSInteger randomIdx = arc4random_uniform((uint32_t)(self.importsArr.count));
                NSString *importStr = self.importsArr[randomIdx];
                NSString *invokedStr = [self cx_generateRandomMethodInvokedStringForHeaderFileImportedString:importStr];
                NSString *importsPattern = @"#import[ ]+\"[A-Za-z0-9+_\/]+.h\"";
                __block NSError *errorImport = nil;
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:importsPattern options:NSRegularExpressionCaseInsensitive error:&errorImport];
                
                __block NSTextCheckingResult *lastResult = nil;
                [regex enumerateMatchesInString:fileDataStr options:NSMatchingReportCompletion range:NSMakeRange(0, [fileDataStr length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    if (result) {
                        lastResult = result;
                    }
                }];
                if (lastResult) {
                    NSUInteger insertLocation = lastResult.range.location+lastResult.range.length;
                    fileDataStr = [NSString stringWithFormat:@"%@\n%@\n%@", [fileDataStr substringToIndex:insertLocation], importStr, [fileDataStr substringFromIndex:insertLocation]];
                }
                
                NSArray <NSString *>*methodsArr = [fileDataStr cx_detectMethodsImplementations];
                if (methodsArr.count == 0) {
                    NSLog(@"%@ 中没有实现任何方法，随机方法调用注入中断！！！", rootPath.lastPathComponent);
                    return;
                }
                if (methodsArr.count<2) return;
                
                NSInteger methodsCount = methodsArr.count;
                // 　排除第一个（不是方法）
                NSInteger idx = arc4random_uniform((uint32_t)(methodsCount-1))+1;
                NSString *methodStr = methodsArr[idx];
                while ([methodStr containsString:@"dealloc"]) {
                    idx = arc4random_uniform((uint32_t)(methodsCount-1))+1;
                    methodStr = methodsArr[idx];
                }
                NSRange methodRange = [fileDataStr rangeOfString:methodStr];
                NSRange endRange;
                if ([methodStr containsString:CXClassEndIdentifier]) {
                    NSRange endRange = [methodStr rangeOfString:CXClassEndIdentifier];
                    NSString * methodStrTmp = [methodStr substringToIndex:endRange.location];
                    endRange = [methodStrTmp rangeOfString:@"}" options:NSBackwardsSearch];
                }
                endRange = [methodStr rangeOfString:@"}" options:NSBackwardsSearch];
                NSString *trailingStr = @"";
                
                if (endRange.location != NSNotFound) {
                    trailingStr = [methodStr substringFromIndex:endRange.location+1];
                    methodStr = [methodStr substringToIndex:endRange.location];
                }
                
                methodStr = [methodStr stringByAppendingFormat:@"\n%@\n}%@", invokedStr, trailingStr];
                NSLog(@"随机获取的方法体为：%@", methodStr);
                fileDataStr = [fileDataStr stringByReplacingCharactersInRange:methodRange withString:methodStr];
                
                NSError *errorWritten = nil;
                [fileDataStr writeToFile:rootPath atomically:YES encoding:NSUTF8StringEncoding error:&errorWritten];
                if (errorWritten) {
                    NSLog(@"fatal error：调用随机方法后写入失败:\n\t文件名:%@ ", [rootPath lastPathComponent]);
                } else {
                    NSLog(@"调用随机方法后写入成功:\n\t文件名:%@", [rootPath lastPathComponent]);
                }
            }
        }
    }
}

- (NSInteger)cx_invokedMethodsCountWithCurrentMethodsCount:(NSInteger)currentCount {
    if (currentCount <= 5) return CXInvokedCountPerFile;
    return MAX(5, currentCount / 2);
}

/// 生成随机调用随机方法的格式字符串
/// @param importedStr 文件 import 字符串
- (NSString *)cx_generateRandomMethodInvokedStringForHeaderFileImportedString:(NSString *)importedStr {
    
    // 获取文件名
    NSRange beginRange = [importedStr rangeOfString:@"\""];
    NSString *importFileName = [importedStr substringFromIndex:beginRange.location+1];
    importFileName = [importFileName substringToIndex:importFileName.length-1];//[importFileName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *className = [importFileName stringByReplacingOccurrencesOfString:@".h" withString:@""];
    // 获取 importFileName 中的方法列表
    
    NSString *rootPath = CXExternSourceFileRootPath;
    NSString *importFilePath = nil;
    [self cx_getExternSourceFilePathWithFileName:importFileName rootFilePath:rootPath destinationFilePath:&importFilePath];
    //[[NSBundle mainBundle] pathForResource:@"CXMethodsPrefixTool" ofType:@"m"];//importFileName
    if (importFilePath.length == 0) {
        NSLog(@"获取文件路径失败！！");
        return nil;
    }
    NSArray <NSString *>*methodsList = [CXMethodsListHelper cx_methodsArrayForHeaderFile:importFilePath];
    if (methodsList.count == 0) {
        NSLog(@"%@ 中没没有找到任何方法!!!!", importFilePath.lastPathComponent);
        return nil;
    }
    
    CXObjectEntity *object = [[CXObjectEntity alloc] init];
    object.className = className;
    object.methodsList = methodsList;
    NSString *invokedStr = [object cx_getRandomMethodInvokedString];
    return  invokedStr;
}

/// 根据 随机获取的 #import “XXXX” 字符串寻找该文件的路径
- (void)cx_getExternSourceFilePathWithFileName:(NSString *)fileName rootFilePath:(NSString *)rootPath destinationFilePath:(NSString **)destPath {
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:&isDir];
    if (!isExist) return;
    
    if (isDir) {    // 目录
        NSArray * dirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:rootPath error:nil];
        NSString * subPath = nil;
        for (NSString * str in dirArray) {
            subPath  = [rootPath stringByAppendingPathComponent:str];
            
            [self cx_getExternSourceFilePathWithFileName:fileName rootFilePath:subPath destinationFilePath:destPath];
        }
    }else{  // 文件
        if ([rootPath.lastPathComponent isEqualToString:fileName]) {
            *destPath = rootPath;
            return;
        }
    }
}

- (NSString *)cx_pathOfIndexFile {
    NSString *rootPath = CXExternSourceFileRootPath;
    NSString *indexFilePath = nil;
    [self cx_getExternSourceFilePathWithFileName:CXSourceIndexFileName rootFilePath:rootPath destinationFilePath:&indexFilePath];
    NSLog(@"索引文件路径：%@", indexFilePath);
    return indexFilePath;
}


#pragma mark - 自动生成方法并调用
- (void)cx_autoGenerateMethodsAndInvokingAtRootPath:(NSString *)rootPath
                                  ignoredClassNames:(NSArray<NSString *> *)ignoredClassNames
                                        headerFiles:(NSArray *)headersArr {
    if (headersArr.count == 0) return;
    // 遍历所有头文件
    [headersArr enumerateObjectsUsingBlock:^(NSString *_Nonnull headerPath, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([ignoredClassNames containsObject:headerPath.lastPathComponent]) return;
        NSMutableString *hFileDataStr = [[NSString cx_fileDataStrAtPath:headerPath] mutableCopy];
        if (hFileDataStr.length == 0) return;
        if (![hFileDataStr containsString:CXClassEndIdentifier]) return;
        NSString *mFilePath = nil;
        [NSString cx_implementationFilePathWithHeaderFilePath:headerPath rootFilePath:rootPath pathResult:&mFilePath];
        if (mFilePath == nil) {
            NSLog(@"没找到 %@ 文件", [NSString stringWithFormat:@"%@.m", [headerPath.lastPathComponent cx_stringByDeletingTrailingCharactersWithCount:2]]);
        }
        NSMutableString *mFileDataStr = [[NSString cx_fileDataStrAtPath:mFilePath] mutableCopy];

        NSError *error = nil;
        NSString *fileDataStr = [NSString stringWithContentsOfFile:mFilePath encoding:NSUTF8StringEncoding error:&error];
        if (fileDataStr.length == 0) return;
        NSArray <NSString *>*methodsArr = [fileDataStr cx_detectMethodsImplementations];
        
        NSInteger count = [self cx_invokedMethodsCountWithCurrentMethodsCount:methodsArr.count];
        NSInteger methodsCount = [mFilePath containsString:@"/core/"] ? count>>1 : CXRandomMethodsCountToGenerate;
        if ([mFilePath.lastPathComponent isEqualToString:@"CXSDK.m"]) methodsCount = CXRandomMethodsCountToGenerate;
        NSMutableArray <NSNumber *>*indexArr = [NSMutableArray arrayWithCapacity:methodsCount];
        for (int i=0; i<methodsCount; i++) {
            CXMethodEntity *methodEntity = [self cx_generateARandomMethodEntity];
            NSString *methodSignation = [methodEntity methodsSignature];
            NSString *methodsImplementation = methodEntity.methodsImplementation;
            
            {
                // 将methodSignation插入到fileDataStr中
                hFileDataStr = [[NSString cx_fileDataStrAtPath:headerPath] mutableCopy];
                NSArray <NSString *>*methodList = [CXMethodsListHelper cx_methodsArrayForHeaderFile:headerPath];
                NSString *insertIdentifier = methodList.count ? methodList.lastObject : CXClassEndIdentifier;
                
                [hFileDataStr insertString:[NSString stringWithFormat:@"%@\n", methodSignation] atIndex:[hFileDataStr rangeOfString:insertIdentifier].location];
//                NSLog(@"header file: %@", hFileDataStr);
                [hFileDataStr cx_writeToFile:headerPath];
            }
            
            {
                // 定位到 m 文件，将方法实现插入到其中
                NSArray <NSString *>*methodsArr = [CXMethodsListHelper cx_methodsArrayWithImplementationFileDataStr:mFileDataStr];
                if (methodsArr.count == 0) return;
                
                NSString *lastMethod = methodsArr.lastObject;
                [mFileDataStr insertString:[NSString stringWithFormat:@"\n%@", methodsImplementation] atIndex:[mFileDataStr rangeOfString:lastMethod].location];
//                NSLog(@"implementation file: %@", mFileDataStr);
                // m文件没有多个类的实现的情况下，并且排除掉 view 和 net 文件夹下的类  避免UI交互卡顿的现象，调用生成的方法
                BOOL isNetwrokCls = [mFilePath containsString:@"/net/"];
                BOOL isViewCls = NO;//[mFilePath containsString:@"/view/"];
                
                // 是否需要调用生成的方法，大致的判断逻辑：
                // 1、只有一个类实现，避免调用方法类中没有实现该方法而报错；
                // 2、非网络层的类，避免子线程操作UI引起crash；
                // 3、有方法实现，向倒数第二个及之前的方法中随机插入调用语句；
                // 4、方便起见，目前只想实例方法中添加调用。
                BOOL shouldInvoke = ![mFileDataStr cx_hasMultiClasses] && !isNetwrokCls && !isViewCls && methodsArr.count > 1;
                if (shouldInvoke) {
                    // 随机在其中个某个方法中调用该方法
                    NSInteger idx = arc4random_uniform((uint32_t)(methodsArr.count-i-2))+1;
                    while ([indexArr containsObject:@(idx)]) {
                        idx = arc4random_uniform((uint32_t)(methodsArr.count-i-2))+1;
                    }
                    [indexArr addObject:@(idx)];
                    
                    NSString *randomMethod = methodsArr[idx];
                    // [[randomMethod stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:@"-"]
                    NSString *randomMethodName = [randomMethod substringToIndex:[randomMethod rangeOfString:@"{"].location];
                    BOOL shouldAdd = [randomMethodName containsString:@"-"];
                    if ([randomMethodName containsString:@"dealloc]"]) shouldAdd = NO;
                    if ([self.ignoredClsArrForInvoking containsObject:mFilePath.lastPathComponent]) shouldAdd = NO;
                    if (shouldAdd) {
                        NSString *invokingStr = methodEntity.invokingString;
                        NSRange range = [mFileDataStr rangeOfString:randomMethod];
                        [mFileDataStr insertString:invokingStr atIndex:range.location+range.length-1];
                        NSLog(@"文件：%@第 %d 个方法调用成功", mFilePath.lastPathComponent, i);
                    } else {
                        NSLog(@"文件：%@第 %d 个方法调用失败，不是实例方法:%@", mFilePath.lastPathComponent, i, [randomMethod substringToIndex:[randomMethod rangeOfString:@"{"].location]);
                    }
                }
                [mFileDataStr cx_writeToFile:mFilePath];
            }
        }
    }];
}

- (CXMethodEntity *)cx_generateARandomMethodEntity {
    CXMethodEntity *methodEntity = [[CXMethodEntity alloc] init];
    // 返回值
    CXMethodParam *returnType = [self.methodHelper cx_generateARandomReturnTypeParam];
    methodEntity.returnType = returnType;
    
    // 参数、方法名列表
    NSInteger randomParamsCount = [self.methodHelper cx_randomParamsCount];
    if (randomParamsCount == 0) {
        NSString *methodSeg = [self.methodHelper cx_generateARandomMethodSegmentNameAtIndex:0];
        [methodEntity.methodNameSegments addObject:methodSeg];
    } else {
        for (int i=0; i<randomParamsCount; i++) {
            
            NSString *methodSeg = [self.methodHelper cx_generateARandomMethodSegmentNameAtIndex:i];
            CXMethodParam *param = [self.methodHelper cx_generateARandomMethodParamWithMethodSegString:methodSeg];
            NSString *paramName = [methodSeg cx_stringWithReversedFirstCapitalizedLetterComponentsCount:2];
            param.paramName = paramName;
            [methodEntity.params addObject:param];
            [methodEntity.methodNameSegments addObject:methodSeg];
        }
    }
    return methodEntity;
}

#pragma mark - lazy
- (CXMethodMetaDataHelper *)methodHelper {
    if (_methodHelper == nil) {
        _methodHelper = [CXMethodMetaDataHelper sharedInstance];
    }
    return _methodHelper;
}

- (NSMutableArray<NSString *> *)importsArr {
    if (_importsArr == nil || _importsArr.count == 0) {
        _importsArr = [NSMutableArray array];
        
        NSString *indexFilePath = [self cx_pathOfIndexFile];
        NSError *error = nil;
        NSString *fileDataStr = [NSString stringWithContentsOfFile:indexFilePath encoding:NSUTF8StringEncoding error:&error];
        
        if (fileDataStr.length == 0) return _importsArr;
        
        NSLog(@"找到索引文件，开始根据文件内容给其他文件调用垃圾方法");
        
        // 获取索引文件中所有的 #improt XXX 内容
        // #import "everything/EveryBreadfruitFragmentedSequencing.h"
        NSString *importsPattern = @"#import[ ]+\"[A-Za-z0-9_\/]+.h\"";
        __block NSError *errorPattern = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:importsPattern options:NSRegularExpressionCaseInsensitive error:&errorPattern];
        [regex enumerateMatchesInString:fileDataStr options:NSMatchingReportCompletion range:NSMakeRange(0, [fileDataStr length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                if (errorPattern) {
                    NSLog(@"import格式匹配出错：%@", errorPattern);
                    return;
                }
                if (result) {
                    NSString *importStr = [fileDataStr substringWithRange:result.range];
                    if ([importStr containsString:@"/"]) {
                        NSRange lastCompRange = [importStr rangeOfString:@"/" options:NSBackwardsSearch];
                        NSRange beginCompRange = [importStr rangeOfString:@"\"" options:kNilOptions];
                        importStr = [importStr stringByReplacingCharactersInRange:NSMakeRange(beginCompRange.location+1, lastCompRange.location - beginCompRange.location) withString:@""];
                        
                    }
                    [self->_importsArr addObject:importStr];
                }
        }];
    }
    return _importsArr;
}

- (NSMutableArray<NSString *> *)ignoredClsArrForInvoking {
    if (_ignoredClsArrForInvoking == nil) {
        _ignoredClsArrForInvoking = [NSMutableArray array];
        [_ignoredClsArrForInvoking addObjectsFromArray:@[
            @"CXTimers.m",
            @"CXVar.m"
        ]];
    }
    return _ignoredClsArrForInvoking;
}

#pragma clang diagnostic pop

@end

