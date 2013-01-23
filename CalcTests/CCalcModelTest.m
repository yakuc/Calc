//
//  CCalcModelTest.m
//  Calc
//
//  Created by YAKUCon 2012/11/24.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import "CCalcModelTest.h"
#import "CCalcModel.h"

@interface CCalcModelTest()

@property (nonatomic, strong)CCalcModel *calcModel;

@end

@implementation CCalcModelTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.calcModel = [[CCalcModel alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    self.calcModel = nil;
    
    [super tearDown];
}

- (void)testDot
{
    [self.calcModel inputNumber:3];
    [self.calcModel inputDot];
    [self.calcModel inputNumber:5];
    
    STAssertEqualObjects(self.calcModel.displayText, @"3.5", @"小数点付き数値の表記が違います");
    
    [self.calcModel inputAllClear];

    [self.calcModel inputDot];
    [self.calcModel inputNumber:3];
    
    STAssertEqualObjects(self.calcModel.displayText, @"0.3", @"小数点付き数値の表記が違います");
}

- (void)testCalc1
{
    // 4 - 6 = 2
    [self.calcModel inputNumber:4];
    [self.calcModel inputOperator:CCalcOperatorMinus];
    [self.calcModel inputNumber:6];
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"-2"], @"計算結果が違うよ");
}

- (void)testCalc2
{
    // (1+2)/3*4-5.5 = -1.5
    [self.calcModel inputNumber:1];
    [self.calcModel inputOperator:CCalcOperatorPlus];
    [self.calcModel inputNumber:2];
    [self.calcModel inputOperator:CCalcOperatorDivide];
    
    STAssertEqualObjects(self.calcModel.displayText, @"3", @"計算結果示が違うよ");
    STAssertEqualObjects(self.calcModel.valueA,
                         [NSDecimalNumber decimalNumberWithString:@"3"], @"計算結果が違うよ");

    [self.calcModel inputNumber:3];
    [self.calcModel inputOperator:CCalcOperatorMultiply];
    STAssertEqualObjects(self.calcModel.displayText, @"1", @"計算結果示が違うよ");
    STAssertEqualObjects(self.calcModel.valueA,
                         [NSDecimalNumber decimalNumberWithString:@"1"], @"計算結果が違うよ");

    [self.calcModel inputNumber:4];
    [self.calcModel inputOperator:CCalcOperatorMinus];
    [self.calcModel inputNumber:5];
    [self.calcModel inputDot];
    [self.calcModel inputNumber:5];

    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"-1.5", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"-1.5"], @"計算結果が違うよ");
}

- (void)testSquareRoot
{
    [self.calcModel inputNumber:4];
    [self.calcModel inputFunc:CCalcFuncSquareRoot];
    
    STAssertEqualObjects(self.calcModel.displayText, @"2", @"計算結果表示が違うよ");
   
    [self.calcModel inputOperator:CCalcOperatorMultiply];
    [self.calcModel inputNumber:5];

    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"10", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"10"], @"計算結果が違うよ");

}

- (void)testSignChange
{
    [self.calcModel inputNumber:5];
    [self.calcModel inputSignChange];
    
    STAssertEqualObjects(self.calcModel.displayText, @"-5", @"表示が違うよ");
 
    [self.calcModel inputOperator:CCalcOperatorMultiply];
    [self.calcModel inputNumber:3];
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"-15", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"-15"], @"計算結果が違うよ");

    // 10 + (-3) = 7
    [self.calcModel inputNumber:10];
    
    [self.calcModel inputOperator:CCalcOperatorPlus];
    [self.calcModel inputNumber:3];
    [self.calcModel inputSignChange];
    
    STAssertEqualObjects(self.calcModel.displayText, @"-3", @"表示が違うよ");
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"7", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"7"], @"計算結果が違うよ");

    // 10 + (+-) 5 = -10 + 5 = -5
    [self.calcModel inputNumber:10];
    
    [self.calcModel inputOperator:CCalcOperatorPlus];
    [self.calcModel inputSignChange];
    STAssertEqualObjects(self.calcModel.displayText, @"-10", @"表示が違うよ");
    
    [self.calcModel inputNumber:5];
    
    STAssertEqualObjects(self.calcModel.displayText, @"5", @"表示が違うよ");
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"-5", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"-5"], @"計算結果が違うよ");
    
}

// 定数計算のテスト
- (void)testFixedValue
{
    // 23 ++ 12 = 12 + 23 = 35
    [self.calcModel inputNumber:2];
    [self.calcModel inputNumber:3];
    [self.calcModel inputOperator:CCalcOperatorPlus];
    [self.calcModel inputOperator:CCalcOperatorPlus];

    STAssertEqualObjects(self.calcModel.fixedValue, [NSDecimalNumber decimalNumberWithString:@"23"], @"定数が違うよ");
    
    [self.calcModel inputNumber:1];
    [self.calcModel inputNumber:2];
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"35", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"35"], @"計算結果が違うよ");

    // 45 = 68 = 45 + 23
    [self.calcModel inputNumber:4];
    [self.calcModel inputNumber:5];
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"68", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"68"], @"計算結果が違うよ");
 
    // 78 = 78 + 23 = 101
    [self.calcModel inputNumber:7];
    [self.calcModel inputNumber:8];
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"101", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"101"], @"計算結果が違うよ");
    
}


