//
//  CViewController.h
//  Calc
//
//  Created by YAKUC on 2012/11/10.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "GradientButton.h"
#import "CCalcModel.h"
#import "CPageControl.h"

/**
 計算機のメイン画面のビューコントーラ
 */
@interface CCalcViewController : UIViewController <UIScrollViewDelegate, CCalcModelDelegate, ADBannerViewDelegate>

@property (assign, nonatomic) NSInteger currentPage;

@property (weak, nonatomic) IBOutlet GradientButton *button0;
@property (weak, nonatomic) IBOutlet GradientButton *button1;
@property (weak, nonatomic) IBOutlet GradientButton *button2;
@property (weak, nonatomic) IBOutlet GradientButton *button3;
@property (weak, nonatomic) IBOutlet GradientButton *buttonDot;
@property (weak, nonatomic) IBOutlet GradientButton *buttonEqual;
@property (weak, nonatomic) IBOutlet GradientButton *button4;
@property (weak, nonatomic) IBOutlet GradientButton *button5;
@property (weak, nonatomic) IBOutlet GradientButton *button6;
@property (weak, nonatomic) IBOutlet GradientButton *button7;
@property (weak, nonatomic) IBOutlet GradientButton *button8;
@property (weak, nonatomic) IBOutlet GradientButton *button9;
@property (weak, nonatomic) IBOutlet GradientButton *buttonPlus;
@property (weak, nonatomic) IBOutlet GradientButton *buttonMinus;
@property (weak, nonatomic) IBOutlet GradientButton *buttonMultiply;
@property (weak, nonatomic) IBOutlet GradientButton *buttonMRC;
@property (weak, nonatomic) IBOutlet GradientButton *buttonAC;
@property (weak, nonatomic) IBOutlet UIScrollView *displayScrollView;
@property (weak, nonatomic) IBOutlet UILabel *calculateLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet CPageControl *pageControl;
@property (weak, nonatomic) IBOutlet ADBannerView *adView;

- (IBAction)numberAction:(id)sender;
- (IBAction)dotAction:(id)sender;
- (IBAction)equalAction:(id)sender;
- (IBAction)plusAction:(id)sender;
- (IBAction)minusAction:(id)sender;
- (IBAction)multiplyAction:(id)sender;
- (IBAction)divisionAction:(id)sender;
- (IBAction)acAction:(id)sender;
- (IBAction)percentAction:(id)sender;
- (IBAction)signChange:(id)sender;
- (IBAction)memoryClearAction:(id)sender;
- (IBAction)memoryMinusAction:(id)sender;
- (IBAction)memoryPlusAction:(id)sender;
- (IBAction)squareRootAction:(id)sender;
- (IBAction)pageControlChanged:(id)sender;

@end
