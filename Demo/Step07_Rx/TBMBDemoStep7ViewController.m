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

#import "TBMBDemoStep7ViewController.h"
#import "TBMBDemoStep7View.h"
#import "TBMBDemoStep7ViewModel.h"


@implementation TBMBDemoStep7ViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        _viewDO = [TBMBDemoStep7ViewModel new];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    TBMBDemoStep7View *navView = [[TBMBDemoStep7View alloc]
                                                     initWithFrame:self.view.bounds
                                                        withViewDO:self.viewDO];
    [self.view addSubview:navView];
}


- (void)dealloc {
    NSLog(@"dealloc %@", self);
}
@end