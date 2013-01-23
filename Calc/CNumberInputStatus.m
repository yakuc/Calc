//
//  CNumberInput1Status.m
//  Calc
//
//  Created by YAKUC on 2012/11/18.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import "CNumberInputStatus.h"
#import "CCalcModel.h"
#import "COperatorInputStatus.h"
#import "CAppDelegate.h"
#import "CResultStatus.h"
#import "NSDecimalNumber+Calc.h"

@interface CNumberInputStatus()

@property (nonatomic, retain) NSMutableString* numberText;
@property (nonatomic, retain) NSNumberFormatter* numberFormatter;
@property (nonatomic, assign) BOOL isInputDot;

@end

@implementation CNumberInputStatus 

- (void)_init
{
    self.numberText = [[NSMutableString alloc] initWithCapacity:kCMaxDigits + 1];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.numberFormatter setMaximumFractionDigits:kCMaxDigits];
    
    self.isInputDot = NO;
}

- (id)initWithInputNumber:(NSInteger)number model:(CCalcModel*)model
{
    self = [super init];
    if (self) {
        NSLog(@"数値入力モード。valueA = %@ operator = %d number = %d", model.valueA, model.operator, number);
        
        [self _init];
        [self inputNumber:number model:model];
    }
    return self;
}

- (id)initWithDecimalNumber:(NSDecimalNumber*)value model:(CCalcModel*)model
{
    self = [super init];
    if (self) {
        NSLog(@"数値入力モード。valueA = %@ operator = %d number = %@", model.valueA, model.operator, value);
        
        [self _init];
        self.value = value;
        self.numberText = [NSMutableString stringWithString:[value stringValue]];
        
        // 表示
        model.displayText = [self.numberFormatter stringFromNumber:value];
        
    }
    return self;    
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"数値入力モード。");
        [self _init];
    }
    return self;
}

/**
 数値の入力
 
 @param number  入力数値
 @param model   状態を保持している計算モデルオブジェクト
 */
- (void)inputNumber:(NSInteger)number model:(CCalcModel*)model
{
    if ([self.value digits] + 1 > kCMaxDigits) {
        return;
    }
    
    if ([self.numberText isEqualToString:@"0"] && number == 0) {
        self.value = [NSDecimalNumber zero];
    } else {
        if ([self.numberText isEqualToString:@"0"]) {
            self.numberText = [NSMutableString stringWithFormat:@"%d", number];
        } else {
            [self.numberText appendFormat:@"%d", number];
        }
        self.value = [NSDecimalNumber decimalNumberWithString:self.numberText];
    }
    
    // 表示
    if (self.isInputDot) {
        model.displayText = self.numberText;
    } else {
        // カンマ区切りの数値に変換する
        NSString *displayText = [self.numberFormatter stringFromNumber:self.value];        
        model.displayText = displayText;
    }
}

/**
 演算子の入力
 
 @param operator    入力された演算子
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputOperator:(CCalcOperator)operator model:(CCalcModel*)model
{
    if (model.valueA == nil) {
        // 数値を記憶
        model.valueA = self.value;
        
        // サブディスプレイへ式を表示
        NSString* valueAText = [self.numberFormatter stringFromNumber:model.valueA];
        NSString* formula = [NSString stringWithFormat:@"%@ %@",
                             valueAText, [CCalcModel operatorString:operator]];
        [model setSubDisplayText:formula];

        // 状態を演算子入力モードに移行
        model.calcStatus = [[COperatorInputStatus alloc] initWithOperator:operator model:model];
    } else {
        // 計算処理
        @try {
            NSDecimalNumber*result = [CCalcModel calc:model.valueA operator:model.operator valueB:self.value];
            
            // 桁数オーバーチェク
            NSInteger digits = [result digits];
            NSDecimal decimal = [result decimalValue];
            
            if (digits > kCMaxDigits && decimal._exponent >= 0) {
                
                // エラーマーク表示
                [model changeErrorMark:YES];
                
                 // 0を表示
                self.value = [NSDecimalNumber zero];                
                model.displayText = [self.numberFormatter stringFromNumber:self.value];
                
                // エラーダイアログの表示
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CS_OVERFLOW_ERROR_TITLE", nil)
                                                                    message:NSLocalizedString(@"CS_OVERFLOW_ERROR_MESSAGE", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:NSLocalizedString(@"CS_OK", nil), nil];
                [alertView show];
                return;
            }

            model.valueA = result;
            
            // カンマ区切りの数値に変換する
            NSString *displayText = [self.numberFormatter stringFromNumber:result];
            
            // 表示
            model.displayText = displayText;
            
            // サブディスプレイへ式を表示
            NSString* valueAText = [self.numberFormatter stringFromNumber:self.value];
            NSString* formula = [NSString stringWithFormat:@"%@ %@ %@",
                                 [model subDisplayText], valueAText, [CCalcModel operatorString:operator]];
             [model setSubDisplayText:formula];
            
            // 状態を演算子入力モードに移行
            model.calcStatus = [[COperatorInputStatus alloc] initWithOperator:operator model:model];
        }
        @catch (NSException* ex) {
            // 表示
            NSLog(@"Error: %@", ex.name);
            [model changeErrorMark:YES];
            
            // 画面には０表示
            self.value = [NSDecimalNumber zero];
            
            model.displayText = [self.numberFormatter stringFromNumber:self.value];
            
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
}

/**
 小数点の入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputDot:(CCalcModel*)model
{
    if (self.isInputDot) {
        return;
    }
    
    [self.numberText appendString:@"."];
    
    self.isInputDot = YES;
    // カンマ区切りの数値に変換する
    NSString *displayText = [self.numberFormatter stringFromNumber:self.value];
    
    // 表示
    model.displayText = displayText;    
}

/**
 = の入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputEqual:(CCalcModel*)model
{
    if (model.valueA == nil && model.fixedValue == nil) {
        // 数値を記憶
        model.valueA = self.value;
        model.valueB = [NSDecimalNumber zero];        
     } else if (model.valueA != nil && model.fixedValue == nil) {
        model.valueB = self.value;
         
         // サブディスプレイへ式を表示
        NSString* valueAText = [self.numberFormatter stringFromNumber:self.value];
        NSString* formula = [NSString stringWithFormat:@"%@ %@ =",
                             [model subDisplayText], valueAText];
        [model setSubDisplayText:formula];

    } else {
        // 固定値の場合
        model.valueA = self.value;

        // サブディスプレイへ式を表示
        NSString* valueAText = [self.numberFormatter stringFromNumber:self.value];
        NSString* fixedValueText = [self.numberFormatter stringFromNumber:model.fixedValue];
        NSString* formula = [NSString stringWithFormat:@"%@ %@ %@ =",
                             valueAText, [CCalcModel operatorString:model.operator], fixedValueText];
        [model setSubDisplayText:formula];
        
    }
    // 状態を演算結果モードに移行
    model.calcStatus = [[CResultStatus alloc] initWithModel:model];
}

/**
 符号切り替え
 */
