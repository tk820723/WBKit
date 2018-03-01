//
//  UIColor+WB.m
//  VRVideoEdit
//
//  Created by Weibai Lu on 2018/1/24.
//  Copyright © 2018年 Veer. All rights reserved.
//

#import "UIColor+WB.h"

@implementation UIColor (WB)
+ (UIColor*)wb_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)wb_colorWithHex:(NSInteger)hexValue
{
    return [UIColor wb_colorWithHex:hexValue alpha:1.0];
}

- (NSString *)wb_hexString{
    return [UIColor wb_hexFromUIColor:self];
}

+ (NSString *)wb_hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}
@end
