//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-4-23 上午10:55.
//


#import "TBMBDefaultMediator.h"
#import "TBMBUtil.h"
#import "TBMBFacade.h"
#import "TBMBGlobalFacade.h"


@implementation TBMBDefaultMediator {
@private
    id <TBMBFacade> _$tbmbFacade;
    NSMutableSet *_$tbmbObserver;

    __unsafe_unretained id _realReceiver;
}

@synthesize realReceiver = _realReceiver;

- (id <TBMBFacade>)tbmbFacade {
    return _$tbmbFacade ? : [TBMBGlobalFacade instance];
}

- (void)setTbmbFacade:(id <TBMBFacade>)tbmbFacade {
    [self.tbmbFacade unsubscribeNotification:self];
    _$tbmbFacade = tbmbFacade;
    [self.tbmbFacade subscribeNotification:self];
}

- (id)initWithRealReceiver:(id)realReceiver tbmbFacade:(id <TBMBFacade>)tbmbFacade {
    self = [super init];
    if (self) {
        _realReceiver = realReceiver;
        self.tbmbFacade = tbmbFacade;
    }

    return self;
}

+ (id)mediatorWithRealReceiver:(id)realReceiver tbmbFacade:(id <TBMBFacade>)tbmbFacade {
    return [[self alloc]
                  initWithRealReceiver:realReceiver
                            tbmbFacade:tbmbFacade];
}


- (void)close {
    _realReceiver = nil;
}

- (id)initWithRealReceiver:(id)realReceiver {
    self = [super init];
    if (self) {
        _realReceiver = realReceiver;
        [self.tbmbFacade unsubscribeNotification:self];
        [self.tbmbFacade subscribeNotification:self];
    }
    return self;
}

+ (id)mediatorWithRealReceiver:(id)realReceiver {
    return [[self alloc] initWithRealReceiver:realReceiver];
}


- (NSUInteger const)notificationKey {
    if (_realReceiver) {
        return TBMBGetDefaultNotificationKey(_realReceiver);
    } else {
        return 0;
    }

}

- (void)handlerNotification:(id <TBMBNotification>)notification {
    if (_realReceiver) {
        TBMBInternalAutoHandlerReceiverNotification(_realReceiver, self, notification);
    }
}

- (NSSet *)listReceiveNotifications {
    if (_realReceiver) {
        return TBMBInternalListAllReceiverHandlerName(_realReceiver, self, [NSObject class]);
    } else {
        return [NSSet set];
    }
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

- (void)dealloc {
    [self.tbmbFacade unsubscribeNotification:self];
}

@end