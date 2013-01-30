/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 *///
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-30 上午9:22.
//
//用于直接嵌入代码使其成为Receiver

#define TBMBDefaultReceiverImpl                                                                            \
id <TBMBFacade> _$tbmbFacade;                                                                              \
NSMutableSet *_$tbmbObserver;                                                                              \
}                                                                                                          \
                                                                                                           \
- (id <TBMBFacade>)tbmbFacade {                                                                            \
return _$tbmbFacade ? : [TBMBGlobalFacade instance];                                                       \
}                                                                                                          \
                                                                                                           \
- (void)setTbmbFacade:(id <TBMBFacade>)tbmbFacade {                                                        \
if (self.tbmbFacade != tbmbFacade) {                                                                       \
[self.tbmbFacade unsubscribeNotification:self];                                                            \
_$tbmbFacade = tbmbFacade;                                                                                 \
[self.tbmbFacade subscribeNotification:self];                                                              \
}                                                                                                          \
}                                                                                                          \
                                                                                                           \
- (const NSUInteger)notificationKey {                                                                      \
return TBMBGetDefaultNotificationKey(self);                                                                \
}                                                                                                          \
                                                                                                           \
- (id)initWithTBMBFacade:(id <TBMBFacade>)tbmbFacade {                                                     \
self = [super init];                                                                                       \
if (self) {                                                                                                \
self.tbmbFacade = tbmbFacade;                                                                              \
}                                                                                                          \
return self;                                                                                               \
}                                                                                                          \
                                                                                                           \
                                                                                                           \
- (void)handlerNotification:(id <TBMBNotification>)notification {                                          \
TBMBAutoHandlerReceiverNotification(self, notification);                                                   \
}                                                                                                          \
                                                                                                           \
- (NSSet *)listReceiveNotifications {                                                                      \
return TBMBListAllReceiverHandlerName(self, [TBMBDefaultMessageReceiver class]);                           \
}                                                                                                          \
                                                                                                           \
- (NSSet *)_$listObserver {                                                                                \
return _$tbmbObserver;                                                                                     \
}                                                                                                          \
                                                                                                           \
- (void)_$addObserver:(id)observer {                                                                       \
_$tbmbObserver = _$tbmbObserver ? : [NSMutableSet setWithCapacity:1];                                      \
[_$tbmbObserver addObject:observer];                                                                       \
}                                                                                                          \
                                                                                                           \
- (void)_$removeObserver:(id)observer {                                                                    \
[_$tbmbObserver removeObject:observer];                                                                    \
}                                                                                                          \
                                                                                                           \
- (void)autoBindingKeyPath {                                                                               \
TBMBAutoBindingKeyPath(self);                                                                              \
}