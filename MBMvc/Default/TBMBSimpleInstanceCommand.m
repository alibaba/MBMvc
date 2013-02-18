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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:20.
//


#import "TBMBSimpleInstanceCommand.h"
#import "TBMBUtil.h"
#import "TBMBMessageReceiver.h"
#import "TBMBOnlyProxy.h"


@implementation TBMBSimpleInstanceCommand {

}
- (id)execute:(id <TBMBNotification>)notification {
    if ([notification.name isEqualToString:TBMBProxyHandlerName(0, [self class])]) {   //代理方法直接执行
        NSInvocation *invocation = notification.body;
        [invocation invokeWithTarget:self];
        char const *returnType = invocation.methodSignature.methodReturnType;
        if (strcmp("@", returnType) == 0) {
            id ret;
            [invocation getReturnValue:&ret];
            return ret;
        }
        return nil;
    }
    return TBMBAutoHandlerNotification(self, notification);
}

+ (NSSet *)listReceiveNotifications {
    if (TBMBClassHasProtocol(self, @protocol(TBMBOnlyProxy))) {
        return [NSSet setWithObject:TBMBProxyHandlerName(0, self)];
    }
    NSMutableSet *handlerNames = TBMBGetAllCommandHandlerName(self, TBMB_DEFAULT_RECEIVE_HANDLER_NAME);
    [handlerNames addObject:TBMBProxyHandlerName(0, self)];
    return handlerNames;
}

@end