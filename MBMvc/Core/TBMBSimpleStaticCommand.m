//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午9:07.
//


#import <objc/message.h>
#import "TBMBSimpleStaticCommand.h"


@implementation TBMBSimpleStaticCommand {

}
+ (void)execute:(id <TBMBNotification>)notification {
    SEL notifyHandler = NSSelectorFromString([NSString stringWithFormat:@"%@Handler",
                                                                        [notification name]]
    );
    if ([self respondsToSelector:notifyHandler]) {
        objc_msgSend(self, notifyHandler, notification);
    }
}

+ (NSArray *)listReceiveNotifications {
    return nil;
}


@end