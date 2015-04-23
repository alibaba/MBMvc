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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-17 上午9:40.
//


#import "TBMBTestInterceptorViewController.h"
#import "TBMBTestInterceptorViewDO.h"
#import "TBMBDefaultPage.h"
#import "TBMBTestInterceptorView.h"
#import "TBMBBind.h"
#import "TBMBSimpleInstanceCommand+TBMBProxy.h"

@interface TBMBTestInterceptorViewController ()
@property(nonatomic, strong) TBMBTestInterceptorViewDO *viewDO;
@end

@implementation TBMBTestInterceptorViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewDO = [[TBMBTestInterceptorViewDO alloc] init];
    }
    return self;
}


- (void)loadView {
    [super loadView];
    TBMBTestInterceptorView *view = [[TBMBTestInterceptorView alloc]
                                                              initWithFrame:self.view.bounds withViewDO:self.viewDO];
    [self.view addSubview:view];
}

//这里监听 当self.viewDO.showTime被改变时会触发这个操作
TBMBWhenThisKeyPathChange(viewDO, showTime) {
    if (!isInit && old && [new boolValue]) {
        [[TBMBDemoStep5Command proxyObject] getDate:self.viewDO];
    }
}

//这里接受Log拦截器发过来的数据并显示出来
- (void)$$receiveLog:(id <TBMBNotification>)notification {
    self.viewDO.log = [NSString stringWithFormat:@"发起了一个请求:%@ \n\n %@", notification.body, self.viewDO.log ? : @""];
}

@end