//
//  WBAsset.h
//  testAssetsSelection
//
//  Created by Weibai Lu on 2017/11/8.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    WBAssetTypePhoto = 0,
    WBAssetTypeVideo
} WBAssetType;

@interface WBAsset : PHAsset

@property (nonatomic,strong) PHAsset *asset;
@property (nonatomic,assign) WBAssetType type;

/// Init a photo dataModel With a asset
/// 用一个PHAsset/ALAsset实例，初始化一个asset模型
+ (instancetype)modelWithAsset:(PHAsset *)asset;
//同步获取一个url 和 文件大小  需要传入一个信号
- (void)requestAssetFileForUrlSizeCompletion: (void(^)(NSURL *url, NSInteger fileSize))completion sem: (dispatch_semaphore_t)sem;

@end
