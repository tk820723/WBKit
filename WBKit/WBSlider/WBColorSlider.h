//
//  WBColorSlider.h
//  WBSlider
//
//  Created by Weibai Lu on 2017/9/13.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBColorSlider;
@protocol WBColorSliderDelegate <NSObject>

- (void)WBColorSlider: (WBColorSlider *)slider didChangeSaturation: (CGFloat)saturation;
- (void)WBColorSlider: (WBColorSlider *)slider didChangeHue: (CGFloat)hue;


@end

@interface WBColorSlider : UIView

@property (nonatomic,assign) BOOL isSingleColor;

@property (nonatomic,assign) CGFloat hue;
@property (nonatomic,assign) CGFloat saturation;

- (CGFloat)sliderRadius;
- (CGFloat)sliderStartingPosition;
- (CGFloat)sliderMovingWidth;

@property (nonatomic,weak) id <WBColorSliderDelegate>delegate;

+ (instancetype)singleColorSliderWithHue: (CGFloat)hue saturation: (CGFloat)saturation;
+ (instancetype)fullColorSliderWithInitialHue: (CGFloat)initialHue saturation: (CGFloat)saturation;

@end
