//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午4:25.
//


#import <objc/message.h>
#import "TBMBDefaultFacade.h"
#import "TBMBDefaultNotification.h"
#import "TBMBUtil.h"
#import "TBMBInstanceCommand.h"
#import "TBMBStaticCommand.h"

typedef enum {
    TBMB_REG_COMMAND_INIT,
    TBMB_REG_COMMAND_ASYNC_DOING,
    TBMB_REG_COMMAND_DONE
} TBMB_REG_COMMAND_STATUE;

@implementation TBMBDefaultFacade {
@private
    NSNotificationCenter *_notificationCenter;
    dispatch_queue_t _command_queue;
    NSOperationQueue *_dispatch_message_queue;
    TBMB_REG_COMMAND_STATUE _regCommandStatus;
    NSMutableArray *_waitingNotification;
}

static NSOperationQueue *_c_dispatch_queue = nil;

+ (void)setDispatchQueue:(NSOperationQueue *)queue {
    _c_dispatch_queue = queue;
}

static dispatch_queue_t _c_queue = NULL;

+ (void)setCommandQueue:(dispatch_queue_t)queue {
    _c_queue = queue;
}

static NSNotificationCenter *_c_NotificationCenter;

+ (void)setNotificationCenter:(NSNotificationCenter *)notificationCenter {
    _c_NotificationCenter = notificationCenter;
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
        _regCommandStatus = TBMB_REG_COMMAND_INIT;
        _notificationCenter = _c_NotificationCenter ? : [[NSNotificationCenter alloc] init];
        _command_queue = _c_queue ? : dispatch_queue_create([[NSString stringWithFormat:@"TBMB_DEFAULT_COMMAND_QUEUE.%@",
                                                                                        self]
                                                                                        UTF8String], DISPATCH_QUEUE_CONCURRENT
        );
        if (_c_dispatch_queue) {
            _dispatch_message_queue = _c_dispatch_queue;
        } else {
            _dispatch_message_queue = [[NSOperationQueue alloc] init];
            [_dispatch_message_queue setName:[NSString stringWithFormat:@"TBMB_DEFAULT_DISPATCH_QUEUE.%@", self]];
        }
    }
    return self;
}


- (void)runInOneThreadWithBlock:(void (^)())block {
    block();
}


- (void)subscribeNotification:(id <TBMBMessageReceiver>)receiver {
    if (!receiver) {
        return;
    }
    void (^OBSERVER_BLOCK)(NSNotification *);
    if ([[NSOperationQueue currentQueue] isEqual:_dispatch_message_queue]) {
        OBSERVER_BLOCK = ^(NSNotification *note) {
            [receiver handlerNotification:[note.userInfo objectForKey:TBMB_NOTIFICATION_KEY]];
        };
    } else {
        NSThread *currentThread = [NSThread currentThread];
        OBSERVER_BLOCK = ^(NSNotification *note) {
            [self performSelector:@selector(runInOneThreadWithBlock:)
                         onThread:currentThread
                       withObject:^() {
                           [receiver handlerNotification:[note.userInfo objectForKey:TBMB_NOTIFICATION_KEY]];
                       }
                    waitUntilDone:NO];
        };
    }
    NSSet *notificationNames = receiver.listReceiveNotifications;
    if (notificationNames && notificationNames.count > 0) {
        for (NSString *name in notificationNames) {
            [_notificationCenter addObserverForName:name
                                             object:nil queue:_dispatch_message_queue
                                         usingBlock:OBSERVER_BLOCK];
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
        dispatch_queue_t queue = _command_queue;
        NSSet *names = objc_msgSend(commandClass, @selector(listReceiveNotifications));
        for (NSString *name in names) {
            [_notificationCenter addObserverForName:name
                                             object:nil queue:_dispatch_message_queue
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

- (void)registerCommandAuto {
    Class *classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        classes = (Class *) malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            Class clazz = classes[i];
            if (TBMBClassHasProtocol(clazz, @protocol(TBMBCommand))) {
                [self registerCommand:clazz];
            }
        }
        free(classes);
    }
}

- (void)registerCommandAutoAsync {
    static dispatch_once_t _oncePredicate_registerCommandAutoAsync;
    dispatch_once(&_oncePredicate_registerCommandAutoAsync, ^{
        _waitingNotification = [[NSMutableArray alloc] initWithCapacity:0];
        _regCommandStatus = TBMB_REG_COMMAND_ASYNC_DOING;
        dispatch_async(dispatch_queue_create("registerCommandQueue", NULL), ^{
            [self registerCommandAuto];
            _regCommandStatus = TBMB_REG_COMMAND_DONE;
            NSArray *waitingNotification;
            @synchronized (self) {
                if ([_waitingNotification count] > 0) {
                    waitingNotification = [[NSArray alloc] initWithArray:_waitingNotification];
                    [_waitingNotification removeAllObjects];
                }
                _waitingNotification = nil;
            }
            if (waitingNotification) {
                for (id <TBMBNotification> notification in waitingNotification) {
                    [self sendTBMBNotification:notification];
                }
            }
        }
        );
    }
    );
}


- (void)sendNotification:(NSString *)notificationName {
    [self sendTBMBNotification:[TBMBDefaultNotification objectWithName:notificationName]];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body {
    [self sendTBMBNotification:[TBMBDefaultNotification objectWithName:notificationName body:body]];
}

- (void)sendTBMBNotification:(id <TBMBNotification>)notification {
    if (_regCommandStatus == TBMB_REG_COMMAND_ASYNC_DOING) {
        @synchronized (self) {
            [_waitingNotification addObject:notification];
        }
        return;
    }
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