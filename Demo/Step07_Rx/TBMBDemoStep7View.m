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
// Created by Wentong on 15/2/6.
//

#import "TBMBDemoStep7View.h"
#import "TBMBDemoStep7ViewModel.h"


@implementation TBMBDemoStep7View {

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

}

- (void)showTime {

}


- (void)dealloc {
    NSLog(@"dealloc %@", self);

}
@end