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

#import "TBMBDemoStep7View.h"
#import "TBMBDemoStep7ViewModel.h"
#import "UIButton+RACCommandSupport.h"
#import "RACCommand.h"
#import "RACSignal.h"


@implementation TBMBDemoStep7View {

}


- (void)loadView {
    [super loadView];
    RACCommand *command = self.viewDO.timeCommand;
    [[[command executionSignals] flattenMap:^RACStream *(RACSignal *signal) {
        return signal;
    }] subscribeNext:^(id x) {
        [[[UIAlertView alloc]
                       initWithTitle:@"title"
                             message:[NSString stringWithFormat:@"现在时间:%@",
                                                                x]
                            delegate:nil
                   cancelButtonTitle:@"关闭"
                   otherButtonTitles:nil] show];
    }];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 140, 200, 30)];
    button.rac_command = command;
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"Show Time"
            forState:UIControlStateNormal];
    [self addSubview:button];


}


- (void)dealloc {
    NSLog(@"dealloc %@", self);

}
@end