//
//  WBAssetAlbum.m
//  testAssetsSelection
//
//  Created by Weibai Lu on 2017/11/8.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import "WBAssetAlbum.h"
#import <Photos/PHImageManager.h>

@implementation WBAssetAlbum

+ (instancetype)modelWithCollection:(PHAssetCollection *)collection{
    WBAssetAlbum *album = [[WBAssetAlbum alloc] init];
    
    album.name = collection.localizedTitle;
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    if (fetchResult.count) {
        NSMutableArray *assets = [NSMutableArray arrayWithCapacity:fetchResult.count];
        album.count = fetchResult.count;
        
        for (PHAsset *asset in fetchResult) {
            [assets addObject:asset];
        }
        album.assets = assets;
    }
    
    return album;
}

- (NSArray *)assetsFromAlbum{
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:self.assets.count];
    for (WBAsset *asset in self.assets) {
        [assets addObject:asset.asset];
    }
    return assets;
}



@end
