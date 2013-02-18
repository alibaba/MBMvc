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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-17 上午9:35.
//


#import "TBMBTestInterceptorView.h"
#import "TBMBBind.h"
#import "TBMBTestInterceptorViewDO.h"


@implementation TBMBTestInterceptorView {
@private
    UITextView *textView;

}
- (void)loadView {
    [super loadView];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 40, 200, 30)];
    [button addTarget:self action:@selector(showTime) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"Show Time" forState:UIControlStateNormal];
    [self addSubview:button];

    textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 80, 200, 300)];
    textView.backgroundColor = [UIColor blueColor];
    [self addSubview:textView];
}

- (void)showTime {
    self.viewDO.showTime = YES;
}

TBMBWhenThisKeyPathChange(viewDO, alertText){
    if (!isInit && new) {
        [[[UIAlertView alloc]
                       initWithTitle:@"title"
                             message:new
                            delegate:nil cancelButtonTitle:@"关闭"
                   otherButtonTitles:nil] show];
    }
}

TBMBWhenThisKeyPathChange(viewDO, log){
    if (new) {
        textView.text = new;
    }
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);

}
@end