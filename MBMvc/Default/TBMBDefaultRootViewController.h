/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 */
//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-12 下午3:57.
//


#import <Foundation/Foundation.h>
#import "TBMBFacade.h"

@interface TBMBDefaultRootViewController : UIViewController <TBMBMessageReceiver, TBMBMessageSender>

@property(nonatomic, strong) id <TBMBFacade> tbmbFacade;

- (NSUInteger const)notificationKey;

//属性的初始化在这里做比较好,可以防止AutoBind被过早执行
- (void)propertyInit;

- (id)initWithTBMBFacade:(id <TBMBFacade>)tbmbFacade;

+ (id)objectWithTBMBFacade:(id <TBMBFacade>)tbmbFacade;

@end