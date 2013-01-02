//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午5:33.
//

#import "TBMBNotification.h"
#import "TBMBCommand.h"

@protocol TBMBInstanceCommand <TBMBCommand>
//执行收到的消息
- (id)execute:(id <TBMBNotification>)notification;

@end