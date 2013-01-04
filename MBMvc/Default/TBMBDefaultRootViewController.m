//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午3:57.
//


#import "TBMBDefaultRootViewController.h"
#import "TBMBGlobalFacade.h"
#import "TBMBDefaultNotification.h"
#import "TBMBUtil.h"


@implementation TBMBDefaultRootViewController {
@private
    id <TBMBFacade> _$tbmbFacade;
    NSMutableSet *_$tbmbObserver;
}

- (const NSUInteger)notificationKey {
    return TBMBGetDefaultNotificationKey(self);
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tbmbFacade unsubscribeNotification:self];
        [self.tbmbFacade subscribeNotification:self];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.tbmbFacade unsubscribeNotification:self];
        [self.tbmbFacade subscribeNotification:self];
    }
    return self;
}


- (id)initWithTBMBFacade:(id <TBMBFacade>)tbmbFacade {
    self = [super init];
    if (self) {
        self.tbmbFacade = tbmbFacade;
    }
    return self;
}

+ (id)objectWithTBMBFacade:(id <TBMBFacade>)tbmbFacade {
    return [[TBMBDefaultRootViewController alloc] initWithTBMBFacade:tbmbFacade];
}

- (void)dealloc {
    [self.tbmbFacade unsubscribeNotification:self];
}

#pragma mark  - receiver ,need Overwrite

//默认自动匹配方法
- (void)handlerNotification:(id <TBMBNotification>)notification {
    TBMBAutoHandlerReceiverNotification(self, notification);
}

- (NSSet *)listReceiveNotifications {
    return TBMBListAllReceiverHandlerName(self, [TBMBDefaultRootViewController class]);
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

#pragma mark  - sender
- (void)sendNotification:(NSString *)notificationName {
    [self.tbmbFacade sendTBMBNotification:[TBMBDefaultNotification objectWithName:notificationName
                                                                              key:self.notificationKey]];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body {
    [self.tbmbFacade sendTBMBNotification:[TBMBDefaultNotification objectWithName:notificationName
                                                                              key:self.notificationKey
                                                                             body:body]];
}

- (void)sendTBMBNotification:(id <TBMBNotification>)notification {
    notification.key = self.notificationKey;
    [self.tbmbFacade sendTBMBNotification:notification];
}

- (void)sendNotificationForSEL:(SEL)selector {
    [self.tbmbFacade sendTBMBNotification:[TBMBDefaultNotification objectWithName:NSStringFromSelector(selector)
                                                                              key:self.notificationKey]];
}

- (void)sendNotificationForSEL:(SEL)selector body:(id)body {
    [self.tbmbFacade sendTBMBNotification:[TBMBDefaultNotification objectWithName:NSStringFromSelector(selector)
                                                                              key:self.notificationKey body:body]];
}


@end