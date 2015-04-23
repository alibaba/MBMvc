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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-17 上午9:22.
//


#import "TBMBTestMemoryViewController.h"
#import "TBMBTestMemoryView.h"
#import "TBMBDefaultRootViewController+TBMBProxy.h"
#import "TBMBBind.h"


@interface TBMBTestMemoryViewController () <TBMBTestMemoryDelegate>
@end

@implementation TBMBTestMemoryViewController {

}

- (void)loadView {
    [super loadView];
    TBMBTestMemoryView *view = [[TBMBTestMemoryView alloc] initWithFrame:self.view.bounds withViewDO:nil];
    view.delegate = self.proxyObject;
    [self.view addSubview:view];
    //这里做一次绑定 当title改变时 调用的逻辑
    TBMBBindObjectWeak(tbKeyPath(self, title), view, ^(TBMBTestMemoryView *host, id old, id new) {
        if (old != [TBMBBindInitValue value]) {
            NSLog(@"%@", host);
        }
    }
    );
}

- (void)pushNewPage {
    [self.navigationController pushViewController:[[TBMBTestMemoryViewController alloc] initWithNibName:nil bundle:nil]
                                         animated:YES];
}


@end