- (void)inputSignChange:(CCalcModel*)model
{
    NSDecimalNumber* result = [self.value decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1.0"]];
    
    self.numberText = [NSMutableString stringWithString:result.stringValue];
    self.value = result;
    
    // カンマ区切りの数値に変換する
    NSString *displayText = [self.numberFormatter stringFromNumber:result];
    
    // 表示
    model.displayText = displayText;
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
            self.value = [self.value sqrt];
            
            // カンマ区切りの数値に変換する
            NSString *displayText = [self.numberFormatter stringFromNumber:self.value];
            

            // 表示
            model.displayText = displayText;
            break;
        }
        case CCalcFuncPercent: {
            if (model.valueA != nil) {
                model.valueB = self.value;
                [model calcPercent];
                self.value = model.resultValue;
                 model.displayText = [self.numberFormatter stringFromNumber:self.value];
                
                // サブディスプレイへ式を表示
                NSString* valueText = [self.numberFormatter stringFromNumber:model.valueB];
                NSString* formula = [NSString stringWithFormat:@"%@ %@%% =",
                                     [model subDisplayText], valueText];
                [model setSubDisplayText:formula];

                // 状態を演算結果モードに移行
                model.calcStatus = [[CResultStatus alloc] init];
            }
            break;
        }
        default:
            break;
    }
}


/**
 クリアーキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputClear:(CCalcModel*)model
{
    // 初期化
    [self _init];
    
    // 0が入力されたことにする
    [self inputNumber:0 model:model];
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
    self.value = model.memoryValue;
    self.numberText = [NSMutableString stringWithString:[self.value stringValue]];
    
    // カンマ区切りの数値に変換する
    NSString *displayText = [self.numberFormatter stringFromNumber:self.value];
    
    // 表示
    model.displayText = displayText;
}

/**
 メモリープラスキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputMemoryPlus:(CCalcModel*)model
{
    if (model.valueA == nil && model.fixedValue == nil) {
        // 数値を記憶
        model.valueA = self.value;
        model.operator = CCalcOperatorPlus;
        model.valueB = [NSDecimalNumber zero];
    } else if (model.valueA != nil && model.fixedValue == nil) {
        model.valueB = self.value;        
    } else {
        model.valueA = self.value;
    }
    // 状態を演算結果モードに移行
    model.calcStatus = [[CResultStatus alloc] initMemoryPlusWithModel:model];
}

/**
 メモリ-マイナスキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputMemoryMinus:(CCalcModel*)model
{
    if (model.valueA == nil && model.fixedValue == nil) {
        // 数値を記憶
        model.valueA = self.value;
        model.valueB = [NSDecimalNumber zero];
    } else if (model.valueA != nil && model.fixedValue == nil) {
        model.valueB = self.value;
    } else {
        model.valueA = self.value;
    }
    // 状態を演算結果モードに移行
    model.calcStatus = [[CResultStatus alloc] initMemoryMinusWithModel:model];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@,\n"
            "数値入力モード",
            [super description]];
}


@end
