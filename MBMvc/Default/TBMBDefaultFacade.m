//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午4:25.
//


#import <objc/message.h>
#import "TBMBDefaultFacade.h"
#import "TBMBDefaultNotification.h"
#import "TBMBDefaultObserver.h"
#import "TBMBUtil.h"
#import "TBMBDefaultMessageReceiver.h"


@implementation TBMBDefaultFacade {
@private
    NSNotificationCenter *_notificationCenter;
    dispatch_queue_t _queue;
}
+ (TBMBDefaultFacade *)instance {
    static TBMBDefaultFacade *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _notificationCenter = [[NSNotificationCenter alloc] init];
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"TBMB_DEFAULT.%@", self]
                                                  UTF8String], DISPATCH_QUEUE_CONCURRENT
        );
    }
    return self;
}


- (void)subscribeNotification:(id <TBMBDefaultMessageReceiver>)receiver {
    if (!receiver) {
        return;
    }
    NSSet *notificationNames = receiver.listReceiveNotifications;
    if (notificationNames && notificationNames.count > 0) {
        for (NSString *name in notificationNames) {
            [_notificationCenter addObserver:receiver
                                    selector:@selector(handlerSysNotification:)
                                        name:name
                                      object:nil];
        }
    }
}

- (void)unsubscribeNotification:(id <TBMBDefaultMessageReceiver>)receiver {
    if (!receiver) {
        return;
    }
    [_notificationCenter removeObserver:receiver];
}

- (void)registerCommand:(Class)commandClass {
    if (TBMBClassHasProtocol(commandClass, @protocol(TBMBCommand))) {
        [[TBMBDefaultObserver instance] registerCommand:commandClass];
        NSSet *names = objc_msgSend(commandClass, @selector(listReceiveNotifications));
        for (NSString *name in names) {
            [_notificationCenter addObserver:[TBMBDefaultObserver instance]
                                    selector:@selector(handlerSysNotification:)
                                        name:name
                                      object:nil];
        }
    } else {
        NSAssert(NO, @"Unknown commandClass[%@] to register", commandClass);
    }
}


- (void)sendNotification:(NSString *)notificationName {
    [self sendTBMBNotification:[TBMBDefaultNotification objectWithName:notificationName]];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body {
    [self sendTBMBNotification:[TBMBDefaultNotification objectWithName:notificationName body:body]];
}

- (void)sendTBMBNotification:(id <TBMBNotification>)notification {
    NSNotification *sysNotification = [NSNotification notificationWithName:notification.name
                                                                    object:nil
                                                                  userInfo:[NSDictionary dictionaryWithObject:notification
                                                                                                       forKey:TBMB_NOTIFICATION_KEY]];

    dispatch_async(_queue, ^{
        [_notificationCenter postNotification:sysNotification];
    }
    );
}


@end