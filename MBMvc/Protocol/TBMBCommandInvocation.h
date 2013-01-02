//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-2 下午10:46.
//


@protocol TBMBNotification;

@protocol TBMBCommandInvocation <NSObject>

- (Class)commandClass;

- (void)setCommandClass:(Class)commandClass;

- (id <TBMBNotification>)notification;

- (void)setNotification:(id <TBMBNotification>)notification;

//真正执行一个Command
- (id)invoke;

@end