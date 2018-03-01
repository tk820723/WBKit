//
//  WBHorizontalButtonMenu.h
//  WBHorizontalButtonMenu
//
//  Created by Weibai Lu on 2017/9/12.
//  Copyright © 2017年 VeeR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBHorizontalButtonMenu;
@protocol WBHorizontalButtonMenuDataSource <NSObject>

- (CGFloat)WBHorizontalButtonMenu: (WBHorizontalButtonMenu *)menu buttonWidthForIndex: (NSInteger)index;

@end

@interface WBHorizontalButtonMenu : UIView

@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic,strong) NSMutableArray *buttons;
//@property (nonatomic,assign) CGFloat buttonWidth;
@property (nonatomic,assign) CGFloat spacing;
@property (nonatomic,assign) UIEdgeInsets contentInsets;
@property (nonatomic,weak) id <WBHorizontalButtonMenuDataSource>datasource;
- (void)initializeSelf;

+ (instancetype)menuWithSpacing: (CGFloat)spacing;

- (void)addBtn: (UIButton *)button;

- (void)addBtns: (NSArray <UIButton *> *)btns;

@end
