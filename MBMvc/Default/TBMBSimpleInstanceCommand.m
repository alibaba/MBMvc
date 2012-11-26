//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:20.
//


#import <objc/message.h>
#import "TBMBSimpleInstanceCommand.h"
#import "TBMBUtil.h"
#import "TBMBMessageReceiver.h"


@implementation TBMBSimpleInstanceCommand {

}
- (void)execute:(id <TBMBNotification>)notification {
    SEL notifyHandler = NSSelectorFromString(notification.name);
    if ([self respondsToSelector:notifyHandler]) {
        objc_msgSend(self, notifyHandler, notification, notification.body, notification.key);
    }
}

+ (NSSet *)listReceiveNotifications {
    return TBMBGetAllCommandHandlerName(self, TBMB_DEFAULT_RECEIVE_HANDLER_NAME);
}


@end