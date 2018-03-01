//
//  NSString+WB.h
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/6/12.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (VECommon)
//是否只包含空格或者没有字符
- (BOOL)wb_isEmpty;
//清空字符串中的首尾空白字符
- (NSString *)wb_trimString;
//是否含有emoji
- (BOOL)wb_containsEmoji;
//清除emoji
- (NSString *)wb_removeEmoji;
//清除所有别的字母汉字只留下数字
- (NSString *)wb_leaveOnlyNumbers;
- (NSString *)wb_MD5;
+ (NSString *)wb_UUID;

//是否是有效的email
- (BOOL)wb_isValidEmail;
//是否是有效的手机号码
- (BOOL)wb_isValidPhoneNumber;
//只包含字母
- (BOOL)wb_containsOnlyLetters;
//只有数字
- (BOOL)wb_containsOnlyNumbers;
//只有数字和字幕
- (BOOL)wb_containsOnlyNumbersAndLetters;
//移除空格
- (NSString *)wb_removeWhiteSpacesFromString;
//移除换行
- (NSString *)wb_removeNewLinesFromString;
//有substring
- (BOOL)wb_containsString:(NSString *)subString;

+ (NSString *)wb_stringWithDuration:(float)doration;

+ (NSString *)wb_stringWithCount: (NSInteger)count;

+ (NSString *)wb_stringWithBool: (BOOL)boolValue;

+ (NSString *)wb_stringWithMicroSeconds: (int64_t)microSeconds;

- (NSInteger)wb_linesCount;

- (CGSize)wb_sizeWithFont: (UIFont *)font maxWidth: (CGFloat)maxWidth;

- (unsigned long long)wb_pathSize;

+ (NSString *)wb_fileSizeTextWithSize: (unsigned long long)fileSize;
@end
