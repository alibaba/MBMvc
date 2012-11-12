//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午4:24.
//


@protocol TBMBFacade

- (void)subscribeNotification:(NSString *)notificationName;

- (void)subscribeNotifications:(NSArray */*NSString*/)notificationNames;
@end