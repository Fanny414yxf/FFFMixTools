//
//  NSMutableString+CXMixture.m
//  SDKMixTools
//
//  Created by chr on 2020/4/2.
//  Copyright © 2020 chr. All rights reserved.
//

#import "NSMutableString+CXMixture.h"

@implementation NSMutableString (CXMixture)

- (void)cx_mutableStringByDeletingTrailingCharactersWithCount:(NSInteger)count {
    [self deleteCharactersInRange:NSMakeRange(self.length-count, count)];
}


@end
