//
//  WBColorSlider.m
//  WBSlider
//
//  Created by Weibai Lu on 2017/9/13.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import "WBColorSlider.h"

#define kGradientSliderShadowWidth   2
#define kGradientSliderLineWidth   3
#define kTotalGradientColorCount    8

@interface WBColorSlider () <UIGestureRecognizerDelegate>
@property (nonatomic,assign) CGFloat sliderPosition;
@property (nonatomic,assign) BOOL isDragging;
@property (nonatomic,assign) CGRect sliderRect;

@end

@implementation WBColorSlider

+ (instancetype)singleColorSliderWithHue:(CGFloat)hue saturation:(CGFloat)saturation{
    WBColorSlider *slider = [[WBColorSlider alloc] init];
    slider.isSingleColor = YES;
    slider.hue = hue;
    slider.saturation = saturation;
    slider.sliderPosition = saturation;
    return slider;
}

+ (instancetype)fullColorSliderWithInitialHue:(CGFloat)initialHue saturation:(CGFloat)saturation{
    WBColorSlider *slider = [[WBColorSlider alloc] init];
    slider.isSingleColor = NO;
    slider.hue = initialHue;
    slider.saturation = saturation;
    slider.sliderPosition = initialHue;
    return slider;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeSelf];
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

- (void)setSaturation:(CGFloat)saturation{
    _saturation = saturation;
    
    if (self.isSingleColor) {
        self.sliderPosition = saturation;
        [self updateSliderRect];
    }
    [self setNeedsDisplay];
}

- (CGFloat)sliderStartingPosition{
    return [self sliderRadius] + kGradientSliderLineWidth + kGradientSliderShadowWidth;
}

- (CGFloat)sliderRadius{
   return (self.bounds.size.height - 2 * kGradientSliderShadowWidth)* 0.5;
}

- (CGFloat)sliderMovingWidth{
    return self.bounds.size.width - 2 * kGradientSliderShadowWidth - 2 * kGradientSliderLineWidth - [self sliderRadius] * 2;
}

- (void)setHue:(CGFloat)hue{
    _hue = hue;
    if (!self.isSingleColor) {
        self.sliderPosition = hue;
        [self updateSliderRect];
    }
    [self setNeedsDisplay];
}

- (void)initializeSelf{
    self.backgroundColor = [UIColor clearColor];
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    longP.delegate = self;
    longP.minimumPressDuration = 0.02;
    [self addGestureRecognizer:longP];
}

- (void)gestureRecognizer: (UILongPressGestureRecognizer *)longP{
    switch (longP.state) {
        case UIGestureRecognizerStateBegan:{
            self.isDragging = YES;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint pt = [longP locationInView:self];
            CGFloat sliderLineWidth = 3;
            CGFloat sliderRadius = (self.bounds.size.height - 2 * kGradientSliderShadowWidth)* 0.5;
            CGFloat sliderStartPos = sliderRadius + sliderLineWidth + kGradientSliderShadowWidth;
            CGFloat slideWidth = self.bounds.size.width - 2 * kGradientSliderShadowWidth - 2 * sliderLineWidth - sliderRadius * 2;
            CGFloat portion = (pt.x-sliderStartPos)/slideWidth;
            if (portion < 0) {
                portion = 0;
            }else if (portion>1){
                portion = 1;
            }
            self.sliderPosition = portion;
            
            if (self.isSingleColor) {
                _saturation = self.sliderPosition;
                if ([self.delegate respondsToSelector:@selector(WBColorSlider:didChangeSaturation:)]) {
                    [self.delegate WBColorSlider:self didChangeSaturation:self.sliderPosition];
                }
            }else{
                _hue = self.sliderPosition;
                if ([self.delegate respondsToSelector:@selector(WBColorSlider:didChangeHue:)]) {
                    [self.delegate WBColorSlider:self didChangeHue:self.sliderPosition];
                }
            }

            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            [self updateSliderRect];
            self.isDragging = NO;
            break;
        }
            
        default:
            break;
    }
    [self setNeedsDisplay];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint pt = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.sliderRect, pt)) {
        return YES;
    }
    return NO;
}

