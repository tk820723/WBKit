//
//  WBKeychainWrapper.h
//  VRVideoEdit
//
//  Created by Weibai Lu on 2018/2/27.
//  Copyright © 2018年 Veer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBKeychainWrapper : NSObject{
    NSMutableDictionary        *keychainData;
    NSMutableDictionary        *genericPasswordQuery;
}

/******* Public *******/
@property (nonatomic, strong) NSMutableDictionary *keychainData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;
// 设置对应的key value 会自动写入
- (void)setKeychainObject:(id)inObject forKey:(id)key;
// 取出keychainData中的obj
- (id)keychainObjectForKey:(id)key;
// 设置password
- (void)setKeychainPassword: (NSString *)password;
- (NSString *)password;
// 设置account
- (void)setKeychainAccount: (NSString *)account;
- (NSString *)account;

- (BOOL)removePasswordItem;

// 设置keychainData default value
- (void)resetKeychainItem;

@end
