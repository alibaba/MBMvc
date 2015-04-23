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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午1:47.
//


#import "TBMBDefaultNotification.h"
#import "TBMBUtil.h"


@implementation TBMBDefaultNotification {

@private
    NSString *_name;
    id _body;
    NSUInteger _retryCount;
    NSDictionary *_userInfo;
    id <TBMBNotification> _lastNotification;
    NSUInteger _key;
    NSTimeInterval _delay;
}
@synthesize name = _name;
@synthesize body = _body;
@synthesize retryCount = _retryCount;
@synthesize userInfo = _userInfo;
@synthesize lastNotification = _lastNotification;
@synthesize key = _key;

@synthesize delay = _delay;


- (id)init {
    self = [super init];
    if (self) {
        _delay = -1;
    }
    return self;
}


- (id)initWithName:(NSString *)name key:(NSUInteger)key {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = name;
        _key = key;
    }

    return self;
}

- (id)initWithName:(NSString *)name key:(NSUInteger)key body:(id)body {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = name;
        _key = key;
        _body = body;
    }

    return self;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = name;
    }

    return self;
}

- (id)initWithName:(NSString *)name body:(id)body {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = name;
        _body = body;
    }

    return self;
}

- (id)initWithSEL:(SEL)SEL {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = NSStringFromSelector(SEL);
    }

    return self;
}

- (id)initWithSEL:(SEL)SEL body:(id)body {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = NSStringFromSelector(SEL);
        _body = body;
    }

    return self;
}

- (id)initWithSEL:(SEL)SEL key:(NSUInteger)key body:(id)body {
    self = [super init];
    if (self) {
        _delay = -1;
        _name = NSStringFromSelector(SEL);
        _key = key;
        _body = body;
    }

    return self;
}

+ (id)objectWithSEL:(SEL)SEL key:(NSUInteger)key body:(id)body {
    return [[TBMBDefaultNotification alloc]
                                     initWithSEL:SEL
                                             key:key
                                            body:body];
}


+ (id)objectWithSEL:(SEL)SEL body:(id)body {
    return [[TBMBDefaultNotification alloc]
                                     initWithSEL:SEL
                                            body:body];
}


+ (id)objectWithSEL:(SEL)SEL {
    return [[TBMBDefaultNotification alloc] initWithSEL:SEL];
}


+ (id)objectWithName:(NSString *)name body:(id)body {
    return [[TBMBDefaultNotification alloc]
                                     initWithName:name
                                             body:body];
}


+ (id)objectWithName:(NSString *)name {
    return [[TBMBDefaultNotification alloc] initWithName:name];
}


+ (id)objectWithName:(NSString *)name key:(NSUInteger)key body:(id)body {
    return [[TBMBDefaultNotification alloc]
                                     initWithName:name
                                              key:key
                                             body:body];
}


+ (id)objectWithName:(NSString *)name key:(NSUInteger)key {
    return [[TBMBDefaultNotification alloc]
                                     initWithName:name
                                              key:key];
}

- (id <TBMBNotification>)createNextNotification:(NSString *)name {
    TBMBDefaultNotification *notification = [TBMBDefaultNotification objectWithName:name];
    notification.key = self.key;
    notification.lastNotification = self;
    notification.userInfo = self.userInfo;
    return notification;
}

- (id <TBMBNotification>)createNextNotification:(NSString *)name withBody:(id)body {
    TBMBDefaultNotification *notification = [TBMBDefaultNotification objectWithName:name
                                                                               body:body];
    notification.key = self.key;
    notification.lastNotification = self;
    notification.userInfo = self.userInfo;
    return notification;
}

- (id <TBMBNotification>)createNextNotificationForSEL:(SEL)selector {
    return [self createNextNotification:NSStringFromSelector(selector)];
}

- (id <TBMBNotification>)createNextNotificationForSEL:(SEL)selector withBody:(id)body {
    return [self createNextNotification:NSStringFromSelector(selector)
                               withBody:body];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"{Name:[%@] "
                                              "Body:[%@] "
                                              "Key:[%ld] "
                                              "retryCount:[%ld] "
                                              "userInfo:{%@} "
                                              "lastNotification:{\n\t%@\n}}"
            ,
                                      _name,
                                      _body,
                                      (unsigned long) _key,
                                      (unsigned long) _retryCount,
                                      _userInfo,
                                      _lastNotification];
}

- (void)dealloc {
    TBMB_LOG(@"dealloc [%@]", self);
}


@end