/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 */

#import "TBMBPromises.h"

#define TBMBDEFERRED_THREAD_KEY    @"__TBMBDEFERRED_THREAD_KEY__"


inline TBMBDeferred *getDeferredFromThread() {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    id v;
    if (dictionary && (v = [dictionary objectForKey:TBMBDEFERRED_THREAD_KEY])) {
        if ([v isKindOfClass:[TBMBDeferred class]]) {
            return v;
        }
    }
    return nil;
}


void setDeferredToThread(TBMBDeferred *deferred) {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    [dictionary setObject:deferred
                   forKey:TBMBDEFERRED_THREAD_KEY];
}

void removeDeferredFromThread() {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    [dictionary removeObjectForKey:TBMBDEFERRED_THREAD_KEY];
}
