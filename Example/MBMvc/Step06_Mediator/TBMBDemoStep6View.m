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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午12:20.
//


#import "TBMBDemoStep6View.h"


@implementation TBMBDemoStep6View {

}
- (void)loadView {
    [super loadView];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 140, 200, 30)];
    [button addTarget:self
               action:@selector(showTime)
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"Show Time"
            forState:UIControlStateNormal];
    [self addSubview:button];

    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 80, 200, 30)];
    [button2 addTarget:self
                action:@selector(showTime2)
      forControlEvents:UIControlEventTouchUpInside];
    button2.backgroundColor = [UIColor blueColor];
    [button2 setTitle:@"Show Time"
             forState:UIControlStateNormal];
    [self addSubview:button2];
}

- (void)showTime {
    [self.delegate showTime];
}

- (void)showTime2 {
    [self.delegate showTime2];
}

- (void)alert:(NSString *)text {
    [[[UIAlertView alloc]
                   initWithTitle:@"title"
                         message:text
                        delegate:nil
               cancelButtonTitle:@"关闭"
               otherButtonTitles:nil] show];

}

- (void)dealloc {
    NSLog(@"dealloc %@", self);

}
@end