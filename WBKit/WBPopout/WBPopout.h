//
//  WBPopout.h
//  VeeR
//
//  Created by Weibai Lu on 2018/3/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WBPopout : NSObject

/**
 显示popout的tip弹框 传入popoutView必须有自己的bounds （default背景模糊）

 @param popoutView 必须有自己的bounds
 */
+ (void)showPopoutView: (UIView *)popoutView;


/**
 显示popout的tip弹框 传入popoutView必须有自己的bounds

 @param popoutView 必须有自己的bounds
 @param isNeedBlurBg 是否需要模糊背景
 */
+ (void)showPopoutView: (UIView *)popoutView isNeedBlurBg: (BOOL)isNeedBlurBg;

/**
 显示popout的tip弹框 传入popoutView必须有自己的bounds
 
 @param popoutView 必须有自己的bounds
 @param isNeedBlurBg 是否需要模糊背景
 */
+ (void)showPopoutView: (UIView *)popoutView isNeedBlurBg: (BOOL)isNeedBlurBg dismissBlock: (void(^)())dismissBlock;

/**
 关闭弹窗
 */
+ (void)dismissWithCompletion: (void(^)(void))completion;
@end
