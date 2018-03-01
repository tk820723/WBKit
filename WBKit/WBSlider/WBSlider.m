//
//  WBSlider.m
//  WBSlider
//
//  Created by Weibai Lu on 2017/9/12.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import "WBSlider.h"

#define kTwoWayShadowWidth   2

@interface WBSlider() <UIGestureRecognizerDelegate>

@property (nonatomic,assign) CGFloat sliderPosition;
@property (nonatomic,assign) CGRect sliderRect;
@property (nonatomic,assign) CGPoint gestureStartingPos;

@property (nonatomic,assign) BOOL isDragging;

@property (nonatomic,assign) CGRect zeroPointRect;
//@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) UILongPressGestureRecognizer *longP;

@end

@implementation WBSlider

- (instancetype)initWithType:(WBSliderType)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSelf];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeSelf];
    }
    return self;
}

- (void)setType:(WBSliderType)type{
    _type = type;
    
    if (type == WBSliderTypeNormal) {
        self.sliderPosition = 0;
    }else if (type == WBSliderTypeTwoWay){
        self.sliderPosition = 0.5;
    }
    
    [self setNeedsDisplay];
}

- (void)initializeSelf{
    self.tintColor = [UIColor colorWithRed:34/255.0 green:231/255.0 blue:179/255.0 alpha:1];
    self.sliderPosition = 0;
    self.sliderRadius = 8;
    self.backgroundColor = [UIColor clearColor];
    
    self.clipsToBounds = NO;
    self.longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    self.longP.delegate = self;
    self.longP.minimumPressDuration = 0.02;
    [self addGestureRecognizer:self.longP];
}

- (void)gestureRecognizer: (UILongPressGestureRecognizer *)longP{
    switch (longP.state) {
        case UIGestureRecognizerStateBegan:{
            self.isDragging = YES;
            
            if ([self.delegate respondsToSelector:@selector(WBSlider:willChangePercent:)]) {
                [self.delegate WBSlider:self willChangePercent:[self currentPercent]];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint pt = [longP locationInView:self];
            CGFloat width = self.bounds.size.width - self.sliderRadius * 2 - kTwoWayShadowWidth *2;
            CGFloat startingPos = self.sliderRadius + kTwoWayShadowWidth;
            CGFloat portion = (pt.x-startingPos)/width;
            if (portion < 0) {
                portion = 0;
            }else if (portion>1){
                portion = 1;
            }
            self.sliderPosition = portion;
            
            if ([self.delegate respondsToSelector:@selector(WBSlider:didChangePercent:)]) {
                static CGFloat previousPercent = 0;
                CGFloat currentPercent = [self currentPercent];
//                NSLog(@"%f",currentPercent);
                if (currentPercent != previousPercent) {
                    
                    [self.delegate WBSlider:self didChangePercent:currentPercent];
                }
                previousPercent = currentPercent;
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            [self updateSliderRect];
            self.isDragging = NO;

            if ([self.delegate respondsToSelector:@selector(WBSlider:didEndChangePercent:)]) {
                [self.delegate WBSlider:self didEndChangePercent:[self currentPercent]];
            }
            break;
        }
            
        default:
            break;
    }
    [self setNeedsDisplay];
}

- (void)updateSliderRect{
    CGFloat width = self.bounds.size.width - self.sliderRadius * 2 - kTwoWayShadowWidth *2;
    CGFloat startingPos = self.sliderRadius + kTwoWayShadowWidth;
    self.sliderRect = CGRectMake(self.sliderPosition * width + startingPos - self.sliderRadius * 2, self.bounds.size.height * 0.5 - self.sliderRadius * 2, self.sliderRadius * 4, self.sliderRadius * 4);
    
    if (self.type == WBSliderTypeTwoWay) {
        self.zeroPointRect = CGRectMake(self.bounds.size.width * 0.5 - 10, 0, 20, self.bounds.size.height);
    }else{
        self.zeroPointRect = CGRectMake(0, 0, 20, self.bounds.size.height);
    }
}

- (void)setCurrentPercent:(CGFloat)currentPercent{
    CGFloat currentPos = 0;
    if (self.type == WBSliderTypeNormal) {
        currentPos = currentPercent;
    }else if (self.type == WBSliderTypeTwoWay){
        if (currentPercent<0) {
            currentPos = (currentPercent +1) *0.5;
        }else{
            currentPos = currentPercent * 0.5 + 0.5;
        }
    }
    
    if (currentPos < 0) {
        currentPos = 0;
    }else if (currentPos>1){
        currentPos = 1;
    }
    
    _sliderPosition = currentPos;
    
    [self updateSliderRect];
    
    [self setNeedsDisplay];
}

- (CGFloat)currentPercent{
    CGFloat currentPercent = 0;
    if (self.type == WBSliderTypeNormal) {
        currentPercent = self.sliderPosition;
    }else if (self.type == WBSliderTypeTwoWay){
        if (self.sliderPosition<=0.5) {
            currentPercent = self.sliderPosition/0.5-1;
        }else{
            currentPercent = (self.sliderPosition-0.5) /0.5;
        }
    }
    
    return currentPercent;
}

- (CGFloat)sliderPosition{
    if (_sliderPosition<0) {
        _sliderPosition = 0;
    }else if (_sliderPosition>1){
        _sliderPosition = 1;
    }
    return _sliderPosition;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateSliderRect];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width = rect.size.width - self.sliderRadius * 2 - kTwoWayShadowWidth *2;
    CGFloat height = rect.size.height;
    CGFloat centerX = rect.size.width * 0.5;
    CGFloat centerY = height * 0.5;
    CGFloat startingPos = self.sliderRadius + kTwoWayShadowWidth;
    CGFloat endingPos = rect.size.width - self.sliderRadius;
    //画中间的横线
    [[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0] setFill];
    [[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0] setStroke];
    CGContextSetLineWidth(context, 3);
    CGContextMoveToPoint(context, startingPos, centerY);
    CGContextAddLineToPoint(context, endingPos, centerY);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //画中心点到圆的连线
    [self.tintColor setFill];
    [self.tintColor setStroke];
    if (self.type == WBSliderTypeNormal) {
        CGContextMoveToPoint(context, startingPos, centerY);
    }else if (self.type == WBSliderTypeTwoWay){
        CGContextMoveToPoint(context, centerX, centerY);
    }
    CGContextAddLineToPoint(context, width * self.sliderPosition + startingPos, centerY);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //画中间的黑色圆圈
    [[UIColor blackColor] setFill];
    [self.tintColor setStroke];
    CGContextSetLineWidth(context, 2);
    if (self.type == WBSliderTypeNormal) {
        CGContextAddArc(context, startingPos + 2, centerY, 4, 0, M_PI *2, YES);
    }else if (self.type == WBSliderTypeTwoWay){
        CGContextAddArc(context, centerX, centerY, 4, 0, M_PI *2, YES);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //画圆
    CGContextSetShadowWithColor(context,CGSizeZero, kTwoWayShadowWidth,[[UIColor grayColor] CGColor]);
    if (self.isDragging) {
        CGFloat r,g,b,a;
        [self.tintColor getRed:&r green:&g blue:&b alpha:&a];
        [[UIColor colorWithRed:r-0.1 green:g-0.1 blue:b-0.1 alpha:a] set];
    }else{
        [self.tintColor set];
    }
    CGContextAddArc(context, width * self.sliderPosition + startingPos, centerY, self.sliderRadius, 0, M_PI * 2, YES);
    CGContextFillPath(context);
    UIGraphicsPopContext();
}

@end
