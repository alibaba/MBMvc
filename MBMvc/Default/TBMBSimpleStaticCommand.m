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
    if ([self respondsToSelector:notifyHandler]) {
        objc_msgSend(self, notifyHandler, notification, notification.body, notification.key);
    }
}

+ (NSSet *)listReceiveNotifications {
    return TBMBGetAllCommandHandlerName(self, TBMB_DEFAULT_RECEIVE_HANDLER_NAME);
}


@end