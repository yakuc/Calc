//
//  CResultStatus.m
//  Calc
//
//  Created by YAKUC on 2012/11/23.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import "CResultStatus.h"
#import "CNumberInputStatus.h"
#import "COperatorInputStatus.h"
#import "NSDecimalNumber+Calc.h"
#import "CAppDelegate.h"

@interface CResultStatus()

@property (nonatomic, retain) NSNumberFormatter* numberFormatter;

@end

@implementation CResultStatus 

- (id)initWithModel:(CCalcModel*)model
{
    self = [super init];
    if (self) {
        NSLog(@"結果表示モード.");
        
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [self.numberFormatter setMaximumFractionDigits:kCMaxDigits];
        
        @try {
            // 今までの入力値を計算
            [model calcModel];
            
            // 桁数オーバーチェク
            NSInteger digits = [model.resultValue digits];
            NSDecimal decimal = [model.resultValue decimalValue];
            
            if (digits > kCMaxDigits && decimal._exponent >= 0) {
                // 桁溢れエラー
                
                // エラーマーク表示
                [model changeErrorMark:YES];
                
                model.resultValue = [NSDecimalNumber zero];

                // 表示
                model.displayText = [self.numberFormatter stringFromNumber:model.resultValue];;
                
                // = を画面に表示
                [self showEqual:YES model:model];
                
                // エラーダイアログの表示
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CS_OVERFLOW_ERROR_TITLE", nil)
                                                                    message:NSLocalizedString(@"CS_OVERFLOW_ERROR_MESSAGE", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:NSLocalizedString(@"CS_OK", nil), nil];
                [alertView show];
                
                return self;
            }
            
            NSString* valueStr = [self.numberFormatter stringFromNumber:model.resultValue];
            if (decimal._exponent < 0) {
                // 浮動小数点を含む場合
                if (valueStr.length > kCMaxDigits) {
                    valueStr = [valueStr substringToIndex:kCMaxDigits + 1];
                }
            }
            
            // 表示
            model.displayText = valueStr;
            
            // = を画面に表示
            [self showEqual:YES model:model];
        }
        @catch (NSException* ex) {
            // 表示
            NSLog(@"Error: %@", ex.name);
            
            [model changeErrorMark:YES];
            
            
            // 画面には０表示
            model.resultValue = [NSDecimalNumber zero];
            model.displayText = [self.numberFormatter stringFromNumber:model.resultValue];
            
            // エラーダイアログの表示
            NSString* title = nil;
            NSString* message = nil;
            if ([ex.name isEqualToString:NSDecimalNumberDivideByZeroException]) {
                title = NSLocalizedString(@"CS_DIVIED_BY_ZERO_TITLE", nil);
                message = NSLocalizedString(@"CS_DIVIED_BY_ZERO_MESSAGE", nil);
            } else if ([ex.name isEqualToString:NSDecimalNumberOverflowException]) {
                title = NSLocalizedString(@"CS_OVERFLOW_ERROR_TITLE", nil);
                message = NSLocalizedString(@"CS_OVERFLOW_ERROR_MESSAGE", nil);
            } else {
                title = ex.name;
            }
            
           UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"CS_OK", nil), nil];
            [alertView show];
        }
    }
    return self;
}

- (id)initMemoryPlusWithModel:(CCalcModel*)model
{
    self = [self initWithModel:model];
    if (model.memoryValue != nil) {
        model.memoryValue = [model.memoryValue decimalNumberByAdding:model.resultValue];
    } else {
        model.memoryValue = model.resultValue;
    }

    // サブディスプレイへ式を表示
    NSString* valueText = [self.numberFormatter stringFromNumber:model.valueB];
    NSString* resultValueText = [self.numberFormatter stringFromNumber:model.resultValue];
    NSString* memoryText = [self.numberFormatter stringFromNumber:model.memoryValue];
    
    NSString* formula = [NSString stringWithFormat:@"%@ %@ = %@ Memory:%@",
                         [model subDisplayText], valueText, resultValueText, memoryText];
    [model setSubDisplayText:formula];

    NSLog(@"memory: %@", model.memoryValue);
    return self;
}

- (id)initMemoryMinusWithModel:(CCalcModel*)model
{
    self = [self initWithModel:model];
    if (model.memoryValue != nil) {
        model.memoryValue = [model.memoryValue decimalNumberBySubtracting:model.resultValue];
    } else {
        model.memoryValue = model.resultValue;
    }
    
     // サブディスプレイへ式を表示
    NSString* valueText = [self.numberFormatter stringFromNumber:model.valueB];
    NSString* resultValueText = [self.numberFormatter stringFromNumber:model.resultValue];
    NSString* memoryText = [self.numberFormatter stringFromNumber:model.memoryValue];
    
    NSString* formula = [NSString stringWithFormat:@"%@ %@ = %@ Memory:%@",
                         [model subDisplayText], valueText, resultValueText, memoryText];
    [model setSubDisplayText:formula];

    NSLog(@"memory: %@", model.memoryValue);

    return self;
}

