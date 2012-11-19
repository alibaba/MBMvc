//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午4:25.
//


#import <Foundation/Foundation.h>
#import "TBMBFacade.h"

#define TBMB_NOTIFICATION_KEY @"TBMB_NOTIFICATION_KEY"

@interface TBMBDefaultFacade : NSObject <TBMBFacade>
+ (void)setDispatchQueue:(NSOperationQueue *)queue;

+ (void)setCommandQueue:(dispatch_queue_t)queue;

+ (void)setNotificationCenter:(NSNotificationCenter *)notificationCenter;

+ (TBMBDefaultFacade *)instance;

@end