//
//  UIView+WB.h
//  VRVideoEditDemo
//
//  Created by Weibai Lu on 2017/5/23.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (VECommon)
- (CGFloat)wb_x;

- (CGFloat)wb_y;

- (CGFloat)wb_width;

- (CGFloat)wb_height;

- (CGSize)wb_size;

- (CGPoint)wb_origin;

- (void)wb_sizeToFitWithMaxWidth: (CGFloat)Width;

- (UIColor *)wb_colorOfPoint:(CGPoint)point;

@end
