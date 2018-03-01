//
//  WBTextField.h
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/10/27.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBTextField;

@protocol WBTextFieldDelegate <NSObject>

- (void)textFieldDidChange: (WBTextField *)textField;

@end

@interface WBTextField : UITextField

@property (nonatomic,assign) IBInspectable NSInteger maxLength;


//可以输入emoji 默认no
@property (nonatomic,assign) BOOL allowEmojiInput;
@property (nonatomic,assign) BOOL allowCopyPasteMenu;

@property (nonatomic,weak) id <WBTextFieldDelegate> aDelegate;

@end
