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


#import <Foundation/Foundation.h>
#import "TBMBMessageProxy.h"
#import "TBMBPromises.h"


@interface TBMBPromisesProxy : TBMBMessageProxy
@end

extern TBMBDeferred *getDeferredFromInvocation(NSInvocation *invocation);

//设置分发消息的执行队列
extern void setCommandQueue(dispatch_queue_t queue);
