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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午12:59.
//


#import "TBMBDemoStep5ViewController.h"
#import "TBMBDemoStep5ViewDO.h"
#import "TBMBDemoStep5View.h"
#import "TBMBSimpleInstanceCommand+TBMBProxy.h"
#import "TBMBBind.h"
#import "TBMBDemoStep5Command.h"

@interface TBMBDemoStep5ViewController ()
@property(nonatomic, strong) TBMBDemoStep5ViewDO *viewDO;
@end

@implementation TBMBDemoStep5ViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewDO = [[TBMBDemoStep5ViewDO alloc] init];
    }
    return self;
}


- (void)loadView {
    [super loadView];
    //这里将 self.viewDO 传给View 使他们都使用一个ViewDO,那么对这个ViewDO的操作都能被触发
    TBMBDemoStep5View *view = [[TBMBDemoStep5View alloc] initWithFrame:self.view.bounds withViewDO:self.viewDO];
    [self.view addSubview:view];
}

//这里监听 当self.viewDO.showTime被改变时会触发这个操作
TBMBWhenThisKeyPathChange(viewDO, showTime) {
    if (!isInit && old && [new boolValue]) {
        //用Command的proxyObject来调用 ,是这个调用被消息化,并被异步执行
        //这里直接传入self.viewDO 直接在业务层改变这个ViewDO,从而出发View的改变,由于线程问题
        //记得需要设置 TBMBSetBindableRunThreadIsBindingThread(YES);来保证View的改变在主线程执行
        [[TBMBDemoStep5Command proxyObject] getDate:self.viewDO];
    }
}

@end