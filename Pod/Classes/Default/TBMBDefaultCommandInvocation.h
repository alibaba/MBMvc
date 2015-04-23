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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-2 下午10:52.
//


#import <Foundation/Foundation.h>
#import "TBMBCommandInvocation.h"


@interface TBMBDefaultCommandInvocation : NSObject <TBMBCommandInvocation>

@property(nonatomic) Class commandClass;
@property(nonatomic, retain) id <TBMBNotification> notification;

- (id)invoke;

- (id)initWithCommandClass:(Class)commandClass
              notification:(id <TBMBNotification>)notification
              interceptors:(NSArray *)interceptors;

+ (id)objectWithCommandClass:(Class)commandClass
                notification:(id <TBMBNotification>)notification
                interceptors:(NSArray *)interceptors;


@end