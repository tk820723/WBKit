//
//  UIColor+WB.h
//  VRVideoEdit
//
//  Created by Weibai Lu on 2018/1/24.
//  Copyright © 2018年 Veer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WB)
+ (UIColor*)wb_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor*)wb_colorWithHex:(NSInteger)hexValue;

+ (NSString *)wb_hexFromUIColor: (UIColor*) color;

- (NSString *)wb_hexString;

@end
