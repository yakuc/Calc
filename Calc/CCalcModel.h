//
//  CCalcModel.h
//  Calc
//
//  Created by YAKUC on 2012/11/12.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCalcStatus.h"

@class CCalcModel;

/// MemoryClearボタンの状態
typedef enum {
    CMemoryClearButtonStatusClear,
    CMemoryClearButtonStatusRecall
} CMemoryClearButtonStatus;

@protocol CCalcModelDelegate <NSObject>
@optional

/**
 表示板に文字列を表示
 
 @param model   表示するCCalcModelオブジェクト
 @param string  表示文字列
 */
- (void)calcModel:(CCalcModel*)model showDisplayText:(NSString*)string;

/**
 サブ表示板に文字列を表示
 
 @param model   表示するCCalcModelオブジェクト
 @param string  表示文字列
 */
- (void)calcModel:(CCalcModel*)model showSubDisplayText:(NSString*)string;

/**
 選択演算子の表示
 
 @param model   表示するCCalcModelオブジェクト
 @param operator 演算子
 */
- (void)calcModel:(CCalcModel*)model showOperator:(CCalcOperator)operator;

/**
 定数マークの表示/非表示
 
 @param model   表示するCCalcModelオブジェクト
 @param status  表示状態
 */
- (void)calcModel:(CCalcModel *)model changeFixedMark:(BOOL)status;

/**
 メモリー状態の表示/非表示
 
 @param model   表示するCCalcModelオブジェクト
 @param status  表示状態
    - YES   表示
    - NO    非表示
 */
- (void)calcModel:(CCalcModel *)model changeMemoryMark:(BOOL)status;


/**
 MRCボタンの状態を変更
 
 @param model
 @param status  ボタンの状態
    - YES   表示
    - NO    非表示
 */
- (void)calcModel:(CCalcModel*)model changeMRCButton:(CMemoryClearButtonStatus)status;

/**
 エラーマークを表示

 @param status  表示状態
 - YES   表示
 - NO    非表示

 */
- (void)calcModel:(CCalcModel *)model changeErrorMark:(BOOL)status;

@end

/**
 計算機のモデルクラス
 */
@interface CCalcModel : NSObject

/// タグ
@property (nonatomic, assign) NSInteger tag;
/// CalcViewのDelegate
@property (nonatomic, weak) id<CCalcModelDelegate> delegate;
/// 現在の状態
@property (nonatomic, strong) id<CCalcStatus> calcStatus;
/// 入力数値A
@property (nonatomic, strong) NSDecimalNumber* valueA;
/// 入力数値B
@property (nonatomic, strong) NSDecimalNumber* valueB;
/// 演算子
@property (nonatomic, assign) CCalcOperator operator;
/// 結果
@property (nonatomic, strong) NSDecimalNumber* resultValue;
/// メモリー値
@property (nonatomic, strong) NSDecimalNumber* memoryValue;
/// 定数
@property (nonatomic, copy) NSDecimalNumber* fixedValue;
/// 表示文字列
@property (nonatomic, copy) NSString* displayText;
/// サブ表示
@property (nonatomic, copy) NSString* subDisplayText;

/**
 計算を行う
 
 valueA operator valueB の計算を行う
 
 @param valueA  数値A
 @param operator    演算子
 @param value B
 */
+ (NSDecimalNumber*)calc:(NSDecimalNumber*)valueA operator:(CCalcOperator)operator valueB:(NSDecimalNumber*)valueB;

/**
 現在のモデルの状態で計算を行う
 */
- (void)calcModel;

/**
 エラーマーク表示
 */
- (void)changeErrorMark:(BOOL)status;

/**
 現在のモデルの状態から%キーが押された時の演算を行う
 */
- (void)calcPercent;

/**
 数値の入力
 */
- (void)inputNumber:(NSInteger)number;

/**
 演算子の入力
 */
- (void)inputOperator:(CCalcOperator)operator;

/**
 = の入力
 */
- (void)inputEqual;

/**
 サインチェンジ（+-)キーの入力
 */
- (void)inputSignChange;

/**
 小数点の入力
 */
- (void)inputDot;

/**
 関数演算
 */
- (void)inputFunc:(CCalcFunc)func;

/**
 クリアーキーの入力
 */
- (void)inputClear;

/**
 オールクリアーキーの入力
 */
- (void)inputAllClear;

/**
 メモリクリアキーの入力
 */
- (void)inputMemoryClear;

/**
 メモリ呼び出しキーの入力
 */
- (void)inputMemoryRecall;

/**
 メモリープラスキーの入力
 */
- (void)inputMemoryPlus;

/**
 メモリマイナスキーの入力
 */
- (void)inputMemoryMinus;

/**
 演算子の文字列を取得
 */
+ (NSString*)operatorString:(CCalcOperator)operator;

@end
