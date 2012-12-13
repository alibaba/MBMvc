//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午10:17.
//

#import <objc/runtime.h>
#import "TBMBNotification.h"

@class TBMBDefaultMessageReceiver;
@protocol TBMBMessageReceiver;

extern inline BOOL TBMBClassHasProtocol(Class clazz, Protocol *protocol);

extern inline NSString *TBMBProxyHandlerName(NSUInteger key, Class clazz);

extern inline NSMutableSet *TBMBGetAllReceiverHandlerName(Class currentClass, Class rootClass, NSString *prefix);

extern inline NSSet *TBMBListAllReceiverHandlerName(id <TBMBMessageReceiver> handler, Class rootClass);

extern inline NSMutableSet *TBMBGetAllCommandHandlerName(Class commandClass, NSString *prefix);

extern inline void TBMBAutoHandlerNotification(id handler, id <TBMBNotification> notification);

extern inline void TBMBAutoHandlerReceiverNotification(id <TBMBMessageReceiver> handler, id <TBMBNotification> notification);

extern inline const NSUInteger getDefaultNotificationKey(id o);
