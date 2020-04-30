//
//  NSMutableString+CXMixture.h
//  SDKMixTools
//
//  Created by chr on 2020/4/2.
//  Copyright © 2020 chr. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableString (CXMixture)
- (void)cx_mutableStringByDeletingTrailingCharactersWithCount:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
