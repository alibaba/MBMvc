//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午10:17.
//

#import <objc/runtime.h>
#import "TBMBNotification.h"

extern BOOL TBMBClassHasProtocol(Class clazz, Protocol *protocol);

extern NSSet *TBMBGetAllUIViewControllerHandlerName(UIViewController *controller, NSString *prefix);

extern NSSet *TBMBGetAllCommandHandlerName(Class commandClass, NSString *prefix);

extern inline void TBMBAutoHandlerNotification(id handler, id <TBMBNotification> notification);