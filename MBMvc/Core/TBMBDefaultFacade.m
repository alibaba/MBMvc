//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午4:25.
//


#import <objc/runtime.h>
#import <objc/message.h>
#import "TBMBDefaultFacade.h"
#import "TBMBDefaultNotification.h"
#import "TBMBDefaultObserver.h"


@implementation TBMBDefaultFacade {
@private
    NSNotificationCenter *_notificationCenter;
    NSMutableArray *_commandObservers;
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
        _commandObservers = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}


- (void)subscribeNotification:(id <TBMBMessageReceiver>)receiver {
    if (!receiver) {
        return;
    }
    NSArray *notificationNames = receiver.listReceiveNotifications;
    if (notificationNames && notificationNames.count > 0) {
        for (NSString *name in notificationNames) {
            [_notificationCenter addObserver:receiver
                                    selector:@selector(handlerNotification:)
                                        name:name
                                      object:nil];
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
    if (class_conformsToProtocol(commandClass, @protocol(TBMBCommand))) {
        NSArray *names = objc_msgSend(commandClass, @selector(listReceiveNotifications));
        TBMBDefaultObserver *observer = [TBMBDefaultObserver objectWithCommandClass:commandClass];
        [_commandObservers addObject:observer];
        for (NSString *name in names) {
            [_notificationCenter addObserver:observer
                                    selector:@selector(handlerNotification:)
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
    [_notificationCenter postNotification:sysNotification];
}


@end