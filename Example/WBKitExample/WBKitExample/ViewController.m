//
//  ViewController.m
//  WBKitExample
//
//  Created by Weibai Lu on 2018/3/1.
//  Copyright © 2018年 Weibai. All rights reserved.
//

#import "ViewController.h"
#import "WBPopout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 30);
}

- (void)didClickBtn: (UIButton *)btn{
    UIView *testV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    testV.backgroundColor = [UIColor greenColor];
    
    [WBPopout showPopoutView:testV];
}


@end
