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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-17 上午9:21.
//


#import "TBMBTestMemoryView.h"


@implementation TBMBTestMemoryView {

}

- (void)loadView {
    [super loadView];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 140, 200, 30)];
    [button addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"Next Page" forState:UIControlStateNormal];
    [self addSubview:button];

}

- (void)nextPage {
    [self.delegate pushNewPage];
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);
}
@end