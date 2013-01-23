//
//  NSDecimalNumber+Calc.h
//  Calc
//
//  Created by YAKUC on 2012/11/24.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (Calc)

/**
 √の演算
 参考：http://www.cocoawithlove.com/2008/05/square-root-numerical-fun-with.html
 */
- (NSDecimalNumber *)sqrt;

/**
 桁数計算
 */
- (NSInteger)digits;

@end
