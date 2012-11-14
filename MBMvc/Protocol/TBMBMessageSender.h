//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午3:29.
//


#import "TBMBNotification.h"

@protocol TBMBMessageSender

- (void)sendNotification:(NSString *)notificationName;

- (void)sendNotification:(NSString *)notificationName body:(id)body;

- (void)sendTBMBNotification:(id <TBMBNotification>)notification;

- (void)sendNotificationForSEL:(SEL)selector;

- (void)sendNotificationForSEL:(SEL)selector body:(id)body;

@end