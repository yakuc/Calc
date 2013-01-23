//
//  CCalcDisplayView.m
//  Calc
//
//  Created by YAKUC on 2012/11/18.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import "CCalcDisplayView.h"

@interface CCalcDisplayView()

@property (nonatomic, assign) BOOL fixedMarkStatus;
@property (nonatomic, assign) BOOL memoryStatus;
@property (nonatomic, assign) BOOL errorStatus;

@end

@implementation CCalcDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [[NSBundle mainBundle] loadNibNamed:@"CCalcDisplayView" owner:self options:nil];
    [self addSubview:self.contentView];
}

- (NSString*)mainDisplayText
{
    return self.mainDisplayLabel.text;
}

- (void)setMainDisplayText:(NSString*)text
{
    self.mainDisplayLabel.text = text;
}


- (void)setPlusDisplayStatus:(BOOL)status
{
    self.operatorLabel.text = [NSString stringWithFormat:@"＋ "];
}

- (void)setMinusDisplayStatus:(BOOL)status
{
    self.operatorLabel.text = [NSString stringWithFormat:@"ー　 "];
}

- (void)setMultiplyDisplayStatus:(BOOL)status
{
    self.operatorLabel.text = [NSString stringWithFormat:@"×　　 "];
   
}

- (void)setDivideDisplayStatus:(BOOL)status
{
    self.operatorLabel.text = [NSString stringWithFormat:@"÷　　　 "];
    
}

- (void)setEqualDisplayStatus:(BOOL)status
{
    self.operatorLabel.text = [NSString stringWithFormat:@"="];
}

- (void)setFixedMarkStatus:(BOOL)status
{
    if (_fixedMarkStatus == status) {
        return;
    }
    
    _fixedMarkStatus = status;
    [self setStatusLabel];
}

- (void)setMemoryStatus:(BOOL)status
{
    if (_memoryStatus == status) {
        return;
    }
    
    _memoryStatus = status;
    [self setStatusLabel];
}

- (void)setErrorStatus:(BOOL)status
{
    if (_errorStatus == status) {
        return;
    }
    
    _errorStatus = status;
    [self setStatusLabel];
}

- (void)setStatusLabel
{
    NSString* memoryStr = nil;
    NSString* fixedStr = nil;
    NSString* errorStr = nil;
    
    if (_memoryStatus == YES) {
        memoryStr = @"M";
    } else {
        memoryStr = @" ";
    }
    
    if (self.fixedMarkStatus) {
        fixedStr = @"K";
    } else {
        fixedStr = @" ";
    }
    
    if (self.errorStatus) {
        errorStr = @"ERR";
    } else {
        errorStr = @"";
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"%@ %@ %@", memoryStr, fixedStr, errorStr];
}

- (void)clearOperatorView
{
    self.operatorLabel.text = @"";
}

- (NSString*)subDisplayText
{
    return _subDisplayLabel.text;
}

- (void)setSubDisplayText:(NSString*)text
{
    _subDisplayLabel.text = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
