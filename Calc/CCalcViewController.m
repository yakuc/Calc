//
//  CViewController.m
//  Calc
//
//  Created by YAKUC on 2012/11/10.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import "CCalcViewController.h"
#import "CCalcDisplayView.h"

/// ACボタンの状態
typedef enum {
    CACButtonStatusAllClear,
    CACButtonStatusClear
}  CACButtonStatus;


/// 表示の最大ページ数
static NSInteger kCCalcMaxDispalyPage = 5;

@interface CCalcViewController ()

/// 表示View
@property (nonatomic, strong) NSArray* calcDisplays;

/// 計算機のモデルオブジェクト
@property (nonatomic, strong) NSArray* calcModels;

/// ACボタンの状態
@property (nonatomic, assign) CACButtonStatus acButtonStatus;

/// MRCボタンの状態
@property (nonatomic, assign) CMemoryClearButtonStatus mrcButtonStatus;

@property (nonatomic, assign) BOOL bannerIsVisible;

@end

@implementation CCalcViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundle
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundle];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentPage = 0;
    
    // ボタンのスタイルを設定する
    [self.button0 useBlackStyle];
    [self.button1 useBlackStyle];
    [self.button2 useBlackStyle];
    [self.button3 useBlackStyle];
    [self.button4 useBlackStyle];
    [self.button5 useBlackStyle];
    [self.button6 useBlackStyle];
    [self.button7 useBlackStyle];
    [self.button8 useBlackStyle];
    [self.button9 useBlackStyle];
    
    [self.buttonAC useSimpleOrangeStyle];
    
    // 表示部の初期化
    [self initScrollView];
    
    // setup page control
    self.pageControl.currentPage = self.currentPage;
    self.pageControl.numberOfPages =  kCCalcMaxDispalyPage;
    self.pageControl.imageCurrent = [UIImage imageNamed:@"PageControlCurrent"];
    self.pageControl.imageNormal = [UIImage imageNamed:@"PageControlNormal"];
    
    self.acButtonStatus = CACButtonStatusAllClear;
    self.mrcButtonStatus = CMemoryClearButtonStatusClear;
    
    // iAD banner view
    CGRect screenRect = self.view.bounds;
    self.adView.frame = CGRectOffset(CGRectZero, 0, screenRect.size.height);
    self.adView.delegate = self;
    self.bannerIsVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initScrollView
{
    CGSize s = self.view.frame.size;
    CGRect contentRect = CGRectMake(0, 0, s.width * kCCalcMaxDispalyPage, 80.0f);
    
    // 計算機のモデルクラスを作成
    NSMutableArray* tmpCalcModels = [NSMutableArray arrayWithCapacity:kCCalcMaxDispalyPage];
    NSMutableArray* views = [NSMutableArray arrayWithCapacity:kCCalcMaxDispalyPage];
    
    for (int i = 0; i < kCCalcMaxDispalyPage; i++) {
        CCalcDisplayView* displayView = [[CCalcDisplayView alloc] initWithFrame:CGRectMake(i * s.width, 0, s.width, 80.0f)];
        [views addObject:displayView];
        [self.displayScrollView addSubview:displayView];        
 
        // モデルクラス
        CCalcModel* model = [[CCalcModel alloc] init];
        model.delegate = self;
        [tmpCalcModels addObject:model];
    }
    
    self.calcDisplays = views;
    self.displayScrollView.contentSize = contentRect.size;
    self.displayScrollView.delegate = self;
    
    self.calcModels = tmpCalcModels;
}

- (void)setAcButtonStatus:(CACButtonStatus)acButtonStatus
{
    if (_acButtonStatus == acButtonStatus) {
        return;
    }
    _acButtonStatus = acButtonStatus;
    
    if (acButtonStatus == CACButtonStatusAllClear) {
        [self.buttonAC setTitle:@"AC" forState:UIControlStateNormal];
    } else {
        [self.buttonAC setTitle:@"C" forState:UIControlStateNormal];
    }
}

/// 現在の計算機のモデルクラスを取得
- (CCalcModel*)calcModel
{
    return [self.calcModels objectAtIndex:self.currentPage];
}


#pragma mark - CCalcModelDelegate

// 表示板に文字列を表示
- (void)calcModel:(CCalcModel*)model showDisplayText:(NSString*)string
{
    CCalcDisplayView* displayView = [self.calcDisplays objectAtIndex:self.currentPage];
    
    [displayView setMainDisplayText:string];
}

// 表示板に文字列を表示
- (void)calcModel:(CCalcModel*)model showSubDisplayText:(NSString*)string
{
    CCalcDisplayView* displayView = [self.calcDisplays objectAtIndex:self.currentPage];
    
    [displayView setSubDisplayText:string];
}

/**
 選択演算子の表示
 
 @param model   表示するCCalcModelオブジェクト
 @param operator 演算子
 */
