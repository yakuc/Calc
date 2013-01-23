//
//  CResultStatus.h
//  Calc
//
//  Created by YAKUC on 2012/11/23.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCalcStatus.h"
#import "CCalcModel.h"

/**
 結果表示モードの状態オブジェクト
 */
@interface CResultStatus : NSObject <CCalcStatus>

/**
 初期化
 
 modelの状態から演算結果を表示して初期化

 @param model CCalcModel
*/
- (id)initWithModel:(CCalcModel*)model;

/**
 MemoryPlusキーを押した初期化
 */
- (id)initMemoryPlusWithModel:(CCalcModel*)model;

/**
 MemoryMinusキーを押した初期化
 */
- (id)initMemoryMinusWithModel:(CCalcModel*)model;

/**
 MRキーを押した初期化
 */
- (id)initMemoryRecallWithModel:(CCalcModel*)model;

@end
