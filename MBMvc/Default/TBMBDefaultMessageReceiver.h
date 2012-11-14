//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 下午12:40.
//


#import "TBMBMessageReceiver.h"

@protocol TBMBDefaultMessageReceiver <TBMBMessageReceiver>
- (void)handlerSysNotification:(NSNotification *)notification;
@end