//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午3:57.
//


#import <Foundation/Foundation.h>
#import "TBMBFacade.h"

@interface TBMBDefaultRootViewController : UIViewController <TBMBMessageReceiver, TBMBMessageSender>

@property(nonatomic, strong) id <TBMBFacade> tbmbFacade;

- (NSUInteger const)notificationKey;

- (id)initWithTBMBFacade:(id <TBMBFacade>)tbmbFacade;

+ (id)objectWithTBMBFacade:(id <TBMBFacade>)tbmbFacade;

- (id)proxyDelegate;

@end