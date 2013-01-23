//
//  CCalcModel.m
//  Calc
//
//  Created by YAKUC on 2012/11/12.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import "CCalcModel.h"
#import "CNumberInputStatus.h"
#import "CResultStatus.h"

@implementation CCalcModel

- (id)init
{
    self = [super init];
    if (self) {
        self.calcStatus = [[CNumberInputStatus alloc] init];
    }
    return self;
}

- (void)changeErrorMark:(BOOL)status
{
    if ([self.delegate respondsToSelector:@selector(calcModel:changeErrorMark:)]) {
        [self.delegate calcModel:self changeErrorMark:status];
    }
}

/**
 数値の入力
 */
- (void)inputNumber:(NSInteger)number
{
    // メモリに値が入っている場合はMRキーモードにする
    if (self.memoryValue != nil) {
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
            [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusRecall];
        }
    }
    
    [self changeErrorMark:NO];
    
    if ([self.calcStatus respondsToSelector:@selector(inputNumber:model:)]) {
        [self.calcStatus inputNumber:number model:self];
    }
}

/**
 演算子の入力
 */
- (void)inputOperator:(CCalcOperator)operator
{
    // メモリに値が入っている場合はMRキーモードにする
    if (self.memoryValue != nil) {
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
            [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusRecall];
        }
    }
    [self changeErrorMark:NO];

    if ([self.calcStatus respondsToSelector:@selector(inputOperator:model:)]) {
        [self.calcStatus inputOperator:operator model:self];
    }
}

/**
 = の入力
 */
- (void)inputEqual
{
    // メモリに値が入っている場合はMRキーモードにする
    if (self.memoryValue != nil) {
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
            [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusRecall];
        }
    }
    [self changeErrorMark:NO];

    if ([self.calcStatus respondsToSelector:@selector(inputEqual:)]) {
        [self.calcStatus inputEqual:self];
    }
}

/**
 サインチェンジ（+-)キーの入力
 */
- (void)inputSignChange
{
    // メモリに値が入っている場合はMRキーモードにする
    if (self.memoryValue != nil) {
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
            [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusRecall];
        }
    }

    if ([self.calcStatus respondsToSelector:@selector(inputSignChange:)]) {
        [self.calcStatus inputSignChange:self];
    }
}

/**
 小数点の入力
 */
- (void)inputDot
{
    // メモリに値が入っている場合はMRキーモードにする
    if (self.memoryValue != nil) {
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
            [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusRecall];
        }
    }

    if ([self.calcStatus respondsToSelector:@selector(inputDot:)]) {
        [self.calcStatus inputDot:self];
    }    
}

/**
 関数演算
 */
- (void)inputFunc:(CCalcFunc)func
{
    // メモリに値が入っている場合はMRキーモードにする
    if (self.memoryValue != nil) {
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
            [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusRecall];
        }
    }

    if ([self.calcStatus respondsToSelector:@selector(inputFunc:model:)]) {
        [self.calcStatus inputFunc:func model:self];
    }    
}

/**
 クリアーキーの入力
 */
- (void)inputClear
{
    // メモリに値が入っている場合はMRキーモードにする
    if (self.memoryValue != nil) {
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
            [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusRecall];
        }
    }
    [self changeErrorMark:NO];

    if ([self.calcStatus respondsToSelector:@selector(inputClear:)]) {
        [self.calcStatus inputClear:self];
    }
}

/**
 オールクリアーキーの入力
 */
- (void)inputAllClear
{
    // メモリに値が入っている場合はMRキーモードにする
    if (self.memoryValue != nil) {
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
            [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusRecall];
        }
    }

    self.valueA = nil;
    self.valueB = nil;
    self.operator = CCalcOperatorNone;
    self.fixedValue = nil;
    
    self.calcStatus = [[CNumberInputStatus alloc] initWithInputNumber:0 model:self];
    
    [self changeErrorMark:NO];
    [self setSubDisplayText:@""];
}

/**
 メモリクリアキーの入力
 */
- (void)inputMemoryClear
{
    self.memoryValue = nil;
    [self setSubDisplayText:@""];
    
    if ([self.calcStatus respondsToSelector:@selector(inputMemoryClear:)]) {
        [self.calcStatus inputMemoryClear:self];
    }
}

/**
 メモリ呼び出しキーの入力
 */
- (void)inputMemoryRecall
{
    if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
        [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusClear];
    }
    if ([self.calcStatus respondsToSelector:@selector(inputMemoryRecall:)]) {
        [self.calcStatus inputMemoryRecall:self];
    }
}

/**
 メモリープラスキーの入力
 */
- (void)inputMemoryPlus
{
    if ([self.calcStatus respondsToSelector:@selector(inputMemoryPlus:)]) {
        [self.calcStatus inputMemoryPlus:self];
    }
}

/**
 メモリマイナスキーの入力
 */
- (void)inputMemoryMinus
{
    if ([self.calcStatus respondsToSelector:@selector(inputMemoryMinus:)]) {
        [self.calcStatus inputMemoryMinus:self];
    }
}

- (void)setDisplayText:(NSString *)displayText
{
    if ([_displayText isEqualToString:displayText]) {
        return;
    }
    _displayText = [displayText copy];
    
    if ([self.delegate respondsToSelector:@selector(calcModel:showDisplayText:)]) {
        [self.delegate calcModel:self showDisplayText:displayText];
    }
}

- (void)setSubDisplayText:(NSString *)subDisplayText
{
    if ([_subDisplayText isEqualToString:subDisplayText]) {
        return;
    }
    
    _subDisplayText = [subDisplayText copy];
    
    if ([self.delegate respondsToSelector:@selector(calcModel:showSubDisplayText:)]) {
        [self.delegate calcModel:self showSubDisplayText:_subDisplayText];
    }    
}

