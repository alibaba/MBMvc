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


#import "TBMBDemoStep6ViewController.h"
#import "TBMBBind.h"
#import "TBMBDemoStep3Command.h"
#import "TBMBSimpleInstanceCommand+TBMBProxy.h"
#import "TBMBDefaultMediator.h"
#import "TBMBDefaultMediator+TBMBProxy.h"
#import "TBMBGlobalFacade.h"
#import "TBMBDefaultNotification.h"

@interface TBMBDemoStep6ViewController () <TBMBDemoStep6Delegate>
@property(nonatomic, copy) NSString *alertText;
@end

@implementation TBMBDemoStep6ViewController {

@private
    TBMBDefaultMediator *_mediator;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        _mediator = [TBMBDefaultMediator mediatorWithRealReceiver:self];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    TBMBDemoStep6View *navView = [[TBMBDemoStep6View alloc]
                                                     initWithFrame:self.view.bounds
                                                        withViewDO:nil];
    navView.delegate = _mediator.proxyObject;
    [self.view addSubview:navView];
    //这里做一次绑定 当alertText改变时 调用的逻辑
    TBMBBindObjectWeak(tbKeyPath(self, alertText), navView, ^(TBMBDemoStep6View *host, id old, id new) {
        if (old != [TBMBBindInitValue value]) {
            [host alert:new];
        }
    }
    );
}

- (void)showTime {
    //用proxyObject 而不是self 传递到 command的回调Block中,使Block不对self做一次retain,从而不干扰self本身的生命周期
    TBMBDemoStep6ViewController *delegate = _mediator.proxyObject;
    //用Command的proxyObject来调用 ,是这个调用被消息化,并被异步执行
    [[TBMBDemoStep3Command proxyObject] getData:^(NSDate *date) {
        //这个delegate是个代理,他的调用receiveDate也会被消息化,如果这个时候 self被dealloc ,delegate也不会变成野指针从而导致crash
        [delegate receiveDate:date];
    }];
}

- (void)showTime2 {

    TBMBGlobalSendTBMBNotification([TBMBDefaultNotification objectWithName:NSStringFromSelector(@selector($$getDate:))
                                                                       key:_mediator.notificationKey]
    );
}


- (void)receiveDate:(NSDate *)date {
    self.alertText = [NSString stringWithFormat:@"现在时间:%@",
                                                date];
}

- (void)$$receiveDate:(id <TBMBNotification>)notification {
    //业务层返回数据给 ViewController
    if (notification.key == _mediator.notificationKey) {
        self.alertText = [NSString stringWithFormat:@"现在时间:%@",
                                                    notification.body];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

- (void)dealloc {
    [_mediator close];
    NSLog(@"dealloc %@", self);

}

@end