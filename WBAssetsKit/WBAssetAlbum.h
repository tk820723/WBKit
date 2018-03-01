//
//  WBAssetAlbum.h
//  testAssetsSelection
//
//  Created by Weibai Lu on 2017/11/8.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WBAsset.h"

@interface WBAssetAlbum : NSObject

@property (nonatomic,strong) NSMutableArray <WBAsset *>*assets;
@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic,strong) PHAssetCollection *collection;

+ (instancetype)modelWithCollection: (PHAssetCollection *)collection;

- (NSArray *)assetsFromAlbum;

@end
