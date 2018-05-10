//
//  WBPopout.m
//  VeeR
//
//  Created by Weibai Lu on 2018/3/24.
//

#import "WBPopout.h"
#import <Masonry/Masonry.h>

@interface WBPopout() <UIGestureRecognizerDelegate>
@property (nonatomic,weak) UIView *container;
@property (nonatomic,weak) UIVisualEffectView *containerBg;
@property (nonatomic,weak) UIButton *closeBtn;
@property (nonatomic,copy) void (^dismissBlock)(void);
@property (nonatomic,weak) UIView *popoutView;
@property (nonatomic,assign) BOOL isNeedBlurEffect;

@property (nonatomic,assign) BOOL isAnimating;

@end

@implementation WBPopout

static WBPopout *_shareInstance;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[WBPopout alloc] init];
    });
    return _shareInstance;
}

+ (void)showPopoutView:(UIView *)popoutView{
    [self showPopoutView:popoutView isNeedBlurBg:YES];
}

+ (void)showPopoutView:(UIView *)popoutView isNeedBlurBg:(BOOL)isNeedBlurBg{
    [self showPopoutView:popoutView isNeedBlurBg:isNeedBlurBg dismissBlock:nil];
}

+ (void)showPopoutView:(UIView *)popoutView isNeedBlurBg:(BOOL)isNeedBlurBg dismissBlock:(void (^)(void))dismissBlock{
    [[WBPopout sharedInstance] showPopoutView:popoutView isNeedBlurBg:isNeedBlurBg dismissBlock:dismissBlock];
}

+ (void)dismissWithCompletion:(void (^)(void))completion{
    [[WBPopout sharedInstance] dismissWithCompletion:completion];
}

- (void)showPopoutView:(UIView *)popoutView isNeedBlurBg:(BOOL)isNeedBlurBg dismissBlock:(void (^)(void))dismissBlock{
    
    //已经显示了 或着正在显示
    if (self.container || self.isAnimating) {
        [self clear];
        return;
    }
    
    if (!popoutView) {
            NSLog(@"WBPopout error: popoutView cannot by nil!!");
            return;
    }

    self.isNeedBlurEffect = isNeedBlurBg;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (!window) {
        NSLog(@"WBPopout error: keywindow cannot by nil!!");
        return;
    }
    
    UIView *container = [[UIView alloc] init];
    self.container = container;
    [window addSubview:self.container];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBG:)];
    tap.delegate = self;
    [self.container addGestureRecognizer:tap];
    
    if (self.isNeedBlurEffect) {
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:nil];
//        effectView.frame = container.bounds;
        self.containerBg = effectView;
        effectView.userInteractionEnabled = NO;
        [self.container addSubview:self.containerBg];
        self.container.backgroundColor = [UIColor clearColor];
        
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.container);
        }];
    }else{
        self.container.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.container.alpha = 0;
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBtn = closeBtn;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setImage:[UIImage imageNamed:@"popout_close"] forState:UIControlStateNormal];
    [self.container addSubview:self.closeBtn];
    
    [self.container addSubview:popoutView];
    self.popoutView = popoutView;
    
    [popoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.container);
        if (popoutView.bounds.size.width && popoutView.bounds.size.height) {
            make.size.mas_equalTo(popoutView.bounds.size);
        }
    }];

    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.container);
        make.bottom.equalTo(self.container).with.offset(-58);
    }];
    
    [self.container setNeedsUpdateConstraints];
    
    self.dismissBlock = dismissBlock;

    [self startPopoutAnimation];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.container];
    if (CGRectContainsPoint(self.popoutView.frame, point)) {
        return NO;
    }else{
        return YES;
    }
}

- (void)didClickBG: (UITapGestureRecognizer *)reg{
        [self dismissWithCompletion:self.dismissBlock];
}

- (void)startPopoutAnimation{
    self.isAnimating = YES;
//    self.container.alpha = 0;
    self.popoutView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.001, 0.001);
    [UIView animateWithDuration:0.15 animations:^{
        [self.containerBg setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
//        self.container.alpha = 1.0;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.popoutView.transform =
            CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.popoutView.transform = CGAffineTransformIdentity;
            }completion:^(BOOL finished) {
                self.isAnimating = NO;
            }];
        }];
    }];
}

- (void)dismissWithCompletion:(void (^)(void))completion{
    if (!self.container || self.isAnimating) {
        [self clear];
        return;
    }

    self.isAnimating = YES;
    [UIView animateWithDuration:0.1 animations:^{
        self.popoutView.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.popoutView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                [self.containerBg setEffect:nil];
                self.closeBtn.alpha = 0;
            } completion:^(BOOL finished) {
                [self clear];
                self.isAnimating = NO;
                
                if (completion) {
                    completion();
                }
            }];
        }];
    }];
}

- (void)clear{
    [self.closeBtn removeFromSuperview];
    self.closeBtn = nil;
    
    [self.containerBg removeFromSuperview];
    self.containerBg = nil;
    
    [self.popoutView removeFromSuperview];
    self.popoutView = nil;
    
    [self.container removeFromSuperview];
    self.container = nil;
}

- (void)closeBtnClicked: (UIButton *)btn{
    if (self.dismissBlock) {
        self.dismissBlock();
    }else{
        [self dismissWithCompletion:nil];
    }
    
    self.dismissBlock = nil;
}

@end
