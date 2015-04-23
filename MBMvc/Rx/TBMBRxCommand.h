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
// Created by Wentong on 15/2/3.
//

#import <Foundation/Foundation.h>

@protocol RACSubscriber;
@class RACScheduler;
@class RACSignal;
@class RACSubject;
@class RACDisposable;

//用于对应RAC的封装
@protocol TBMBRxCommandProtocol <NSObject>

//创建一个Signal
- (RACSignal *)createSignal:(id)parameter;

//用Subject执行
- (void)executeSubject:(id)parameter andSubject:(RACSubject *)subject;

@end

@protocol TBMBRxObserve <NSObject>

//真正执行的代码 (传说中的副作用)
- (RACDisposable *)observe:(id)parameter andSubscribe:(id <RACSubscriber>)subscriber;

@optional
//代码执行的线程 可以为空,为空就是用当前上下文执行
- (RACScheduler *)runQueue;
@end


@interface TBMBRxCommand : NSObject <TBMBRxCommandProtocol>

+ (instancetype)command;

@end