- (void)testFixedValue2
{
    // 5--7 = 7 - 5 = 2
    [self.calcModel inputNumber:5];
    [self.calcModel inputOperator:CCalcOperatorMinus];
    [self.calcModel inputOperator:CCalcOperatorMinus];
    [self.calcModel inputNumber:7];
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"2", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"2"], @"計算結果が違うよ");
    
    // 2 = 2 - 5 = -3
    [self.calcModel inputNumber:2];
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"-3", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"-3"], @"計算結果が違うよ");
    
}

- (void)testFixedValue3
{
    // 12xx2 = 24
    [self.calcModel inputNumber:1];
    [self.calcModel inputNumber:2];
    [self.calcModel inputOperator:CCalcOperatorMultiply];
    [self.calcModel inputOperator:CCalcOperatorMultiply];
    [self.calcModel inputNumber:2];
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"24", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"24"], @"計算結果が違うよ");
    
    // 4 = 4 x 12 = 48
    [self.calcModel inputNumber:4];
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"48", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"48"], @"計算結果が違うよ");
    
}

- (void)testFixedValue4
{
    // 9 // 45 = 5
    [self.calcModel inputNumber:9];
    [self.calcModel inputOperator:CCalcOperatorDivide];
    [self.calcModel inputOperator:CCalcOperatorDivide];
    [self.calcModel inputNumber:4];
    [self.calcModel inputNumber:5];
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"5", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"5"], @"計算結果が違うよ");
    
    // 72 = 72 / 9 = 8
    [self.calcModel inputNumber:7];
    [self.calcModel inputNumber:2];
    
    [self.calcModel inputEqual];
    
    STAssertEqualObjects(self.calcModel.displayText, @"8", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"8"], @"計算結果が違うよ");
    
}

- (void)testPercent
{
    // 100の5%
    [self.calcModel inputNumber:1];
    [self.calcModel inputNumber:0];
    [self.calcModel inputNumber:0];
    [self.calcModel inputOperator:CCalcOperatorMultiply];
    [self.calcModel inputNumber:5];
    [self.calcModel inputFunc:CCalcFuncPercent];
    
    STAssertEqualObjects(self.calcModel.displayText, @"5", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"5"], @"計算結果が違うよ");

    [self.calcModel inputAllClear];
    
    // 30は60の何％か
    [self.calcModel inputNumber:3];
    [self.calcModel inputNumber:0];
    [self.calcModel inputOperator:CCalcOperatorDivide];
    [self.calcModel inputNumber:6];
    [self.calcModel inputNumber:0];
    [self.calcModel inputFunc:CCalcFuncPercent];
    
    STAssertEqualObjects(self.calcModel.displayText, @"50", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"50"], @"計算結果が違うよ");

    [self.calcModel inputAllClear];
    
    //12は10の何％アップか
    [self.calcModel inputNumber:1];
    [self.calcModel inputNumber:2];
    [self.calcModel inputOperator:CCalcOperatorMinus];
    [self.calcModel inputNumber:1];
    [self.calcModel inputNumber:0];
    [self.calcModel inputFunc:CCalcFuncPercent];
    
    STAssertEqualObjects(self.calcModel.displayText, @"20", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"20"], @"計算結果が違うよ");
    
    [self.calcModel inputAllClear];
    
    // 履歴率を売価の25%と見た場合、仕入れ価格は？
    [self.calcModel inputNumber:1];
    [self.calcModel inputNumber:2];
    [self.calcModel inputNumber:0];
    [self.calcModel inputOperator:CCalcOperatorPlus];
    [self.calcModel inputNumber:2];
    [self.calcModel inputNumber:5];
    [self.calcModel inputFunc:CCalcFuncPercent];
    
    STAssertEqualObjects(self.calcModel.displayText, @"160", @"計算結果表示が違うよ");
    STAssertEqualObjects(self.calcModel.resultValue,
                         [NSDecimalNumber decimalNumberWithString:@"160"], @"計算結果が違うよ");
}
- (void)testMemory
{
    //80 x 9 M+
    [self.calcModel inputMemoryClear];
    [self.calcModel inputNumber:8];
    [self.calcModel inputNumber:0];
    [self.calcModel inputOperator:CCalcOperatorMultiply];
    [self.calcModel inputNumber:9];
    [self.calcModel inputMemoryPlus];
    
    STAssertEqualObjects(self.calcModel.displayText, @"720", @"表示が違います");
    STAssertEqualObjects(self.calcModel.memoryValue,
                         [NSDecimalNumber decimalNumberWithString:@"720"], @"メモリー内容が違うよ");
    // 50 x 6 M-
    [self.calcModel inputNumber:5];
    [self.calcModel inputNumber:0];
    [self.calcModel inputOperator:CCalcOperatorMultiply];
    [self.calcModel inputNumber:6];
    [self.calcModel inputMemoryMinus];
    
    STAssertEqualObjects(self.calcModel.displayText, @"300", @"表示が違います");
    STAssertEqualObjects(self.calcModel.memoryValue,
                         [NSDecimalNumber decimalNumberWithString:@"420"], @"メモリー内容が違うよ");

    // 20 x 3
    [self.calcModel inputNumber:2];
    [self.calcModel inputNumber:0];
    [self.calcModel inputOperator:CCalcOperatorMultiply];
    [self.calcModel inputNumber:3];
    [self.calcModel inputMemoryPlus];
    
    STAssertEqualObjects(self.calcModel.displayText, @"60", @"表示が違います");
    STAssertEqualObjects(self.calcModel.memoryValue,
                         [NSDecimalNumber decimalNumberWithString:@"480"], @"メモリー内容が違うよ");
    
    // MR
    [self.calcModel inputMemoryRecall];
    STAssertEqualObjects(self.calcModel.displayText, @"480", @"表示が違います");
    
}
@end
