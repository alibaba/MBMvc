//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午3:19.
//


@protocol TBMBNotification

- (id)body;

- (NSString *)name;

- (NSUInteger)key;

- (void)setKey:(NSUInteger)key;

- (void)setBody:(id)body;

- (NSDictionary *)userInfo;

- (void)setUserInfo:(NSDictionary *)value;

- (NSUInteger)retryCount;

- (void)setRetryCount:(NSUInteger)value;

- (id <TBMBNotification>)lastNotification;

- (void)setLastNotification:(id <TBMBNotification>)notification;

- (id <TBMBNotification>)createNextNotification:(NSString *)name;

- (id <TBMBNotification>)createNextNotification:(NSString *)name withBody:(id)body;

- (id <TBMBNotification>)createNextNotificationForSEL:(SEL)selector;

- (id <TBMBNotification>)createNextNotificationForSEL:(SEL)selector withBody:(id)body;

@end