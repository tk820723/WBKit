//
//  VETextView.m
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/8/23.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import "WBTextView.h"

@interface WBTextView ()
@property (nonatomic,strong) UILabel *placeholderLabel;

@end

@implementation WBTextView

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
    self.placeholderLabel = [UILabel new];
    [self addSubview:self.placeholderLabel];
    self.placeholderLabel.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNoti:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)didReceiveNoti: (NSNotification *)noti{
    if ([noti.name isEqualToString:UITextViewTextDidChangeNotification]) {
        // 禁止第一个字符输入空格或者换行
        if (self.text.length == 1) {
            if ([self.text isEqualToString:@" "] || [self.text isEqualToString:@"\n"]) {
                self.text = @"";
            }
        }
        
        if (_maxLength != NSUIntegerMax && _maxLength != 0) {
            NSString    *toBeString    = self.text;
            UITextRange *selectedRange = [self markedTextRange];
            UITextPosition *position   = [self positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                if (toBeString.length > _maxLength) {
                    self.text = [toBeString substringToIndex:_maxLength]; // 截取最大限制字符数.
                }
            }
        }
        
        if (self.text.length) {
            self.placeholderLabel.hidden = YES;
        }else{
            self.placeholderLabel.hidden = NO;
        }
    }
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text.length) {
        self.placeholderLabel.hidden = YES;
    }else{
        self.placeholderLabel.hidden = NO;
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.hidden = NO;
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
    [self setNeedsLayout];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    
    self.placeholderLabel.font = placeholderFont;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.placeholderLabel sizeToFit];
    
    self.placeholderLabel.frame = CGRectMake(self.textContainerInset.left + 5, self.textContainerInset.top, self.placeholderLabel.wb_width, self.placeholderLabel.wb_height);
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)){
        return self.canPaste;
    }else if (action == @selector(select:)){
        return self.canSelect;
    }else if (action == @selector(selectAll:)){
        return self.canSelect;
    }
    return [super canPerformAction:action withSender:sender];
}



@end
