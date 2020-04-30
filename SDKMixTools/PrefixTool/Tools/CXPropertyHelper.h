//
//  CXPropertyHelper.h
//  SDKMixTools
//
//  Created by chr on 2020/4/13.
//  Copyright © 2020 chr. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXPropertyHelper : NSObject

+ (NSArray <NSString *>*)cx_propertyListForHeaderFilePath:(NSString *)headerFilePath;

+ (NSString *)cx_truncatePropertyNameWithPropertyStr:(NSString *)propertyStr;

@end

NS_ASSUME_NONNULL_END
