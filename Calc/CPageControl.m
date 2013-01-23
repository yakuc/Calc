//
//  CPageControl.m
//  Calc
//
//  Created by YAKUC on 2012/11/25.
//  Copyright (c) 2012年 YAKUC. All rights reserved.
//

#import "CPageControl.h"

@implementation CPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/** override to update dots */
- (void) setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    
    // update dot views
    [self updateDots];
}

/** override to update dots */
- (void) setNumberOfPages:(NSInteger)number
{
    [super setNumberOfPages:number];
    
    // update dot views
    [self updateDots];
}

/** override to update dots */
- (void) updateCurrentPageDisplay
{
    [super updateCurrentPageDisplay];
    
    // update dot views
    [self updateDots];
}

/** Override setImageNormal */
- (void) setImageNormal:(UIImage*)image
{
    _imageNormal = image;
    
    // update dot views
    [self updateDots];
}

/** Override setImageCurrent */
- (void) setImageCurrent:(UIImage*)image
{
    _imageCurrent = image;
    
    // update dot views
    [self updateDots];
}

/** Override to fix when dots are directly clicked */
- (void) endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    [self updateDots];
}

#pragma mark - (Private)

- (void) updateDots
{
    if(_imageCurrent || _imageNormal)
    {
        // Get subviews
        NSArray* dotViews = self.subviews;
        for(int i = 0; i < dotViews.count; ++i)
        {
            UIImageView* dot = [dotViews objectAtIndex:i];
            // Set image
            dot.image = (i == self.currentPage) ? _imageCurrent : _imageNormal;
        }
    }
}

@end
