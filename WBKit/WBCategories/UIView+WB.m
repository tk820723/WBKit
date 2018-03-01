//
//  UIView+WB.m
//  VRVideoEditDemo
//
//  Created by Weibai Lu on 2017/5/23.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import "UIView+WB.h"

@implementation UIView (VECommon)
- (CGFloat)wb_x{
    return self.frame.origin.x;
}

- (CGFloat)wb_y{
    return self.frame.origin.y;
}

- (CGFloat)wb_width{
    return self.bounds.size.width;
}

- (CGFloat)wb_height{
    return self.bounds.size.height;
}

- (CGSize)wb_size{
    return self.bounds.size;
}

- (CGPoint)wb_origin{
    return self.frame.origin;
}

- (void)wb_sizeToFitWithMaxWidth:(CGFloat)Width{
    self.bounds = CGRectMake(0, 0, Width, 2000);
    [self sizeToFit];
}

- (UIColor *)wb_colorOfPoint:(CGPoint)point{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

@end
