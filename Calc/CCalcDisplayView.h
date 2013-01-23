//
//  CCalcDisplayView.h
//  Calc
//
//  Created by YAKUC on 2012/11/18.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 計算機のディスプレイ部分のビュー
 */
@interface CCalcDisplayView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *mainDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *subDisplayLabel;

/**
 MainDisplayのテキストを取得
 */
- (NSString*)mainDisplayText;
- (void)setMainDisplayText:(NSString*)text;

/**
 SubDisplayのテキスト
 */
- (NSString*)subDisplayText;
- (void)setSubDisplayText:(NSString*)text;

/**
 +の表示状態の設定

 @param status 表示状態。
 - YES 表示
 - NO:非表示
*/
- (void)setPlusDisplayStatus:(BOOL)status;

/**
 -の表示状態の設定
 
 @param status 表示状態。
        - YES 表示
        - NO:非表示
 */
- (void)setMinusDisplayStatus:(BOOL)status;

/**
 xの表示状態の設定
 
 @param status 表示状態。
 - YES 表示
 - NO:非表示
 */
- (void)setMultiplyDisplayStatus:(BOOL)status;

/**
 -の表示状態の設定
 
 @param status 表示状態。
 - YES 表示
 - NO:非表示
 */
- (void)setDivideDisplayStatus:(BOOL)status;

/**
 =の表示状態の設定
 
 @param status 表示状態。
 - YES 表示
 - NO:非表示
 */
- (void)setEqualDisplayStatus:(BOOL)status;

/**
 定数マークの表示

 @param status 表示状態。
 - YES 表示
 - NO:非表示
*/
- (void)setFixedMarkStatus:(BOOL)status;

/**
 メモリー状態の表示
 
 @param status 表示状態。
 - YES  表示
 - NO   非表示
 */
- (void)setMemoryStatus:(BOOL)status;

/**
 エラー状態の表示
 
 @param status  表示状態
 - YES  表示
 - NO   非表示
 */
- (void)setErrorStatus:(BOOL)status;

- (void)clearOperatorView;

@end
