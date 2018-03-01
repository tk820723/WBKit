//
//  UIImage+WB.h
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/6/24.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (VECommon)
//异步调用 回调为主线程
+ (void)wb_thumbnailImagesForVideo:(NSURL *)videoURL imageSize: (CGSize)imageSize totalCount: (NSInteger)totalCount completion: (void(^)(UIImage *image, NSInteger index))completion;
+ (UIImage*)wb_thumbnailImageForVideo:(NSURL *)videoURL atPortionTime:(CGFloat)portionTime;
+ (UIImage*)wb_thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
+ (UIImage *)wb_imageWithColor:(UIColor *)color;
+ (UIImage *)wb_imageWithColor:(UIColor *)color Size:(CGSize)size;
+ (UIImage *)wb_imageWithColor:(UIColor *)color Size:(CGSize)size rounded: (BOOL)rounded;

- (UIImage *)wb_scaleImageWithSize: (CGSize)size;
//Offset 边上留下的透明区域
- (UIImage *)wb_scaleImageWithOffset: (UIEdgeInsets)insets;
- (UIImage *)wb_scaleImageWithSize: (CGSize)size offset: (UIEdgeInsets)insets;
@end
