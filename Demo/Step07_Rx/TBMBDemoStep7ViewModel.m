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

#import "TBMBDemoStep7ViewModel.h"
#import "RACCommand.h"
#import "TBMBDemoStep7RxCommand.h"


@implementation TBMBDemoStep7ViewModel {

}

- (RACCommand *)timeCommand {
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[TBMBDemoStep7RxCommand command] createSignal:nil];
    }];
}


- (void)dealloc {
    NSLog(@"dealloc %@", self);
}

@end