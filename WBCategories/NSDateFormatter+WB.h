//
//  NSDateFormatter+WB.h
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/6/12.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (VECommon)

+ (instancetype)sharedDateFormatter;
+ (instancetype)UTCFormmater;

+ (NSString *)UTCTimestamp;
@end
