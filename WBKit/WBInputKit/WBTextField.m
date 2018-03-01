//
//  WBTextField.m
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/10/27.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import "WBTextField.h"

@implementation WBTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeSelf];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSelf];
    }
    return self;
}

- (void)initializeSelf{
    self.maxLength = 999;
    
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.allowCopyPasteMenu = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEdited:) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (!self.allowCopyPasteMenu) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)textFieldDidEdited:(NSNotification *)obj{
    if (![self isFirstResponder]) {
        return;
    }
    
    NSString *toBeString = self.text;
    if (!self.allowEmojiInput) {
        toBeString = [self removeEmoji:toBeString];
    }
    
    NSString *lang = [self.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxLength) {
                self.text = [toBeString substringToIndex:self.maxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > self.maxLength) {
            self.text = [toBeString substringToIndex:self.maxLength];
        }
    }
    
    if ([self.aDelegate respondsToSelector:@selector(textFieldDidChange:)]) {
        [self.aDelegate textFieldDidChange:self];
    }
}

- (NSString *)removeEmoji: (NSString *)str
{
    //    __block BOOL isEomji = NO;
    __block NSMutableString *cleanStr = [NSMutableString string];
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
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

@end
