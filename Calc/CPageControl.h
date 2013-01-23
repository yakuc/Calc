//
//  CPageControl.h
//  Calc
//
//  Created by YAKUC on 2012/11/25.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 カスタムページコントロール
 
 標準コントロールの場合、白い背景だとインジケータの点が表示されないため、
 カスタムに点の画像を指定する為にビューを作成した
 */
@interface CPageControl : UIPageControl

@property (nonatomic, readwrite, retain) UIImage* imageNormal;
@property (nonatomic, readwrite, retain) UIImage* imageCurrent;

@end
