//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 上午11:54.
//


#import "TBMBDemoStep2Command.h"
#import "TBMBGlobalFacade.h"


@implementation TBMBDemoStep2Command {

}
+ (void)$$getDate:(id <TBMBNotification>)notification {
    id <TBMBNotification> n = [notification createNextNotificationForSEL:@selector($$receiveDate:)
                                                                withBody:[NSDate date]];
    TBMBGlobalSendTBMBNotification(n);
}


@end