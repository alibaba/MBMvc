//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午10:17.
//

#import <objc/runtime.h>
#import "TBMBNotification.h"

extern inline BOOL TBMBClassHasProtocol(Class clazz, Protocol *protocol);

extern inline NSString *TBMBProxyHandlerName(NSUInteger key, Class clazz);

extern inline NSMutableSet *TBMBGetAllUIViewControllerHandlerName(UIViewController *controller, NSString *prefix);

extern inline NSMutableSet *TBMBGetAllCommandHandlerName(Class commandClass, NSString *prefix);

extern inline void TBMBAutoHandlerNotification(id handler, id <TBMBNotification> notification);