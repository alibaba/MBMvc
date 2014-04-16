/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 *///
// Created by 文通 on 14-4-16 上午10:27.
//


#import "TBMBDemoStep7ViewController.h"
#import "TBMBDemoStep3Command.h"
#import "TBMBDemoStep7Command.h"
#import "TBMBSimpleInstanceCommand+TBMBPromisesProxy.h"
#import "TBMBDemoStep7View.h"
#import "TBMBDefaultRootViewController+TBMBProxy.h"
#import "TBMBBind.h"

@interface TBMBDemoStep7ViewController () <TBMBDemoStep7Delegate>
@property(nonatomic, copy) NSString *alertText;
@end

@implementation TBMBDemoStep7ViewController {

}

- (void)loadView {
    [super loadView];
    TBMBDemoStep7View *navView = [[TBMBDemoStep7View alloc]
                                                     initWithFrame:self.view.bounds
                                                        withViewDO:nil];
    navView.delegate = self.proxyObject;
    [self.view addSubview:navView];

    //这里做一次绑定 当alertText改变时 调用的逻辑
    TBMBBindObjectWeak(tbKeyPath(self, alertText), navView, ^(TBMBDemoStep7View *host, id old, id new) {
        if (old != [TBMBBindInitValue value]) {
            [host alert:new];
        }
    }
    );
}


- (void)showTime {
    //用proxyObject 而不是self 传递到 command的回调Block中,使Block不对self做一次retain,从而不干扰self本身的生命周期
    //用Command的proxyObject来调用 ,是这个调用被消息化,并被异步执行
    [[[TBMBDemoStep7Command deferredProxyObject] getData] then:^id(id result) {
        NSLog(@"isMainThread:%d", [NSThread isMainThread]);
        self.alertText = [NSString stringWithFormat:@"现在时间:%@",
                                                    result];
        return nil;
    }];
}
@end