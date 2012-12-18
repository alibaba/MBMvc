//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-13 下午1:18.
//


#import <Foundation/Foundation.h>
#import "TBMBFacade.h"

@interface TBMBGlobalFacade : NSObject <TBMBFacade>
+ (BOOL)setDefaultFacade:(Class)facadeClass;

+ (TBMBGlobalFacade *)instance;
@end

//封装好的 发送Notification接口
extern inline void TBMBGlobalSendNotification(NSString *notificationName);

//封装好的 发送Notification接口
extern inline void TBMBGlobalSendNotificationWithBody(NSString *notificationName, id body);

//封装好的 发送Notification接口
extern inline void TBMBGlobalSendNotificationForSEL(SEL selector);

//封装好的 发送Notification接口
extern inline void TBMBGlobalSendNotificationForSELWithBody(SEL selector, id body);

//封装好的 发送Notification接口
extern inline void TBMBGlobalSendTBMBNotification(id <TBMBNotification> notification);