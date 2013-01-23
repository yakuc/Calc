//
//  CCalcStatus.h
//  Calc
//
//  Created by YAKUC on 2012/11/14.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import <Foundation/Foundation.h>

// 演算子
typedef enum {
    CCalcOperatorNone = 0,
    CCalcOperatorPlus ,      // +
    CCalcOperatorMinus,     // -
    CCalcOperatorMultiply,  // X
    CCalcOperatorDivide ,   // /
    CCalcOperatorPercent,    // %
    CCalcOperatorSquareRoot, // √
    CCalcOperatorEqual      // =
} CCalcOperator;

// 関数
typedef enum {
    CCalcFuncSquareRoot,    // √
    CCalcFuncPercent        // %
} CCalcFunc;

@class CCalcModel;

@protocol CCalcStatus <NSObject>

/**
 数値の入力
 
 @param number  入力数値
 @param model   状態を保持している計算モデルオブジェクト
 */
- (void)inputNumber:(NSInteger)number model:(CCalcModel*)model;

/**
 演算子の入力
 
 @param operator    入力された演算子
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputOperator:(CCalcOperator)operator model:(CCalcModel*)model;

/**
 = の入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputEqual:(CCalcModel*)model;

/**
 符号切り替えキーの入力

 @param model       状態を保持している計算モデルオブジェクト 
 */
- (void)inputSignChange:(CCalcModel*)model;


/**
 クリアーキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputClear:(CCalcModel*)model;

/**
 メモリクリアキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputMemoryClear:(CCalcModel*)model;

/**
 メモリ呼び出しキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputMemoryRecall:(CCalcModel*)model;

/**
 メモリープラスキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputMemoryPlus:(CCalcModel*)model;

/**
 メモリ-マイナスキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputMemoryMinus:(CCalcModel*)model;

@optional

/**
 小数点の入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputDot:(CCalcModel*)model;

/**
 オールクリアーキーの入力
 
 @param model       状態を保持している計算モデルオブジェクト
 */
- (void)inputAllClear:(CCalcModel*)model;

/**
 関数キーの入力
 
 @param calcFunc     関数の種類
 @param model         状態を保持している計算モデルオブジェクト
 */
- (void)inputFunc:(CCalcFunc)calcFunc model:(CCalcModel*)model;

@end
