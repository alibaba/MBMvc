//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-12 下午2:06.
//


#import "TBMBDefaultMessageReceiver.h"
#import "TBMBFacade.h"
#import "TBMBGlobalFacade.h"
#import "TBMBUtil.h"
#import "TBMBOnlyProxy.h"


@implementation TBMBDefaultMessageReceiver {
@private
    id <TBMBFacade> _$tbmbFacade;
    NSMutableSet *_$tbmbObserver;
}

- (id <TBMBFacade>)tbmbFacade {
    return _$tbmbFacade ? : [TBMBGlobalFacade instance];
}

- (void)setTbmbFacade:(id <TBMBFacade>)tbmbFacade {
    if (self.tbmbFacade != tbmbFacade) {
        [self.tbmbFacade unsubscribeNotification:self];
        _$tbmbFacade = tbmbFacade;
        [self.tbmbFacade subscribeNotification:self];
    }
}

- (const NSUInteger)notificationKey {
    const void *selfPtr = (__bridge const void *) self;
    return (const NSUInteger) selfPtr;
}

- (id)initWithTBMBFacade:(id <TBMBFacade>)tbmbFacade {
    self = [super init];
    if (self) {
        self.tbmbFacade = tbmbFacade;
    }
    return self;
}

+ (id)objectWithTBMBFacade:(id <TBMBFacade>)tbmbFacade {
    return [[TBMBDefaultMessageReceiver alloc] initWithTBMBFacade:tbmbFacade];
}

#pragma mark  - receiver ,need Overwrite

//默认自动匹配方法
- (void)handlerNotification:(id <TBMBNotification>)notification {
    if ([notification.name isEqualToString:TBMBProxyHandlerName(self.notificationKey, [self class])]) {   //代理方法直接执行
        NSInvocation *invocation = notification.body;
        [invocation invokeWithTarget:self];
        return;
    }
    TBMBAutoHandlerNotification(self, notification);
}

- (NSSet *)listReceiveNotifications {
    if (TBMBClassHasProtocol([self class], @protocol(TBMBOnlyProxy))) {
        return [NSSet setWithObject:TBMBProxyHandlerName(0, [self class])];
    }
    NSMutableSet *handlerNames = TBMBGetAllReceiverHandlerName([self class], [TBMBDefaultMessageReceiver class],
            TBMB_DEFAULT_RECEIVE_HANDLER_NAME
    );
    [handlerNames addObject:TBMBProxyHandlerName(self.notificationKey, [self class])];
    return handlerNames;
}

- (NSSet *)_$listObserver {
    return _$tbmbObserver;
}

- (void)_$addObserver:(id)observer {
    _$tbmbObserver = _$tbmbObserver ? : [NSMutableSet setWithCapacity:1];
    [_$tbmbObserver addObject:observer];
}

- (void)_$removeObserver:(id)observer {
    [_$tbmbObserver removeObject:observer];
}


@end