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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午1:18.
//


#import "TBMBGlobalFacade.h"
#import "TBMBDefaultFacade.h"
#import "TBMBUtil.h"


@implementation TBMBGlobalFacade {
@private
    id <TBMBFacade> _facade;
}

static Class _facadeClass = nil;

+ (BOOL)setDefaultFacade:(Class)facadeClass {
    if (TBMBClassHasProtocol(facadeClass, @protocol(TBMBFacade))) {
        _facadeClass = facadeClass;
        return YES;
    }
    else {
        return NO;
    }
}

+ (TBMBGlobalFacade *)instance {
    static TBMBGlobalFacade *_instance = nil;
    static dispatch_once_t _oncePredicate_TBMBGlobalFacade;

    dispatch_once(&_oncePredicate_TBMBGlobalFacade, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    );

    return _instance;
}

- (void)setInterceptors:(NSArray *)interceptors {
    [_facade setInterceptors:interceptors];
}

- (id)init {
    self = [super init];
    if (self) {
        if (_facadeClass) {
            _facade = [_facadeClass instance];
        } else {
            _facade = [TBMBDefaultFacade instance];
        }
    }
    return self;
}


- (void)subscribeNotification:(id <TBMBMessageReceiver>)receiver {
    [_facade subscribeNotification:receiver];
}

- (void)unsubscribeNotification:(id <TBMBMessageReceiver>)receiver {
    [_facade unsubscribeNotification:receiver];
}

- (void)registerCommand:(Class)commandClass {
    [_facade registerCommand:commandClass];
}

- (void)registerCommandAuto {
    [_facade registerCommandAuto];
}

- (void)registerCommandAutoAsync {
    [_facade registerCommandAutoAsync];
}

- (void)sendNotification:(NSString *)notificationName {
    [_facade sendNotification:notificationName];
}

- (void)sendNotification:(NSString *)notificationName
                    body:(id)body {
    [_facade sendNotification:notificationName body:body];
}

- (void)sendTBMBNotification:(id <TBMBNotification>)notification {
    [_facade sendTBMBNotification:notification];
}

- (void)sendNotificationForSEL:(SEL)selector {
    [_facade sendNotificationForSEL:selector];
}

- (void)sendNotificationForSEL:(SEL)selector body:(id)body {
    [_facade sendNotificationForSEL:selector body:body];
}


@end

inline void TBMBGlobalSendNotification(NSString *notificationName) {
    [[TBMBGlobalFacade instance] sendNotification:notificationName];
}

inline void TBMBGlobalSendNotificationWithBody(NSString *notificationName, id body) {
    [[TBMBGlobalFacade instance] sendNotification:notificationName body:body];
}

inline void TBMBGlobalSendNotificationForSEL(SEL selector) {
    [[TBMBGlobalFacade instance] sendNotificationForSEL:selector];
}

inline void TBMBGlobalSendNotificationForSELWithBody(SEL selector, id body) {
    [[TBMBGlobalFacade instance] sendNotificationForSEL:selector body:body];
}

inline void TBMBGlobalSendTBMBNotification(id <TBMBNotification> notification) {
    [[TBMBGlobalFacade instance] sendTBMBNotification:notification];
}