- (void)calcModel:(CCalcModel*)model showOperator:(CCalcOperator)operator
{
    CCalcDisplayView* displayView = [self.calcDisplays objectAtIndex:self.currentPage];

    switch(operator) {
        case CCalcOperatorPlus:
            [displayView setPlusDisplayStatus:YES];
            break;
        case CCalcOperatorMinus:        // -
            [displayView setMinusDisplayStatus:YES];
            break;
        case CCalcOperatorMultiply:     // X
            [displayView setMultiplyDisplayStatus:YES];
            break;
        case CCalcOperatorDivide:       // /
            [displayView setDivideDisplayStatus:YES];
            break;
        case CCalcOperatorEqual:        // =
            [displayView setEqualDisplayStatus:YES];
            break;
        default:
            [displayView clearOperatorView];
            break;
    }
}


- (void)calcModel:(CCalcModel *)model changeFixedMark:(BOOL)status
{
    CCalcDisplayView* displayView = [self.calcDisplays objectAtIndex:self.currentPage];
    
    [displayView setFixedMarkStatus:status];
}

- (void)calcModel:(CCalcModel *)model changeMemoryMark:(BOOL)status
{
    CCalcDisplayView* displayView = [self.calcDisplays objectAtIndex:self.currentPage];

    [displayView setMemoryStatus:status];
}

- (void)calcModel:(CCalcModel*)model changeMRCButton:(CMemoryClearButtonStatus)status
{
    self.mrcButtonStatus = status;
    if (self.mrcButtonStatus == CMemoryClearButtonStatusClear) {
        [self.buttonMRC setTitle:@"MC" forState:UIControlStateNormal];
    } else {
        [self.buttonMRC setTitle:@"MR" forState:UIControlStateNormal];
    }
}

- (void)calcModel:(CCalcModel *)model changeErrorMark:(BOOL)status
{
    CCalcDisplayView* displayView = [self.calcDisplays objectAtIndex:self.currentPage];
    
    [displayView setErrorStatus:status];
}

#pragma mark - buttonAction

- (IBAction)numberAction:(id)sender {
    UIButton* button = (UIButton*)sender;
    
    // モデルクラスに入力数値を通知
    [self.calcModel inputNumber:button.tag - 1];
    
    // ACボタンをCに
    self.acButtonStatus = CACButtonStatusClear;
}

- (IBAction)dotAction:(id)sender {
    [self.calcModel inputDot];
}

- (IBAction)equalAction:(id)sender {
    [self.calcModel inputEqual];
}

- (IBAction)plusAction:(id)sender {
    [self.calcModel inputOperator:CCalcOperatorPlus];
}

- (IBAction)minusAction:(id)sender {
    [self.calcModel inputOperator:CCalcOperatorMinus];
}

- (IBAction)multiplyAction:(id)sender {
    [self.calcModel inputOperator:CCalcOperatorMultiply];
}

- (IBAction)divisionAction:(id)sender {
    [self.calcModel inputOperator:CCalcOperatorDivide];
}

- (IBAction)acAction:(id)sender {
    if (self.acButtonStatus == CACButtonStatusAllClear) {
        [self.calcModel inputAllClear];
    } else {
        [self.calcModel inputClear];
        self.acButtonStatus = CACButtonStatusAllClear;
    }
}

- (IBAction)percentAction:(id)sender {
    [self.calcModel inputFunc:CCalcFuncPercent];
}

- (IBAction)memoryClearAction:(id)sender {
    if (self.mrcButtonStatus == CMemoryClearButtonStatusClear) {
        [self.calcModel inputMemoryClear];
    } else {
        [self.calcModel inputMemoryRecall];
     }
}

- (IBAction)memoryMinusAction:(id)sender {
    [self.calcModel inputMemoryMinus];
}

- (IBAction)memoryPlusAction:(id)sender {
    [self.calcModel inputMemoryPlus];
}

- (IBAction)squareRootAction:(id)sender {
    [self.calcModel inputFunc:CCalcFuncSquareRoot];
}

// UIPageControlがタップされページ番号がかわった
- (IBAction)pageControlChanged:(id)sender {
    int page = self.pageControl.currentPage;
    self.currentPage = page;
    
    [UIView beginAnimations:nil context:nil];
    self.displayScrollView.contentOffset = CGPointMake(
                                    page*320, 0);
    [UIView commitAnimations];
}

- (IBAction)signChange:(id)sender {
    [self.calcModel inputSignChange];
}

#pragma  mark - UIScrollViewDelegate

// UIScrollViewがスクロール
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    int page = (offset.x + 160)/320;
    
    self.pageControl.currentPage = page;
    self.currentPage = page;
}
- (void)viewDidUnload {
    [self setAdView:nil];
    [super viewDidUnload];
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"ADBannerView didLoadAd");
    
    // バナーが表示されていなければバナーを表示する。
    if (!self.bannerIsVisible)
    {
        [UIView
         animateWithDuration:1.0    //アニメーションの時間を秒単位で指定
         animations:^{              // アニメーション内容を記述
             // ADBannerViewの高さ分上側に移動
             self.adView.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        }
         ];
        
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError*)error
{
    NSLog(@"ADBannerview didFailToReceiveAdWithError %@", error);
    
    // バナーが表示されていればバナーを非表示にする。
    if (self.bannerIsVisible)
    {
        [UIView
         animateWithDuration:1.0  //アニメーションの時間を秒単位で指定
         animations:^{            //アニメーション内容を記述
             //ADBannerViewの高さ分下側に移動
             self.adView.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
         }
         ];
        
        self.bannerIsVisible = NO;
    }
}
@end
