//
//  WBAssetsManager.h
//  testAssetsSelection
//
//  Created by Weibai Lu on 2017/11/8.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "WBAssetAlbum.h"

@interface WBAssetsManager : NSObject

+ (instancetype)sharedManager;

- (PHAuthorizationStatus)authorizationStatus;
- (BOOL)authorizationStatusAuthorized;
- (void)requestAuthorizationCompletion: (void(^)(PHAuthorizationStatus status))completion;

- (NSMutableArray <WBAssetAlbum *>*)fetchAllAlbums;
- (NSMutableArray <WBAssetAlbum *>*)fetchAllVideosAlbums;
- (NSMutableArray <WBAssetAlbum *>*)fetchAllPhotosAlbums;

- (void)prepareForAlbum: (WBAssetAlbum *)album targetSize: (CGSize)size;
- (void)closeAlbum: (WBAssetAlbum *)album;
//获取视频封面／图片
- (PHImageRequestID)requestImageForAsset: (WBAsset *)asset targetSize: (CGSize)targetSize completion: (void(^)(UIImage *image, BOOL isDegrade, BOOL isFinished))completion synchronous: (BOOL)synchronous;
- (PHImageRequestID)requestImageForAlbum: (WBAssetAlbum *)album targetSize:(CGSize)size completion:(void (^)(UIImage *image, BOOL isDegrade, BOOL isFinished))completion synchronous: (BOOL)synchronous;

- (void)cancelRequest: (PHImageRequestID)requestID;

//将沙盒的媒体文件储存到相册
- (void)saveImageToAlbum:(NSString *)path completion: (void (^)(NSError *error, NSString *localID))completion;
- (void)saveVideoToAlbum:(NSString *)path completion: (void (^)(NSError *error, NSString *localID))completion;
@end
