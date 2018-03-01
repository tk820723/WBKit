//
//  NSArray+WB.h
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/6/20.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (VESafe)

- (id)wb_objectAtIndexSafe: (NSInteger)index;

//从某个属性(key)进行sort isAscending是否是正序
- (NSArray *)wb_sortedArrayUsingKey: (NSString *)key ascending: (BOOL)isAscending;
@end
