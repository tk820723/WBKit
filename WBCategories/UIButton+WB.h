//
//  UIButton+WB.h
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/9/11.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VEButtonNewLayoutTypeUpIconDownTitle,
    VEButtonNewLayoutTypeLeftIconRightTitle,
    VEButtonNewLayoutTypeLeftTitleRightIcon,
} VEButtonNewLayoutType;

@interface UIButton (VEVertical)

- (void)wb_setTitle: (NSString *)title localImage: (NSString *)localImageName titleColor: (UIColor *)titleColor titleFont: (UIFont *)titleFont spacing: (CGFloat)spaceing style: (VEButtonNewLayoutType)layoutType;

//- (void)wb_setSelected: (BOOL)selected;

@end
