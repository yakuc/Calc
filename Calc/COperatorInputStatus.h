//
//  COperatorImputStatus.h
//  Calc
//
//  Created by YAKUC on 2012/11/18.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCalcStatus.h"

/**
 演算子入力モードの状態オブジェクト
 */
@interface COperatorInputStatus : NSObject <CCalcStatus>

@property (nonatomic, assign) CCalcOperator operator;

- (id)initWithOperator:(CCalcOperator)operator model:(CCalcModel*)model;

@end
