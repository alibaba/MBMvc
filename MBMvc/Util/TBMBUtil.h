//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午10:17.
//

#import <objc/runtime.h>
#import "TBMBNotification.h"


#ifdef TBMB_DEBUG
#define TBMB_LOG(msg, args...) NSLog(@"TBMB " msg, ##args)
#else
#define TBMB_LOG(msg, args...)
#endif


#if !__has_feature(objc_arc)
#define TBMBAutoRelease(__v) ([__v autorelease]);
#define TBMBReturnAutoReleased TBMBAutoRelease

#define TBMBRetain(__v) ([__v retain]);
#define TBMBReturnRetained TBMBRetain

#define TBMBRelease(__v) ([__v release]);
#define TBMBSafeRelease(__v) ([__v release], __v = nil);
#define TBMBSuperDealloc [super dealloc];

#define TBMBWeak
#else
// -fobjc-arc
#define TBMBAutoRelease(__v)
#define TBMBReturnAutoReleased(__v) (__v)

#define TBMBRetain(__v)
#define TBMBReturnRetained(__v) (__v)

#define TBMBRelease(__v)
#define TBMBSafeRelease(__v) (__v = nil);
#define TBMBSuperDealloc

#define TBMBWeak __unsafe_unretained
#endif


#define TBMB_PROXY_PREFIX @"__##__ProxyHandler"

@class TBMBDefaultMessageReceiver;
@protocol TBMBMessageReceiver;

extern inline BOOL TBMBClassHasProtocol(Class clazz, Protocol *protocol);

extern inline NSString *TBMBProxyHandlerName(NSUInteger key, Class clazz);

extern inline NSMutableSet *TBMBGetAllReceiverHandlerName(Class currentClass, Class rootClass, NSString *prefix);

extern inline NSSet *TBMBListAllReceiverHandlerName(id <TBMBMessageReceiver> handler, Class rootClass);

extern inline NSMutableSet *TBMBGetAllCommandHandlerName(Class commandClass, NSString *prefix);

extern inline id TBMBAutoHandlerNotification(id handler, id <TBMBNotification> notification);

extern inline void TBMBAutoHandlerReceiverNotification(id <TBMBMessageReceiver> handler, id <TBMBNotification> notification);

extern inline const NSUInteger TBMBGetDefaultNotificationKey(id o);

extern inline BOOL TBMBIsNotificationProxy(id <TBMBNotification> notification);
