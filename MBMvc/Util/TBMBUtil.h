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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-14 上午10:17.
//
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TBMBNotification.h"


#ifdef TBMB_DEBUG
#define TBMB_LOG(msg, args...) NSLog(@"[TBMB] " msg, ##args)
#else
#define TBMB_LOG(msg, args...)
#endif


//#if !__has_feature(objc_arc)
//#define TBMBAutoRelease(__v) ([__v autorelease]);
//#define TBMBReturnAutoReleased TBMBAutoRelease
//
//#define TBMBRetain(__v) ([__v retain]);
//#define TBMBReturnRetained TBMBRetain
//
//#define TBMBRelease(__v) ([__v release]);
//#define TBMBSafeRelease(__v) ([__v release], __v = nil);
//#define TBMBSuperDealloc [super dealloc];
//
//#else
//// -fobjc-arc
//#define TBMBAutoRelease(__v)
//#define TBMBReturnAutoReleased(__v) (__v)
//
//#define TBMBRetain(__v)
//#define TBMBReturnRetained(__v) (__v)
//
//#define TBMBRelease(__v)
//#define TBMBSafeRelease(__v) (__v = nil);
//#define TBMBSuperDealloc
//
//#endif


#define TBMB_PROXY_PREFIX @"__##__ProxyHandler"

#define TBMB_KEY_PATH_CHANGE_PREFIX @"__$$keyPathChange_"

@class TBMBDefaultMessageReceiver;
@protocol TBMBMessageReceiver;

extern BOOL TBMBClassHasProtocol(Class clazz, Protocol *protocol);

extern NSString *TBMBProxyHandlerName(NSUInteger key, Class clazz);

extern NSMutableSet *TBMBGetAllReceiverHandlerName(Class currentClass, Class rootClass, NSString *prefix);

extern NSSet *TBMBInternalListAllReceiverHandlerName(id handler, id <TBMBMessageReceiver> receiver,
        Class rootClass);

extern NSSet *TBMBListAllReceiverHandlerName(id <TBMBMessageReceiver> handler, Class rootClass);

extern NSMutableSet *TBMBGetAllCommandHandlerName(Class commandClass, NSString *prefix);

extern id TBMBAutoHandlerNotification(id handler, id <TBMBNotification> notification);

extern void TBMBInternalAutoHandlerReceiverNotification(id handler, id <TBMBMessageReceiver> receiver,
        id <TBMBNotification> notification);

extern void TBMBAutoHandlerReceiverNotification(id <TBMBMessageReceiver> handler, id <TBMBNotification> notification);

extern const NSUInteger TBMBGetDefaultNotificationKey(id o);

extern BOOL TBMBIsNotificationProxy(id <TBMBNotification> notification);

extern void TBMBAutoBindingKeyPath(id bindable);
