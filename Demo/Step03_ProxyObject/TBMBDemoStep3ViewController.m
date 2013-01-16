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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午12:21.
//


#import "TBMBDemoStep3ViewController.h"
#import "TBMBBind.h"
#import "TBMBDefaultRootViewController+TBMBProxy.h"
#import "TBMBDemoStep3Command.h"
#import "TBMBSimpleInstanceCommand+TBMBProxy.h"

@interface TBMBDemoStep3ViewController () <TBMBDemoStep3Delegate>
@property(nonatomic, copy) NSString *alertText;
@end

@implementation TBMBDemoStep3ViewController {

}
- (void)loadView {
    [super loadView];
    TBMBDemoStep3View *navView = [[TBMBDemoStep3View alloc] initWithFrame:self.view.frame withViewDO:nil];
    navView.delegate = self.proxyObject;
    [self.view addSubview:navView];
    //这里做一次绑定 当alertText改变时 调用的逻辑
    TBMBBindObjectWeak(tbKeyPath(self, alertText), navView, ^(TBMBDemoStep3View *host, id old, id new) {
        if (old != [TBMBBindInitValue value]) {
            [host alert:new];
        }
    }
    );
}

- (void)showTime {
    //用proxyObject 而不是self 传递到 command的回调Block中,使Block不对self做一次retain,从而不干扰self本身的生命周期
    TBMBDemoStep3ViewController *delegate = self.proxyObject;
    //用Command的proxyObject来调用 ,是这个调用被消息化,并被异步执行
    [[TBMBDemoStep3Command proxyObject] getData:^(NSDate *date) {
        //这个delegate是个代理,他的调用receiveDate也会被消息化,如果这个时候 self被dealloc ,delegate也不会变成野指针从而导致crash
        [delegate receiveDate:date];
    }];
}

- (void)receiveDate:(NSDate *)date {
    self.alertText = [NSString stringWithFormat:@"现在时间:%@", date];
}

@end