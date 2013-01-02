//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午3:38.
//


#import "TBMBNotification.h"
#import "TBMBCommand.h"

@protocol TBMBStaticCommand <TBMBCommand>
//静态类型的Command
+ (id)execute:(id <TBMBNotification>)notification;

@end