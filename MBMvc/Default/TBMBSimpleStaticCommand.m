//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:07.
//


#import <objc/message.h>
#import "TBMBSimpleStaticCommand.h"
#import "TBMBUtil.h"
#import "TBMBMessageReceiver.h"


@implementation TBMBSimpleStaticCommand {

}
+ (void)execute:(id <TBMBNotification>)notification {
    SEL notifyHandler = NSSelectorFromString(notification.name);
    Method pMethod = class_getClassMethod(self, notifyHandler);
    TBMBAutoHandlerNotification(self, pMethod, notifyHandler, notification);
}

+ (NSSet *)listReceiveNotifications {
    return TBMBGetAllCommandHandlerName(self, TBMB_DEFAULT_RECEIVE_HANDLER_NAME);
}


@end