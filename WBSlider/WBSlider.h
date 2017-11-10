//
//  WBSlider.h
//  WBSlider
//
//  Created by Weibai Lu on 2017/9/12.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBSlider;
@protocol WBSliderDelegate <NSObject>

- (void)WBSlider: (WBSlider *)slider willChangePercent: (CGFloat)percent;
- (void)WBSlider: (WBSlider *)slider didChangePercent: (CGFloat)percent;
- (void)WBSlider: (WBSlider *)slider didEndChangePercent: (CGFloat)percent;

@end

typedef enum : NSUInteger {
    WBSliderTypeNormal,
    WBSliderTypeTwoWay
} WBSliderType;

@interface WBSlider : UIView
//default green
@property (nonatomic,strong) UIColor *tintColor;

@property (nonatomic,assign) CGFloat sliderRadius;
@property (nonatomic,weak) id <WBSliderDelegate>delegate;

@property (nonatomic,assign) WBSliderType type;

@property (nonatomic,assign) BOOL canClickZeroPt;

- (instancetype)initWithType: (WBSliderType)type;

//For Double Slider current percent from -1 ~~~ 1
//For Normal Slider current percent from 0 ~~~ 1
- (void)setCurrentPercent: (CGFloat)currentPercent;
- (CGFloat)currentPercent;

@end
