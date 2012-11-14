//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午3:38.
//


#import "TBMBNotification.h"
#import "TBMBCommand.h"

#define TBMB_DEFAULT_COMMAND_HANDLER_NAME @"Handler:"

@protocol TBMBStaticCommand <TBMBCommand>

+ (void)execute:(id <TBMBNotification>)notification;

@end