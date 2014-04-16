/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 *///
// Created by 文通 on 14-4-15 下午8:54.
//


#import <objc/runtime.h>
#import "TBMBPromisesProxy.h"

static dispatch_queue_t _command_queue = NULL;

void setCommandQueue(dispatch_queue_t queue) {
    _command_queue = queue;
}

static char kTBMB_DEFERRED_KEY;

@implementation TBMBPromisesProxy {

}

- (void)processInvocation:(NSInvocation *)invocation {
    TBMBDeferred *deferred = [OMDeferred deferred];
    deferred.defaultQueue = [self getCurrentQueue];
    TBMBPromise *promise = deferred.promise;
    [invocation setReturnValue:&promise];
    objc_setAssociatedObject(invocation, &kTBMB_DEFERRED_KEY, deferred, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (dispatch_queue_t)getCurrentQueue {    //TODO 这里要优化一下 能不能获取到 当前queue
    if ([NSThread isMainThread]) {
        return dispatch_get_main_queue();
    } else if (_command_queue) {
        return _command_queue;
    } else {
        return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
}
@end


TBMBDeferred *getDeferredFromInvocation(NSInvocation *invocation) {
    if (invocation) {
        return objc_getAssociatedObject(invocation, &kTBMB_DEFERRED_KEY);
    }
    return nil;
}
