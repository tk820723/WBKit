//
//  NSString+WB.m
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/6/12.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import "NSString+WB.h"
//@引入MD5加密的框架
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (VECommon)
- (BOOL)wb_isEmpty{
    
    if (!self) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (BOOL)wb_isValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL validEmail = [emailTest evaluateWithObject:self];
    if(validEmail && self.length <= 30)
        return YES;
    return NO;
}

- (NSString *)wb_leaveOnlyNumbers{
    NSString *regex = @"[^0-9]";
    
    return   [self stringByReplacingOccurrencesOfString:regex withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (BOOL)wb_containsOnlyLetters
{
    NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}


- (BOOL)wb_containsOnlyNumbers
{
    NSCharacterSet *numbers = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbers].location == NSNotFound);
}

- (BOOL)wb_containsOnlyNumbersAndLetters
{
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}

- (NSString *)wb_removeWhiteSpacesFromString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}
- (NSString *)wb_removeNewLinesFromString
{
    NSArray *setArr = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *trimmedString = [setArr componentsJoinedByString:@""];
//    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    return trimmedString;
}

- (BOOL)wb_containsString:(NSString *)subString
{
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}

+ (NSString *)wb_UUID{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return [uuidString lowercaseString];
}

- (BOOL)wb_containsEmoji{
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}

- (NSString *)wb_removeEmoji
{
    //    __block BOOL isEomji = NO;
    __block NSMutableString *cleanStr = [NSMutableString string];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        BOOL isEomji = NO;
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
        if (!isEomji) {
            [cleanStr appendString:substring];
        }
    }];
    return cleanStr;
}



- (BOOL)wb_isValidPhoneNumber {
    // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (NSString *)wb_trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)wb_stringWithDuration:(float)duration{
    int seconds = (int)duration % 60;
    int minutes = (int)(duration / 60.0) ;
    int hours = (int)(duration / 3600.0);
    NSString *timeStr;
    if (hours) {
        timeStr = [NSString stringWithFormat:@"%d:%02d:%02d",hours,minutes,seconds];
    }else{
        timeStr = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
    }
    
    return timeStr;
}

+ (NSString *)wb_stringWithCount: (NSInteger)count{
    if (count > 1000) {
        double k = count / 1000.0;
        if (k > 1000) {
            double m = k / 1000.0;
            return [NSString stringWithFormat:@"%.1fm",m];
        }else{
            return [NSString stringWithFormat:@"%.1fk",k];
        }
    }else{
        return [NSString stringWithFormat:@"%d",(int)count];
    }
}

+ (NSString *)wb_stringWithBool:(BOOL)boolValue{
    return boolValue?@"true":@"false";
}



- (NSString *)wb_MD5{
    //1: 将字符串转换成C语言的字符串(因为:MD5加密是基于C的)
    const char *data = [self UTF8String];
    //2: 初始化一个字符串数组,用来存放MD5加密后的数据
    unsigned char resultArray[CC_MD5_DIGEST_LENGTH];
    //3: 计算MD5的值
    //参数一: 表示要加密的字符串
    //参数二: 表示要加密字符串的长度
    //参数三: 表示接受结果的数组
    CC_MD5(data, (CC_LONG) strlen(data), resultArray);
    //4: 初始化一个保存结果的字符串
    NSMutableString *resultString = [NSMutableString string];
    //5: 从保存结果的数组中,取出值赋给字符串
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02X", resultArray[i]];
    }
    //6: 返回结果
    return resultString;
}

+ (NSString *)wb_stringWithMicroSeconds:(int64_t)microSeconds{
    //先将微妙转位秒
    int64_t totalSeconds = lround(microSeconds / 1000000.0);
    
    int seconds = totalSeconds % 60;
    int minutes = (int)(totalSeconds / 60.0) ;
    int hours = (int)(totalSeconds / 3600.0);
    NSString *timeStr;
    if (hours) {
        timeStr = [NSString stringWithFormat:@"%d:%02d:%02d",hours,minutes,seconds];
    }else{
        timeStr = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
    }
    
    return timeStr;
}

- (NSInteger)wb_linesCount{
    NSArray *lines = [self componentsSeparatedByString:@"\n"];
    return lines.count;
}

- (CGSize)wb_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth{
   return [self boundingRectWithSize:CGSizeMake(maxWidth, 9999) options:NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil].size;
}

- (unsigned long long)wb_pathSize{
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 文件属性
    NSDictionary *attrs = [mgr attributesOfItemAtPath:self error:nil];
    
    unsigned long long int fileSize = 0;
    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]){ // dir
        NSArray *filesArray = [mgr subpathsOfDirectoryAtPath:self error:nil];
        NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
        NSString *fileName;
        
        while (fileName = [filesEnumerator nextObject]) {
            NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[self stringByAppendingPathComponent:fileName] error:nil];
            fileSize += [fileDictionary fileSize];
        }
    }else{
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:self error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

+ (NSString *)wb_fileSizeTextWithSize: (unsigned long long)fileSize{
    if (fileSize == 0) {
        return @"0KB";
    }
    
    NSString *sizeText;
    if (fileSize >= pow(10, 9)) { // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", fileSize / pow(10, 9)];
    } else if (fileSize >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", fileSize / pow(10, 6)];
    } else { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", fileSize / pow(10, 3)];
    }
    
    return sizeText;
}

@end