- (void)setOperator:(CCalcOperator)operator
{
    if (_operator == operator) {
        return;
    }
    _operator = operator;
    if ([self.delegate respondsToSelector:@selector(calcModel:showOperator:)]) {
        [self.delegate calcModel:self showOperator:_operator];
    }
}

- (void)setFixedValue:(NSDecimalNumber *)fixedValue
{
    if (_fixedValue == fixedValue) {
        return;
    }
    _fixedValue = fixedValue;
    
    if (_fixedValue != nil) {
        if ([self.delegate respondsToSelector:@selector(calcModel:changeFixedMark:)]) {
            [self.delegate calcModel:self changeFixedMark:YES];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(calcModel:changeFixedMark:)]) {
            [self.delegate calcModel:self changeFixedMark:NO];
        }
    }
}

- (void)setMemoryValue:(NSDecimalNumber *)memoryValue
{
    if (_memoryValue == memoryValue) {
        return;
    }
    
    if (memoryValue != nil) {
        // MRCボタンのラベル変更
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
            [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusRecall];
        }
        // メモリーマークを表示
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMemoryMark:)]) {
            [self.delegate calcModel:self changeMemoryMark:YES];
        }
    } else if (memoryValue == nil) {
        // MRCボタンのラベル変更
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMRCButton:)]) {
            [self.delegate calcModel:self changeMRCButton:CMemoryClearButtonStatusClear];
        }
        // メモリーマークを非表示
        if ([self.delegate respondsToSelector:@selector(calcModel:changeMemoryMark:)]) {
            [self.delegate calcModel:self changeMemoryMark:NO];
        }
    }
    _memoryValue = memoryValue;
}

// 現在のモデルの状態で計算を行う
- (void)calcModel
{
    if (self.fixedValue == nil) {
        self.resultValue = [CCalcModel calc:self.valueA operator:self.operator valueB:self.valueB];
    } else {
        self.resultValue = [CCalcModel calc:self.valueA operator:self.operator valueB:self.fixedValue];
    }
}

// 計算を行う
+ (NSDecimalNumber*)calc:(NSDecimalNumber*)valueA operator:(CCalcOperator)operator valueB:(NSDecimalNumber*)valueB
{
    NSDecimalNumber* result = nil;
    
    switch (operator) {
        case CCalcOperatorPlus:      // +
            result = [valueA decimalNumberByAdding:valueB];
            break;
        case CCalcOperatorMinus:     // -
            result = [valueA decimalNumberBySubtracting:valueB];
            break;
        case CCalcOperatorMultiply:  // X
            result = [valueA decimalNumberByMultiplyingBy:valueB];
            break;
        case CCalcOperatorDivide:   // /
            result = [valueA decimalNumberByDividingBy:valueB];
            break;
        case CCalcOperatorPercent:    // %
            break;
        case CCalcOperatorSquareRoot: // √
            break;
        case CCalcOperatorNone:
         result = valueA;
        default:
            break;
    }
    
    return result;
}

+ (NSString*)operatorString:(CCalcOperator)operator
{
    NSString* result = nil;
    
    switch (operator) {
        case CCalcOperatorPlus:      // +
            result = @"+";
            break;
        case CCalcOperatorMinus:     // -
            result = @"-";
            break;
        case CCalcOperatorMultiply:  // X
            result = @"×";
            break;
        case CCalcOperatorDivide:   // /
            result = @"÷";
            break;
        case CCalcOperatorPercent:    // %
            result = @"÷";
            break;
        case CCalcOperatorSquareRoot: // √
            result = @"√";
            break;
       case CCalcOperatorEqual:
            result = @"=";
        default:
            break;
    }
    
    return result;
    
}

- (void)calcPercent
{
    NSDecimalNumber* val100 = [NSDecimalNumber decimalNumberWithString:@"100"];
    
    switch (self.operator) {
        case CCalcOperatorPlus: {     // +
            NSDecimalNumber* val1 = [self.valueB decimalNumberByDividingBy:val100]; // B / 100.0
            NSDecimalNumber* val2 = [[NSDecimalNumber one] decimalNumberBySubtracting:val1];    // 1.0 - val1
            self.resultValue = [self.valueA decimalNumberByDividingBy:val2];
            break;
        }
        case CCalcOperatorMinus: {    // - valueAは、valueBの何％アップか
            NSDecimalNumber* val = [self.valueA decimalNumberBySubtracting:self.valueB];
            NSDecimalNumber* val2 = [val decimalNumberByDividingBy:self.valueB];
            self.resultValue = [val2 decimalNumberByMultiplyingBy:val100];
            break;
        }
        case CCalcOperatorMultiply:{  // X -> valueAのvalueB%の値は？
            NSDecimalNumber* val = [self.valueA decimalNumberByMultiplyingBy:self.valueB];
            self.resultValue = [val decimalNumberByDividingBy:val100];
            break;
        }
        case CCalcOperatorDivide:{   // / -> valueAはvalueBの何％か？
            NSDecimalNumber* percent = [self.valueA decimalNumberByDividingBy:self.valueB];
            self.resultValue = [percent decimalNumberByMultiplyingBy:val100];
            break;
        }
        default:
            break;
    }
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@,\n"
            "tag = %d,\n"
            "calcStatus = %@\n"
            "valueA = %@\n"
            "operator = %d\n"
            "valueB = %@\n"
            "resultValue = %@\n"
            "fixedValue = %@",
            [super description],
            self.tag,
            self.calcStatus,
            self.valueA,
            self.operator,
            self.valueB,
            self.resultValue,
            self.fixedValue];
}
@end
