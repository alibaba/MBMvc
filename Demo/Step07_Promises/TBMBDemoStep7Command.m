/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 *///
// Created by 文通 on 14-4-16 上午10:29.
//


#import "TBMBDemoStep7Command.h"


@implementation TBMBDemoStep7Command {

}
- (TBMBPromise *)getData {
    NSLog(@"queue:%@", dispatch_get_current_queue());
    TBMBDeferred *deferred = getDeferredFromThread();
    [deferred fulfil:[NSDate date]];
    return deferred.promise;
}

@end