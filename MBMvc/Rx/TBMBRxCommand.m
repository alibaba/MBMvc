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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 15-02-03 下午1:18.
//

#import "TBMBRxCommand.h"
#import "RACSignal.h"
#import "RACSubscriber.h"
#import "TBMBRxErrorUtil.h"
#import "RACDisposable.h"
#import "RACSignal+Operations.h"
#import "RACScheduler.h"
#import "RACSubject.h"

@implementation TBMBRxCommand
- (RACSignal *)createSignal:(id)parameter {
    RACSignal *racSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        return [self _internalCreateSignal:parameter
                                subscriber:subscriber];
    }];
    RACScheduler *scheduler;
    if ((scheduler = [self runScheduler])) {
        RACScheduler *currentScheduler = [RACScheduler currentScheduler];
        if (!currentScheduler) {
            currentScheduler = [RACScheduler immediateScheduler];
        }
        if (![scheduler isEqual:currentScheduler]) {
            racSignal = [racSignal subscribeOn:scheduler];
            racSignal = [racSignal deliverOn:currentScheduler];
        }
    }

    return racSignal;
}

- (void)executeSubject:(id)parameter andSubject:(RACSubject *)subject {
    RACScheduler *scheduler;
    if ((scheduler = [self runScheduler])) {
        [scheduler schedule:^{
            [self _internalCreateSignal:parameter
                             subscriber:subject];
        }];
    } else {
        [self _internalCreateSignal:parameter
                         subscriber:subject];
    }
}

- (RACDisposable *)_internalCreateSignal:(id)parameter subscriber:(id <RACSubscriber>)subscriber {
    @try {
        if ([self respondsToSelector:@selector(observe:andSubscribe:)]) {
            return [self performSelector:@selector(observe:andSubscribe:)
                              withObject:parameter
                              withObject:subscriber];
        }
    }
    @catch (NSException *exception) {
        [subscriber sendError:[TBMBRxErrorUtil convertNSException:exception]];
        return nil;
    }
    [subscriber sendCompleted];
    return nil;
}


- (RACScheduler *)runScheduler {
    RACScheduler *scheduler = nil;
    if ([self respondsToSelector:@selector(runQueue)]) {
        scheduler = [self performSelector:@selector(runQueue)];
    }
    return scheduler;
}

+ (instancetype)command {
    return [[self alloc] init];
}


@end