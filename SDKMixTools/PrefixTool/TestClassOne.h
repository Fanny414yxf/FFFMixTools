//
//  TestClassOne.h
//  TestDemo
//
//  Created by chr on 2020/3/16.
//  Copyright © 2020 chr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TestProtocol <NSObject>

/// 测试方法1
- (void)testMethod1InTestProtocol;

/// 测试方法3
/// @param param1 参数1
/// @param param2 参数2
- (void)testMethod3InTestProtocol:(NSString *)param1 param2:(NSString *)param2;

/// 测试方法2
/// @param param1 参数1
- (void)testMethod2InTestProtocol:(NSString *)param1;

/// 测试方法4
/// @param param1 参数1
+ (void)testMethod4InTestProtocol:(NSString *)param1;

/// 测试方法5
/// @param param1 参数1
/// @param param2 参数2
+ (void)testMethod3InTestProtocol:(NSString *)param1 param2:(NSString *)param2;

@end

@interface AnotherClass : NSObject<TestProtocol>

/// 测试方法1
- (void)testMethod1InAnotherClass;

/// 测试方法5
/// @param param1 参数1
/// @param param2 参数2
+ (void)testMethod3InAnotherClass:(NSString *)param1 param2:(NSString *)param2;

/// 测试方法3
/// @param param1 参数1
/// @param param2 参数2
- (void)testMethod3InAnotherClass:(NSString *)param1 param2:(NSString *)param2;

/// 测试方法4
/// @param param1 参数1
+ (void)testMethod4InAnotherClass:(NSString *)param1;

/// 测试方法2
/// @param param1 参数1
+ (void)testMethod2InAnotherClass:(NSString *)param1;

@end

@interface TestClassOne : NSObject

/// 测试方法1
- (void)testMethod1InTestClassOne;

/// 测试方法4
/// @param param1 参数1
+ (void)testMethod4InTestClassOne:(NSString *)param1;

/// 测试方法3
/// @param param1 参数1
/// @param param2 参数2
- (void)testMethod3InTestClassOne:(NSString *)param1 param2:(NSString *)param2;

/// 测试方法2
/// @param param1 参数1
+ (void)testMethod2InTestClassOne:(NSString *)param1;

/// 测试方法5
/// @param param1 参数1
/// @param param2 参数2
+ (void)testMethod3InTestClassOne:(NSString *)param1 param2:(NSString *)param2;


@end

NS_ASSUME_NONNULL_END
