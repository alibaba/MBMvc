//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午4:25.
//


#import <objc/message.h>
#import "TBMBDefaultFacade.h"
#import "TBMBDefaultNotification.h"
#import "TBMBUtil.h"
#import "TBMBInstanceCommand.h"
#import "TBMBStaticCommand.h"


@implementation TBMBDefaultFacade {
@private
    NSNotificationCenter *_notificationCenter;
    dispatch_queue_t _queue;
}

+ (TBMBDefaultFacade *)instance {
    static TBMBDefaultFacade *_instance = nil;
    static dispatch_once_t _oncePredicate_TBMBDefaultFacade;

    dispatch_once(&_oncePredicate_TBMBDefaultFacade, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    );

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


- (void)subscribeNotification:(id <TBMBMessageReceiver>)receiver {
    if (!receiver) {
        return;
    }
    NSSet *notificationNames = receiver.listReceiveNotifications;
    if (notificationNames && notificationNames.count > 0) {
        for (NSString *name in notificationNames) {
            [_notificationCenter addObserverForName:name
                                             object:nil queue:[NSOperationQueue mainQueue]
                                         usingBlock:^(NSNotification *note) {
                                             [receiver handlerNotification:[note.userInfo objectForKey:TBMB_NOTIFICATION_KEY]];
                                         }];
        }
    }
}

- (void)unsubscribeNotification:(id <TBMBMessageReceiver>)receiver {
    if (!receiver) {
        return;
    }
    [_notificationCenter removeObserver:receiver];
}

- (void)registerCommand:(Class)commandClass {
    if (TBMBClassHasProtocol(commandClass, @protocol(TBMBCommand))) {
        dispatch_queue_t queue = _queue;
        NSSet *names = objc_msgSend(commandClass, @selector(listReceiveNotifications));
        for (NSString *name in names) {
            [_notificationCenter addObserverForName:name
                                             object:nil queue:[NSOperationQueue mainQueue]
                                         usingBlock:^(NSNotification *note) {
                                             id <TBMBNotification> notification = [note.userInfo
                                                     objectForKey:TBMB_NOTIFICATION_KEY];
                                             dispatch_async(queue, ^{
                                                 if (TBMBClassHasProtocol(commandClass, @protocol(TBMBStaticCommand))) {
                                                     objc_msgSend(commandClass, @selector(execute:), notification);
                                                 } else if (TBMBClassHasProtocol(commandClass, @protocol(TBMBInstanceCommand))) {
                                                     objc_msgSend([[commandClass alloc] init],
                                                             @selector(execute:), notification
                                                     );
                                                 } else {
                                                     NSCAssert(NO, @"Unknown commandClass[%@] to invoke", commandClass);
                                                 }
                                             }
                                             );
                                         }];
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

    [_notificationCenter postNotification:sysNotification];
}

- (void)sendNotificationForSEL:(SEL)selector {
    [self sendNotification:NSStringFromSelector(selector)];
}

- (void)sendNotificationForSEL:(SEL)selector body:(id)body {
    [self sendNotification:NSStringFromSelector(selector) body:body];
}


@end