- (id)initMemoryRecallWithModel:(CCalcModel*)model
{
    self = [super init];
    if (self) {
        NSLog(@"結果表示モード.");
        
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        // 計算結果を表示
        NSString *displayText = [self.numberFormatter stringFromNumber:model.memoryValue];
        
        // 表示
        model.displayText = displayText;
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"結果表示モード.");
    }
    return self;
}

- (void)showEqual:(BOOL)isShow model:(CCalcModel*)model
{
    
    if (isShow) {
        if ([model.delegate respondsToSelector:@selector(calcModel:showOperator:)]) {
            [model.delegate calcModel:model showOperator:CCalcOperatorEqual];
        }
    } else {
        if ([model.delegate respondsToSelector:@selector(calcModel:showOperator:)]) {
            [model.delegate calcModel:model showOperator:CCalcOperatorNone];
        }        
    }
}

/**
 数値の入力
 
 @param number  入力数値
 @param model   状態を保持している計算モデルオブジェクト
 */
- (void)inputNumber:(NSInteger)number model:(CCalcModel*)model
{
    model.valueA = nil;
    model.valueB = nil;
    model.resultValue = nil;
    if (model.fixedValue == nil) {
        model.operator = CCalcOperatorNone;
    }
    
    [model setSubDisplayText:@""];

    // NumberInputの状態へ移行
    model.calcStatus = [[CNumberInputStatus alloc] initWithInputNumber:number model:model];
}

/**
 演算子の入力
 
 @param operator    入力された演算子
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputOperator:(CCalcOperator)operator model:(CCalcModel*)model
{
    model.operator = operator;
    model.valueA = model.resultValue;
    model.fixedValue = nil;
    
    // サブディスプレイへ式を表示
    NSString* valueAText = [self.numberFormatter stringFromNumber:model.valueA];
    NSString* formula = [NSString stringWithFormat:@"%@ %@",
                         valueAText, [CCalcModel operatorString:operator]];
    [model setSubDisplayText:formula];

    // 状態を演算子入力モードに移行
    model.calcStatus = [[COperatorInputStatus alloc] initWithOperator:operator model:model];
    
}

/**
 = の入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputEqual:(CCalcModel*)model
{
    
}

/**
 関数キーの入力
 
 @param calcFunc     関数の種類
 @param model         状態を保持している計算モデルオブジェクト
 */
- (void)inputFunc:(CCalcFunc)calcFunc model:(CCalcModel*)model
{
    switch(calcFunc) {
        case CCalcFuncSquareRoot: {
            // 計算
            NSDecimalNumber* val = [model.resultValue sqrt];
            model.resultValue = val;
            
            // カンマ区切りの数値に変換する
            NSString *displayText = [self.numberFormatter stringFromNumber:val];
            
            // 表示
            model.displayText = displayText;
            break;
        }
        default:
            break;
    }
}

// 符号切り替えキーの入力
- (void)inputSignChange:(CCalcModel*)model
{
    // サブディスプレイの設定
    [model setSubDisplayText:@""];

    model.valueA  = [model.resultValue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1.0"]];
    model.valueB = nil;
    model.resultValue = nil;
   if (model.fixedValue == nil) {
        model.operator = CCalcOperatorNone;
    }
    
    // NumberInputの状態へ移行
    model.calcStatus = [[CNumberInputStatus alloc] initWithDecimalNumber:model.valueA model:model];
}

/**
 クリアーキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputClear:(CCalcModel*)model
{
    model.valueA = nil;
    model.valueB = nil;
    model.resultValue = nil;
    
    if (model.fixedValue == nil) {
        model.operator = CCalcOperatorNone;
    }
    
    [model setSubDisplayText:@""];
    
    // NumberInputの状態へ移行
    model.calcStatus = [[CNumberInputStatus alloc] initWithInputNumber:0 model:model];
}

/**
 オールクリアーキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputAllClear:(CCalcModel*)model
{
    
}

/**
 メモリクリアキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputMemoryClear:(CCalcModel*)model
{
    
}

/**
 メモリ呼び出しキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputMemoryRecall:(CCalcModel*)model
{
    model.valueA = nil;
    model.valueB = nil;
    model.resultValue = nil;
    if (model.fixedValue == nil) {
        model.operator = CCalcOperatorNone;
    }

    // 数値入力モードに移行
    model.calcStatus = [[CNumberInputStatus alloc] initWithDecimalNumber:model.memoryValue model:model];
}

/**
 メモリープラスキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputMemoryPlus:(CCalcModel*)model
{
    
}

/**
 メモリ-マイナスキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputMemoryMinus:(CCalcModel*)model
{
    
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@,\n"
            "演算結果モード",
            [super description]];
}

@end
