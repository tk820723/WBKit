//
//  WBHorizontalButtonMenu.m
//  WBHorizontalButtonMenu
//
//  Created by Weibai Lu on 2017/9/12.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import "WBHorizontalButtonMenu.h"

#define kWBHorizontalButtonMenuButtonDefaultWidth   70

@implementation WBHorizontalButtonMenu

- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

+ (instancetype)menuWithSpacing:(CGFloat)spacing{
    WBHorizontalButtonMenu *menu = [[[self class] alloc] init];
    menu.spacing = spacing;
//    menu.buttonWidth = btnWidth;
    return menu;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSelf];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeSelf];
    }
    return self;
}

- (void)initializeSelf{
    self.contentView = [[UIScrollView alloc] init];
    self.contentView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.contentView];
    
//    self.buttonWidth = 90;
}

- (void)addBtn:(UIButton *)button{
    [self.contentView addSubview:button];
    [self.buttons addObject:button];
    [self wb_layoutSubviews];
}

- (void)wb_layoutSubviews{
    self.contentView.frame = self.bounds;
    UIButton *preBtn;
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *btn = [self.buttons objectAtIndex:i];
        CGFloat btnWidth = kWBHorizontalButtonMenuButtonDefaultWidth;
        if ([self.datasource respondsToSelector:@selector(WBHorizontalButtonMenu:buttonWidthForIndex:)]) {
            btnWidth = [self.datasource WBHorizontalButtonMenu:self buttonWidthForIndex:i];
        }
        if (preBtn) {
            btn.frame = CGRectMake(CGRectGetMaxX(preBtn.frame) + self.spacing, self.contentInsets.top, btnWidth, self.contentView.bounds.size.height);
        }else{
            btn.frame = CGRectMake(self.contentInsets.left, self.contentInsets.top, btnWidth, self.contentView.bounds.size.height);
        }
        preBtn = btn;
    }
    UIButton *lastBtn = [self.buttons lastObject];
    self.contentView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame) + self.contentInsets.right, 0);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self wb_layoutSubviews];
}

- (void)addBtns:(NSArray<UIButton *> *)btns{
    for (UIButton *btn in btns) {
        [self.contentView addSubview:btn];
        [self.buttons addObject:btn];
    }
    [self wb_layoutSubviews];
}

@end
