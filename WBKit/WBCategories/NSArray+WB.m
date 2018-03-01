//
//  NSArray+WB.m
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/6/20.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import "NSArray+WB.h"

@implementation NSArray (VESafe)
- (id)wb_objectAtIndexSafe:(NSInteger)index{
    if (self.count > index && index >=0) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}

- (NSArray *)wb_sortedArrayUsingKey:(NSString *)key ascending: (BOOL)isAscending{
    if (!key.length) {
        return nil;
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                 ascending:isAscending];
    NSArray *sortedArray = [self sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}
@end
