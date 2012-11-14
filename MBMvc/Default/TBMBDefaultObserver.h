//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午5:45.
//


#import <Foundation/Foundation.h>
#import "TBMBMessageReceiver.h"


@interface TBMBDefaultObserver : NSObject

+ (TBMBDefaultObserver *)instance;

- (void)handlerSysNotification:(NSNotification *)notification;

- (void)registerCommand:(Class)commandClass;
@end