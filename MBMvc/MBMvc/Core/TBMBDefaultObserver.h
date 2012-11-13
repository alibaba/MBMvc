//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午5:45.
//


#import <Foundation/Foundation.h>
#import "TBMBMessageReceiver.h"


@interface TBMBDefaultObserver : NSObject <TBMBMessageReceiver>
- (id)initWithCommandClass:(Class)commandClass;

+ (id)objectWithCommandClass:(Class)commandClass;


@end