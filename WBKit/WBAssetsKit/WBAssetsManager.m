//
//  WBAssetsManager.m
//  testAssetsSelection
//
//  Created by Weibai Lu on 2017/11/8.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import "WBAssetsManager.h"
#import <Photos/PHImageManager.h>

@interface WBAssetsManager()

@property (nonatomic,strong) PHCachingImageManager *cacheImageManager;

@end

@implementation WBAssetsManager
static WBAssetsManager *_shareInstance;
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[WBAssetsManager alloc] init];
    });
    return _shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheImageManager = [[PHCachingImageManager alloc] init];
    }
    return self;
}

- (PHAuthorizationStatus)authorizationStatus{
    return [PHPhotoLibrary authorizationStatus];
}

- (void)requestAuthorizationCompletion:(void (^)(PHAuthorizationStatus))completion{
    switch ([self authorizationStatus]) {
        case PHAuthorizationStatusAuthorized:
            if (completion) {
                completion(PHAuthorizationStatusAuthorized);
            }
            break;
        case PHAuthorizationStatusDenied:
            if (completion) {
                completion(PHAuthorizationStatusDenied);
            }
            break;
        case PHAuthorizationStatusRestricted:{
            if (completion) {
                completion(PHAuthorizationStatusRestricted);
            }
            break;
        }
        case PHAuthorizationStatusNotDetermined:{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (completion) {
                    completion(status);
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (BOOL)authorizationStatusAuthorized {
    return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}

- (NSMutableArray<WBAssetAlbum *> *)fetchAllAlbums{
    if (![self authorizationStatusAuthorized]){
        return nil;
    }
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
   option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld || mediaType == %ld", PHAssetMediaTypeVideo, PHAssetMediaTypeImage];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 列出所有用户创建的相册
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    NSArray *fetchResults = @[smartAlbums,topLevelUserCollections];
    
    NSMutableArray *albums = [NSMutableArray array];
    for (PHFetchResult *fetchResult in fetchResults) {
        for (PHAssetCollection *collection in fetchResult) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                WBAssetAlbum *album = [WBAssetAlbum modelWithCollection:collection];
                if (album) {
                    [albums addObject:album];
                }

            }
        }
    }
    
    return albums;
}

- (NSMutableArray<WBAssetAlbum *> *)fetchAllPhotosAlbums{
    if (![self authorizationStatusAuthorized]){
        return nil;
    }
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 列出所有用户创建的相册
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    NSArray *fetchResults = @[smartAlbums,topLevelUserCollections];
    
    NSMutableArray *albums = [NSMutableArray array];
    for (PHFetchResult *fetchResult in fetchResults) {
        for (PHAssetCollection *collection in fetchResult) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                WBAssetAlbum *album = [WBAssetAlbum modelWithCollection:collection];
                if (album) {
                    [albums addObject:album];
                }
                
            }
        }
    }
    
    return albums;
}

- (NSMutableArray<WBAssetAlbum *> *)fetchAllVideosAlbums{
    if (![self authorizationStatusAuthorized]){
        return nil;
    }
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 列出所有用户创建的相册
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    NSArray *fetchResults = @[smartAlbums,topLevelUserCollections];
    
    NSMutableArray *albums = [NSMutableArray array];
    for (PHFetchResult *fetchResult in fetchResults) {
        for (PHAssetCollection *collection in fetchResult) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                WBAssetAlbum *album = [WBAssetAlbum modelWithCollection:collection];
                if (album) {
                    [albums addObject:album];
                }
                
            }
        }
    }
    
    return albums;
}

- (void)prepareForAlbum:(WBAssetAlbum *)album targetSize:(CGSize)size{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = NO;
    [self.cacheImageManager startCachingImagesForAssets:[album assetsFromAlbum] targetSize:size contentMode:PHImageContentModeAspectFill options:options];
}

- (void)closeAlbum:(WBAssetAlbum *)album{
    [self.cacheImageManager stopCachingImagesForAllAssets];
}

- (PHImageRequestID)requestImageForAsset:(WBAsset *)asset targetSize:(CGSize)targetSize completion:(void (^)(UIImage *, BOOL, BOOL))completion synchronous:(BOOL)synchronous{
    if (asset) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.networkAccessAllowed = NO;
        options.synchronous = synchronous;
        return [self.cacheImageManager requestImageForAsset:asset.asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (completion) {
                BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
                BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                
                completion(result, isDegraded, downloadFinined);
            }
        }];
    }else{
        return 0;
    }

}

- (PHImageRequestID)requestImageForAlbum:(WBAssetAlbum *)album targetSize:(CGSize)size completion:(void (^)(UIImage *, BOOL, BOOL))completion synchronous:(BOOL)synchronous{
    WBAsset *asset = [album.assets firstObject];
    if (asset) {
        return [self requestImageForAsset:asset targetSize:size completion:completion synchronous:synchronous];
    }
    return 0;
}

- (void)cancelRequest:(PHImageRequestID)requestID{
    [self.cacheImageManager cancelImageRequest:requestID];
}

- (void)saveAssetToAlbum: (NSString *)path assetType: (PHAssetMediaType)type completion: (void (^)(NSError *error, NSString *localID))completion{
    if ([self authorizationStatus] == PHAuthorizationStatusAuthorized) {
        __block NSString *localId;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *createAssetRequest;
            // Request creating an asset from media.
            if (type == PHAssetMediaTypeVideo) {
                createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:path]];
            }else if (type == PHAssetMediaTypeImage){
                createAssetRequest = [PHAssetChangeRequest  creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:path]];
            }
            localId = createAssetRequest.placeholderForCreatedAsset.localIdentifier;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (!error) {
                if (completion) {
                    completion(nil,localId);
                }
            }else{
                if (completion) {
                    completion(error,nil);
                }
            }
        }];
    }else{
        if (completion) {
            completion([NSError errorWithDomain:@"com.error.domain" code:1001 userInfo:@{NSLocalizedDescriptionKey:@"Unauthorized"}],nil);
        }
    }
}

- (void)saveImageToAlbum:(NSString *)path completion: (void (^)(NSError *error, NSString *localID))completion{
    [self saveAssetToAlbum:path assetType:PHAssetMediaTypeImage completion:completion];
}

- (void)saveVideoToAlbum:(NSString *)path completion: (void (^)(NSError *error, NSString *localID))completion{
    [self saveAssetToAlbum:path assetType:PHAssetMediaTypeVideo completion:completion];
}

@end
