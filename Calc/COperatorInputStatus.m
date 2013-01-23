//
//  COperatorImputStatus.m
//  Calc
//
//  Created by YAKUC on 2012/11/18.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import "COperatorInputStatus.h"
#import "CCalcModel.h"
#import "CNumberInputStatus.h"
#import "CAppDelegate.h"

@interface COperatorInputStatus()

@property (nonatomic, retain) NSNumberFormatter* numberFormatter;

@end

@implementation COperatorInputStatus

- (id)initWithOperator:(CCalcOperator)operator model:(CCalcModel*)model
{
    self = [super init];
    if (self) {
        NSLog(@"演算子入力モード。operator = %d", operator);
        NSLog(@"model = %@", model);

        self.numberFormatter = [[NSNumberFormatter alloc] init];
        [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [self.numberFormatter setMaximumFractionDigits:kCMaxDigits];

        model.operator = operator;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"演算子入力モード");
        
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
    if (model.operator == operator && model.fixedValue == nil) {
        // 定数
        model.fixedValue = model.valueA;
    } else if (model.operator == operator && model.fixedValue != nil) {
        // 定数を解除（３回連続して同じ演算を入力)
        model.fixedValue = nil;
    } else {
        model.operator = operator;
    }
}

/**
 = の入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputEqual:(CCalcModel*)model
{
    
}

/**
符号切り替え
*/
- (void)inputSignChange:(CCalcModel*)model
{
}

/**
 クリアーキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputClear:(CCalcModel*)model
{
    model.operator = CCalcOperatorNone;
    
    // サブディスプレイの設定
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
            "演算子入力モード",
            [super description]];
}

@end
