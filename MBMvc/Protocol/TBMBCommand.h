//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午5:38.
//

#define TBMB_DEFAULT_COMMAND_HANDLER_NAME @"Handler:"

@protocol TBMBCommand

+ (NSSet */*NSString*/)listReceiveNotifications;

@end