//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-4-23 上午10:55.
//


#import <Foundation/Foundation.h>
#import "TBMBMessageReceiver.h"

@protocol TBMBFacade;


@interface TBMBDefaultMediator : NSObject <TBMBMessageReceiver>

@property(nonatomic, strong) id <TBMBFacade> tbmbFacade;
@property(nonatomic, assign, readonly) id realReceiver;

- (NSUInteger const)notificationKey;

- (void)close;

- (id)initWithRealReceiver:(id)realReceiver;

- (id)initWithRealReceiver:(id)realReceiver tbmbFacade:(id <TBMBFacade>)tbmbFacade;

+ (id)mediatorWithRealReceiver:(id)realReceiver tbmbFacade:(id <TBMBFacade>)tbmbFacade;

+ (id)mediatorWithRealReceiver:(id)realReceiver;

@end