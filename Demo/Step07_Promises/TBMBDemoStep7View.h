/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 *///
// Created by 文通 on 14-4-16 上午10:35.
//


#import <Foundation/Foundation.h>
#import "TBMBDefaultPage.h"


@protocol TBMBDemoStep7Delegate
- (void)showTime;

@end

@interface TBMBDemoStep7View : TBMBDefaultPage
//注意这里是strong 因为MBMvc的delegate 是一个proxyObject,并不是原来的对象,所以这里需要用strong
@property(nonatomic, strong) id <TBMBDemoStep7Delegate> delegate;

- (void)alert:(NSString *)text;
@end