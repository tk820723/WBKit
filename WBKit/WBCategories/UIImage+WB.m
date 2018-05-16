//
//  UIImage+WB.m
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/6/24.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import "UIImage+WB.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@implementation UIImage (VECommon)

+ (void)wb_thumbnailImagesForVideo:(NSURL *)videoURL imageSize: (CGSize)imageSize totalCount: (NSInteger)totalCount completion: (void(^)(UIImage *image, NSInteger index))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *thumbnails = [NSMutableArray arrayWithCapacity:totalCount];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeCleanAperture;
        assetImageGenerator.maximumSize = imageSize;
        for (int i = 0; i<totalCount; i++) {
            CGFloat portion = (CGFloat)i / totalCount;
            
            CGImageRef thumbnailImageRef = NULL;
            CFTimeInterval thumbnailImageTime = asset.duration.value * portion;
            NSError *thumbnailImageGenerationError = nil;
            thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, asset.duration.timescale) actualTime:NULL error:&thumbnailImageGenerationError];
            
            if(!thumbnailImageRef)
                NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
            
            UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
            
            if (thumbnailImage) {
                [thumbnails addObject:thumbnailImage];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(thumbnailImage, i);
                }
            });
            
            CGImageRelease(thumbnailImageRef);
        }
    });
}

+ (UIImage*)wb_thumbnailImageForVideo:(NSURL *)videoURL atPortionTime:(CGFloat)portionTime{
    if (portionTime < 0) {
        portionTime = 0;
    }else if (portionTime > 1){
        portionTime = 1;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = asset.duration.value * portionTime;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, asset.duration.timescale) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

+ (UIImage*)wb_thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

+ (UIImage *)wb_imageWithColor:(UIColor *)color{
    return [UIImage wb_imageWithColor:color Size:CGSizeMake(4.0f, 4.0f)];
}

+ (UIImage *)wb_imageWithColor:(UIColor *)color Size:(CGSize)size
{
    return [self wb_imageWithColor:color Size:size rounded:NO];
}

+ (UIImage *)wb_imageWithColor:(UIColor *)color Size:(CGSize)size rounded:(BOOL)rounded
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);

    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (rounded) {
        return [image wb_cornerRadius:5];
    }else{
        return [image wb_stretched];
    }
}


- (UIImage *)wb_flipImage{
    UIGraphicsBeginImageContext(self.size);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(0.,0., self.size.width, self.size.height),self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// CGContext 裁剪
- (UIImage *)wb_cornerRadius:(CGFloat)c {
    int w = self.size.width * self.scale;
    int h = self.size.height * self.scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, c);
    CGContextAddArcToPoint(context, 0, 0, c, 0, c);
    CGContextAddLineToPoint(context, w-c, 0);
    CGContextAddArcToPoint(context, w, 0, w, c, c);
    CGContextAddLineToPoint(context, w, h-c);
    CGContextAddArcToPoint(context, w, h, w-c, h, c);
    CGContextAddLineToPoint(context, c, h);
    CGContextAddArcToPoint(context, 0, h, 0, h-c, c);
    CGContextAddLineToPoint(context, 0, c);
    CGContextClosePath(context);
    
    CGContextClip(context);     // 先裁剪 context，再画图，就会在裁剪后的 path 中画
    [self drawInRect:CGRectMake(0, 0, w, h)];       // 画图
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}

- (UIImage *)wb_stretched
{
    CGSize size = self.size;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
    
    return [self resizableImageWithCapInsets:insets];
}

- (UIImage *)wb_scaleImageWithOffset:(UIEdgeInsets)insets{
    CGFloat targetWidth = self.size.width;
    CGFloat targetHeight = self.size.height;
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    CGContextRef ctx= UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    [[UIColor clearColor] setFill];
    CGContextFillRect(ctx, CGRectMake(0, 0, targetWidth, targetHeight));
    CGContextDrawImage(ctx, CGRectMake(insets.left, insets.top, targetWidth - insets.left - insets.right, targetHeight - insets.top - insets.bottom),  [self CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)wb_scaleImageWithSize:(CGSize)size offset:(UIEdgeInsets)insets{
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
//    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
//    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
//    if (bitmapInfo == kCGImageAlphaNone) {
//        bitmapInfo = kCGImageAlphaNoneSkipLast;
//    }
    
    CGContextRef bitmap= UIGraphicsGetCurrentContext();
    
//    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown) {
//        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, kCGImageAlphaPremultipliedLast);
//
//    } else {
//        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, kCGImageAlphaPremultipliedLast);
//
//    }
//
//    if (self.imageOrientation == UIImageOrientationLeft) {
//        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
//        CGContextTranslateCTM (bitmap, 0, -targetHeight);
//
//    } else if (self.imageOrientation == UIImageOrientationRight) {
//        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
//        CGContextTranslateCTM (bitmap, -targetWidth, 0);
//
//    } else if (self.imageOrientation == UIImageOrientationUp) {
//        // NOTHING
//    } else if (self.imageOrientation == UIImageOrientationDown) {
//        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
//        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
//    }
//    [[UIColor clearColor] set];
//    CGContextFillRect(bitmap, CGRectMake(0, 0, targetWidth, targetHeight));
//    CGContextClearRect(bitmap, CGRectMake(0, 0, targetWidth, targetHeight));
    CGContextTranslateCTM(bitmap, 0.0, size.height);
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    [[UIColor clearColor] setFill];
    CGContextFillRect(bitmap, CGRectMake(0, 0, targetWidth, targetHeight));
    CGContextDrawImage(bitmap, CGRectMake(insets.left, insets.top, targetWidth - insets.left - insets.right, targetHeight - insets.top - insets.bottom), [self CGImage]);
//    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
//
//    UIImage* newImage = [UIImage imageWithCGImage:ref];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    CGImageRelease(imageRef);
//    CGImageRelease(ref);
    
    return newImage;
}

- (UIImage *)wb_scaleImageWithSize:(CGSize)size{
    return [self wb_scaleImageWithSize:size offset:UIEdgeInsetsZero];
}


@end
