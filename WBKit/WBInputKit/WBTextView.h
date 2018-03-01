//
//  VETextView.h
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/8/23.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBTextView : UITextView

@property (nonatomic, assign) IBInspectable NSUInteger maxLength;
@property (nonatomic,assign) BOOL canPaste;
@property (nonatomic,assign) BOOL canSelect;

@property (nonatomic,strong) NSString *placeholder;
@property (nonatomic,strong) UIColor *placeholderColor;
@property (nonatomic,strong) UIFont *placeholderFont;

@end
