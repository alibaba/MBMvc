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
// Created by Wentong on 15/2/4.
//

#import "TBMBTestRxCommand.h"
#import "RACDisposable.h"
#import "RACSubscriber.h"
#import "RACScheduler.h"


@implementation TBMBTestRxCommand {

}
- (RACDisposable *)observe:(id)parameter andSubscribe:(id <RACSubscriber>)subscriber {
    NSLog(@"Command %@", [RACScheduler currentScheduler]);
    [subscriber sendNext:@1];
    return nil;
}

- (RACScheduler *)runQueue {
    return [RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh name:@"Test"];
}


@end