//
//  NSDateFormatter+WB.m
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/6/12.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import "NSDateFormatter+WB.h"

@implementation NSDateFormatter (VECommon)
static NSDateFormatter *_instanceType = nil;
static NSDateFormatter *_utcInstance = nil;

+ (instancetype)sharedDateFormatter{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[NSDateFormatter alloc]init];
        
        //设定时间格式,这里可以设置成自己需要的格式
        [_instanceType setDateFormat:@"MM/dd/yyyy"];
    });
    
    return _instanceType;
}

+ (instancetype)UTCFormmater{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _utcInstance = [[NSDateFormatter alloc]init];
        [_utcInstance setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        
        //设定时间格式,这里可以设置成自己需要的格式
        [_utcInstance setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    });
    
    return _utcInstance;
}

+ (NSString *)UTCTimestamp{
    return [[NSDateFormatter UTCFormmater] stringFromDate:[NSDate date]];
}
@end
