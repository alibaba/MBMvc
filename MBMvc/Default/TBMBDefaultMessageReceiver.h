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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-12 下午2:06.
//


#import <Foundation/Foundation.h>
#import "TBMBMessageReceiver.h"

@protocol TBMBFacade;


@interface TBMBDefaultMessageReceiver : NSObject <TBMBMessageReceiver>
@property(nonatomic, strong) id <TBMBFacade> tbmbFacade;

- (NSUInteger const)notificationKey;

- (id)initWithTBMBFacade:(id <TBMBFacade>)tbmbFacade;

+ (id)objectWithTBMBFacade:(id <TBMBFacade>)tbmbFacade;
@end