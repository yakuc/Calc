//
//  CNumberInput1Status.h
//  Calc
//
//  Created by YAKUC on 2012/11/18.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCalcStatus.h"

/**
 数値入力モードの状態オブジェクト
 */
@interface CNumberInputStatus : NSObject <CCalcStatus>

@property (strong, nonatomic) NSDecimalNumber* value;

/**
 初期化
 
 @param number  入力数値
 @param model   計算機モデルクラス
 */
- (id)initWithInputNumber:(NSInteger)number model:(CCalcModel*)model;

- (id)initWithDecimalNumber:(NSDecimalNumber*)value model:(CCalcModel*)model;

@end
