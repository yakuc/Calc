//
//  NSDecimalNumber+Calc.m
//  Calc
//
//  Created by YAKUC on 2012/11/24.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import "NSDecimalNumber+Calc.h"

@implementation NSDecimalNumber (Calc)

- (NSDecimalNumber *)sqrt
{
    if ([self compare:[NSDecimalNumber zero]] == NSOrderedAscending)
    {
        return [NSDecimalNumber notANumber];
    }
    
    NSDecimalNumber *half =
    [NSDecimalNumber decimalNumberWithMantissa:5 exponent:-1 isNegative:NO];
    NSDecimalNumber *guess =
    [[self decimalNumberByAdding:[NSDecimalNumber one]]
     decimalNumberByMultiplyingBy:half];
    
    @try
    {
        const int NUM_ITERATIONS_TO_CONVERGENCE = 6;
        for (int i = 0; i < NUM_ITERATIONS_TO_CONVERGENCE; i++)
        {
            guess =
            [[[self decimalNumberByDividingBy:guess]
              decimalNumberByAdding:guess]
             decimalNumberByMultiplyingBy:half];
        }
    }
    @catch (NSException *exception)
    {
        // deliberately ignore exception and assume the last guess is good enough
    }
    
    return guess;
}

/**
 桁数計算
 */
- (NSInteger)digits
{
    NSInteger digit = 0;

    NSDecimal decimal = [self decimalValue];

    if (decimal._exponent > 0) {
        return decimal._exponent + 1;
    }
    
    for (int i = 0; i < decimal._length; i++) {
        unsigned short mantissa = decimal._mantissa[i];
        NSInteger tmpDigit = 0;
        
        for (tmpDigit = 0; mantissa != 0; tmpDigit++) {
            mantissa /= 10;
        }
        
        digit += tmpDigit;
    }
    return digit;
}

@end
