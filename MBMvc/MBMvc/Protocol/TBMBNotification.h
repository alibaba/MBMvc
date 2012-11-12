//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午3:19.
//


@protocol TBMBNotification

- (id)body;

- (NSString *)name;

- (void)setBody:(id)body;

@end