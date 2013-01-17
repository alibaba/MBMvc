/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 */
//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 上午10:12.
//


#import "TBMBNavView.h"
#import "TBMBNavViewDO.h"


@implementation TBMBNavView {

}

- (void)loadView {
    [super loadView];
    CGFloat h = 20;
    for (TBMBDemoStep step = TBMB_DEMO_STEP01; step < TBMB_DEMO_END; step++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, h, 200, 30)];
        [button addTarget:self action:@selector(gotoStep:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = step;
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:[NSString stringWithFormat:@"第%d课", (step + 1)] forState:UIControlStateNormal];
        [self addSubview:button];
        h += 40;
    }

    UIButton *buttonMem = [[UIButton alloc] initWithFrame:CGRectMake(50, h, 200, 30)];
    [buttonMem addTarget:self action:@selector(gotoTestMem) forControlEvents:UIControlEventTouchUpInside];
    buttonMem.backgroundColor = [UIColor blueColor];
    [buttonMem setTitle:@"测试内存警告" forState:UIControlStateNormal];
    [self addSubview:buttonMem];
    h += 40;

    UIButton *buttonInterceptor = [[UIButton alloc] initWithFrame:CGRectMake(50, h, 200, 30)];
    [buttonInterceptor addTarget:self
                          action:@selector(gotoTestInterceptor)
                forControlEvents:UIControlEventTouchUpInside];
    buttonInterceptor.backgroundColor = [UIColor blueColor];
    [buttonInterceptor setTitle:@"测试拦截器" forState:UIControlStateNormal];
    [self addSubview:buttonInterceptor];
}

- (void)gotoTestInterceptor {
    self.viewDO.gotoTestInterceptor = YES;
}

- (void)gotoTestMem {
    self.viewDO.gotoTestMemory = YES;
}

//点中按钮的调用
- (void)gotoStep:(UIButton *)button {
    self.viewDO.demoStep = (TBMBDemoStep) button.tag;
}


@end