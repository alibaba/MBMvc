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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-31 下午4:58.
//


#import <objc/message.h>
#import "TBMBDefaultPage.h"
#import "TBMBUtil.h"


@implementation TBMBDefaultPage

- (id)initWithFrame:(CGRect)frame withViewDO:(id)viewDO {
    self = [self initWithFrame:frame];
    if (self) {
        SEL selector = @selector(setViewDO:);
        if ([self respondsToSelector:selector]) {
            void (*objc_msgSendTypeAll)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
            objc_msgSendTypeAll(self, selector, viewDO);
        }
        [self loadView];
        [self autoBindingKeyPath];
        [self afterAutoBindingLoadView];
    }
    return self;
}

- (void)loadView {

}

- (void)afterAutoBindingLoadView {

}

//自动扫描keyBinding
- (void)autoBindingKeyPath {
    TBMBAutoBindingKeyPath(self);
}


@end