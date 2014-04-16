/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 *///
// Created by 文通 on 14-4-15 下午9:21.
//


#import "TBMBPromisesInterceptor.h"
#import "TBMBCommandInvocation.h"
#import "TBMBUtil.h"
#import "TBMBPromisesProxy.h"


@implementation TBMBPromisesInterceptor {

}
- (id)intercept:(id <TBMBCommandInvocation>)invocation {
    id <TBMBNotification> notification = [invocation notification];
    if (TBMBIsNotificationProxy(notification)) {
        NSInvocation *methodInvocation = notification.body;
        if (methodInvocation) {
            TBMBDeferred *deferred = getDeferredFromInvocation(methodInvocation);
            if (deferred) {
                setDeferredToThread(deferred);
            }
        }

    }
    id ret = nil;
    @try {
        ret = [invocation invoke];
    }
    @finally {
        removeDeferredFromThread();
    }
    return ret;
}

+ (id)interceptor {
    return [[self alloc] init];
}


@end