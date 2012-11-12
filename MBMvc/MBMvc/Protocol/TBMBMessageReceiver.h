// 接受消息
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-9 下午6:21.
//

#import "TBMBNotification.h"

@protocol TBMBMessageReceiver
//处理通知的函数
- (void)handlerNotification:(id <TBMBNotification> *)notification;

//列出需要监听的通知名
- (NSArray */*NSString*/)listReceiveNotifications;

@end