//
//  UIButton+WB.m
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/9/11.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import "UIButton+WB.h"

@implementation UIButton (VEVertical)

- (void)wb_setTitle:(NSString *)title localImage:(NSString *)localImageName titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont spacing:(CGFloat)spaceing style:(VEButtonNewLayoutType)layoutType{
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:localImageName] forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    self.titleLabel.font = titleFont;
    CGSize textSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: titleFont} context:nil].size;
    
    CGSize imageSize = [UIImage imageNamed:localImageName].size;
    
    if (layoutType == VEButtonNewLayoutTypeUpIconDownTitle) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height - spaceing, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(-textSize.height - spaceing, 0, 0, -textSize.width);
    }else if (layoutType == VEButtonNewLayoutTypeLeftTitleRightIcon){
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - spaceing*0.5, 0, imageSize.width+ spaceing*0.5);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, textSize.width+ spaceing*0.5, 0, -textSize.width- spaceing*0.5);
    }
    
}

//- (void)wb_setSelected:(BOOL)selected{
//    [self setSelected:selected];
//    if (selected) {
//        self.layer.borderWidth = 2;
//        self.layer.borderColor = VEThemeColor.CGColor;
//    }else{
//        self.layer.borderColor = VEClear.CGColor;
//        self.layer.borderWidth = 0;
//    }
//}

//- (void)verticalImageAndTitle:(CGFloat)spacing
//{
//    self.titleLabel.backgroundColor = [UIColor greenColor];
//    CGSize imageSize = self.imageView.frame.size;
//    CGSize titleSize = self.titleLabel.frame.size;
//    CGSize textSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil].size;
//    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
//    if (titleSize.width + 0.5 < frameSize.width) {
//        titleSize.width = frameSize.width;
//    }
//    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
//    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
//    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
//    
//}
@end
