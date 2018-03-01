//
//  UINavigationController+WB.m
//  VRVideoEdit
//
//  Created by Weibai Lu on 2017/6/15.
//  Copyright © 2017年 Veer. All rights reserved.
//

#import "UINavigationController+WB.h"
#import <objc/runtime.h>
static char alphaViewKey;

@implementation UINavigationController (VECommon)

- (void)setve_alphaView: (UIImageView *)wb_alphaView{
    objc_setAssociatedObject(self, &alphaViewKey, wb_alphaView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)wb_alphaView{
    return objc_getAssociatedObject(self, &alphaViewKey);
}

- (void)wb_setBackgroundColor:(UIColor *)color{
    if (![self wb_alphaView]) {
        [self setve_alphaView:[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.navigationBar.bounds.size.height + 20)]];
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = [UIImage new];
        [self.navigationBar insertSubview:[self wb_alphaView] atIndex:0];
    }
    
    [[self wb_alphaView] setBackgroundColor:color];
}

- (void)wb_setAlpha:(CGFloat)alpha{
    if (![self wb_alphaView]) {
        [self setve_alphaView:[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.navigationBar.bounds.size.height + 20)]];
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = [UIImage new];
        [self.navigationBar insertSubview:[self wb_alphaView] atIndex:0];
    }
    if ( [self wb_alphaView].alpha != alpha) {
        [self wb_alphaView].alpha = alpha;
    }
}

- (void)wb_setBackgroundImage:(UIImage *)image{
    if (![self wb_alphaView]) {
        [self setve_alphaView:[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.navigationBar.bounds.size.height + 20)]];
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = [UIImage new];
        [self.navigationBar insertSubview:[self wb_alphaView] atIndex:0];
    }
    [[self wb_alphaView] setImage:image];
    [[self wb_alphaView] setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [[self wb_alphaView] setFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.navigationBar.bounds.size.height + 20)];
}
@end
