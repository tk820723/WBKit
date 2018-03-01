//
//  WBAsset.m
//  testAssetsSelection
//
//  Created by Weibai Lu on 2017/11/8.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import "WBAsset.h"

@implementation WBAsset
+ (instancetype)modelWithAsset:(PHAsset *)asset{
    WBAsset *model = [[WBAsset alloc] init];
    model.asset = asset;
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        model.type = WBAssetTypeVideo;
    }else if(asset.mediaType == PHAssetMediaTypeImage){
        model.type = WBAssetTypePhoto;
    }else{
        return nil;
    }
    
    return model;
}

- (void)requestAssetFileForUrlSizeCompletion:(void (^)(NSURL *url, NSInteger fileSize))completion sem:(dispatch_semaphore_t)sem{
    if (self.type == WBAssetTypeVideo) {
        PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = NO;

        [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
            AVURLAsset *videoAsset = (AVURLAsset*)avasset;

            NSNumber *size;
            
            
            [videoAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];

            if (completion) {
                completion(videoAsset.URL,size.integerValue);
            }
            dispatch_semaphore_signal(sem);
        }];
    }else if(self.type == WBAssetTypePhoto){
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSURL *url = [info objectForKey:@"PHImageFileURLKey"];
            NSInteger fileSize  = imageData.length;
            
            if (completion) {
                completion(url,fileSize);
            }
            dispatch_semaphore_signal(sem);
        }];
    }else{
        
//        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//        options.synchronous = YES;
//
//        [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//
//        }];
//
//        if (completion) {
//
//        }
        
        dispatch_semaphore_signal(sem);
    }
}

@end