- (void)updateSliderRect{
    CGFloat sliderLineWidth = kGradientSliderLineWidth;
    CGFloat centerY = self.bounds.size.height *0.5;
    CGFloat sliderRadius = (self.bounds.size.height - 2 * kGradientSliderShadowWidth)* 0.5;
    CGFloat sliderStartPos = sliderRadius + sliderLineWidth + kGradientSliderShadowWidth;
    CGFloat slideWidth = self.bounds.size.width - 2 * kGradientSliderShadowWidth - 2 * sliderLineWidth - sliderRadius * 2;
    self.sliderRect = CGRectMake(self.sliderPosition * slideWidth + sliderStartPos - sliderRadius * 2, centerY - sliderRadius * 2, sliderRadius * 4, sliderRadius * 4);
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGFloat sliderLineWidth = 3;
    CGFloat centerY = rect.size.height *0.5;
    CGFloat gradientLeftStartPos = kGradientSliderShadowWidth + sliderLineWidth;
    CGFloat gradientRightEndPos = rect.size.width - kGradientSliderShadowWidth - sliderLineWidth;
    CGFloat gradientTopStartPos = sliderLineWidth + kGradientSliderShadowWidth;
    CGFloat gradientBottomEndPos = rect.size.height - kGradientSliderShadowWidth - sliderLineWidth;
    CGFloat sliderRadius = (rect.size.height - 2 * kGradientSliderShadowWidth)* 0.5;
    CGFloat sliderStartPos = sliderRadius + sliderLineWidth + kGradientSliderShadowWidth;
    CGFloat slideWidth = rect.size.width - 2 * kGradientSliderShadowWidth - 2 * sliderLineWidth - sliderRadius * 2;
 
    //画圆角矩形
    CGFloat radius = (rect.size.height - 2 * kGradientSliderShadowWidth - 2 * sliderLineWidth)* 0.5;
    CGContextMoveToPoint(context, radius + gradientLeftStartPos, gradientTopStartPos);
    CGContextAddArc(context, radius + gradientLeftStartPos, centerY, radius, M_PI_2, M_PI_2 *3, NO);
    CGContextMoveToPoint(context, radius + gradientLeftStartPos, gradientBottomEndPos);
    CGContextAddLineToPoint(context, gradientRightEndPos - radius, gradientBottomEndPos);
    CGContextAddArc(context, gradientRightEndPos - radius, centerY, radius, M_PI_2, M_PI_2*3, YES);
    CGContextAddLineToPoint(context, radius + gradientLeftStartPos, gradientTopStartPos);
    
    CGContextClip(context);
    
    //画渐变色
    if (!self.isSingleColor) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[kTotalGradientColorCount+1];
        
        NSMutableArray *colors = [NSMutableArray array];
        for (int i = 0; i<=kTotalGradientColorCount; i++) {
            locations[i]=1.0/kTotalGradientColorCount * i;
            [colors addObject:(__bridge id)([UIColor colorWithHue:(CGFloat)i / kTotalGradientColorCount saturation:self.saturation brightness:1.0 alpha:1.0].CGColor)];
        }
        
        CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
        CGColorSpaceRelease(colorSpace);
        CGContextDrawLinearGradient(context, gradient, startPoint,endPoint, 0);
        
        CGGradientRelease(gradient);
    }else{
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[2] = {0,1};
        
        NSArray *colors = @[(__bridge id)([UIColor colorWithHue:self.hue saturation:0 brightness:1.0 alpha:1.0].CGColor),(__bridge id)([UIColor colorWithHue:self.hue saturation:1.0 brightness:1.0 alpha:1.0].CGColor)];
        
        CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
        CGColorSpaceRelease(colorSpace);
        CGContextDrawLinearGradient(context, gradient, startPoint,endPoint, 0);
        
        CGGradientRelease(gradient);
    }
    
    CGContextRestoreGState(context);
    
    //画圆形滑块
    UIColor *fillColor;
    if (self.isSingleColor) {
        fillColor = [UIColor colorWithHue:self.hue saturation:self.sliderPosition brightness:1.0 alpha:1.0];
    }else{
        fillColor = [UIColor colorWithHue:self.sliderPosition saturation:self.saturation brightness:1.0 alpha:1.0];
    }
    
    CGContextSetLineWidth(context, sliderLineWidth);
    CGContextSetShadowWithColor(context,CGSizeZero, kGradientSliderShadowWidth,[[UIColor grayColor] CGColor]);
    [fillColor setFill];
    [[UIColor whiteColor] setStroke];
    CGContextAddArc(context, sliderStartPos + self.sliderPosition * slideWidth, centerY, sliderRadius, 0, M_PI * 2, YES);
    CGContextDrawPath(context, kCGPathFillStroke);

    UIGraphicsPopContext();
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateSliderRect];
}

@end
