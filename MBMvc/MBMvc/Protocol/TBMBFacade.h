//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午4:24.
//


#import "TBMBMessageReceiver.h"
#import "TBMBMessageSender.h"

@protocol TBMBFacade <TBMBMessageSender>

- (void)subscribeNotification:(id <TBMBMessageReceiver>)receiver;


@end