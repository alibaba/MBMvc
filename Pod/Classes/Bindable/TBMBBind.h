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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-29 上午9:03.
//


#import <Foundation/Foundation.h>
#import "TBMBUtil.h"
#import "TBMB_metamacros.h"

//一个observer用来表示 可以用来remove
@protocol TBMBBindObserver <NSObject>
@end

//当绑定init的时候old的值就是这个,可以用来判断是否是初次绑定
@interface TBMBBindInitValue : NSObject
+ (TBMBBindInitValue *)value;
@end

//设定是否在绑定主体dealloc自动解绑它上面的所有observer 默认是YES
extern void TBMBSetAutoUnbind(BOOL yesOrNO);

//设定绑定执行的线程是不是绑定时的线程,默认是NO
//如果你想把ViewDO直接传到Model层请把这个设为YES,防止在非主线程修改UI
extern void TBMBSetBindableRunThreadIsBindingThread(BOOL yesOrNO);

typedef enum {
    TBMBBindableRunSafeThreadStrategy_Retain = 0,
    TBMBBindableRunSafeThreadStrategy_Ignore
} TBMBBindableRunSafeThreadStrategy;

//当TBMBSetBindableRunThreadIsBindingThread 设为YES时 ,bind触发的执行是异步的,那么可能导致弱引用的changeBlock执行时
//外部参数已经被dealloc 这个策略就是对这个情况下的处理做分离 ,默认策略是 TBMBBindableRunSafeThreadStrategy_Retain
// TBMBBindableRunSafeThreadStrategy_Retain 在异步执行前对bindable retain一把,执行完后在release,并发高时占会用很多内存,
//      因为会在异步执行阶段bindable对象不会被dealloc
// TBMBBindableRunSafeThreadStrategy_Ignore 在异步执行前判断bindable是否dealloc 已经dealloc就不执行了 ,对内存友好
extern void TBMBSetBindableRunSafeThreadStrategy(TBMBBindableRunSafeThreadStrategy strategy);

typedef void (^TBMB_CHANGE_BLOCK)(id old, id new);

typedef void (^TBMB_HOST_CHANGE_BLOCK)(id host, id old, id new);

typedef void (^TBMB_DEALLOC_BLOCK)();

//这个宏 可以用来在编译期就判断这个OBJ下的这个keyPath是否存在,可以避免出错
#define tbKeyPath(OBJ,PATH) OBJ , @(((void)(NO && ((void)OBJ.PATH, NO)), #PATH))
#pragma mark  - Binding
//绑定对象当bindable的这个keyPath发生改变时, changeBlock会被执行
extern id <TBMBBindObserver> TBMBBindObject(id bindable, NSString *keyPath, TBMB_CHANGE_BLOCK changeBlock);

//绑定对象当bindable的这个keyPath发生改变时, changeBlock会被执行 ,其中 host 是弱引用
extern id <TBMBBindObserver> TBMBBindObjectWeak(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock);

//绑定对象当bindable的这个keyPath发生改变时, changeBlock会被执行 ,其中 host 是强引用
extern id <TBMBBindObserver> TBMBBindObjectStrong(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock);

//将一个TBMBBindObserver Attach到一个obj 使observer的生命周期<=这个obj
extern void TBMBAttachBindObserver(id <TBMBBindObserver> observer, id obj);
#pragma mark  - UnBinding

//解绑bindable上的所有observer
extern void TBMBUnbindObject(id bindable);

//解绑bindable上keyPath对应的所有observer
extern void TBMBUnbindObjectWithKeyPath(id bindable, NSString *keyPath);

//直接解绑一个Observer
extern void TBMBUnbindObserver(id <TBMBBindObserver> observer);

//创建一个在bindable dealloc的时候出发的操作
extern id <TBMBBindObserver> TBMBCreateDeallocObserver(id bindable, TBMB_DEALLOC_BLOCK deallocBlock);

//取消一个DeallocObserver的执行
extern void TBMBCancelDeallocObserver(id <TBMBBindObserver> observer);
#pragma mark  - Marco for Easy Use
//设置可以自动在delegate被release的时候,置为nil的方法
#define TBMBAutoNilDelegate(hostType,host,delegateProperty,delegate)                                                  \
    {                                                                                                                 \
        (host).delegateProperty=(delegate);                                                                           \
        __block __unsafe_unretained hostType _____host = (host);                                                      \
        id <TBMBBindObserver> ___observer=TBMBCreateDeallocObserver((delegate),                                       \
                               ^(){                                                                                   \
                                   TBMB_LOG(@"NeedAutoNil host[%@] delegateProperty[%@]",                             \
                                                _____host, @#delegateProperty);                                       \
                                   _____host.delegateProperty=nil;                                                    \
                                  });                                                                                 \
        TBMBCreateDeallocObserver(host,                                                                               \
            ^() {                                                                                                     \
                TBMB_LOG(@"NeedAutoNil cancelDeallocObserver[%@]", ___observer);                                      \
                TBMBCancelDeallocObserver(___observer);                                                               \
            }                                                                                                         \
            );                                                                                                        \
    }


//直接绑定变量 ,对方对象是弱引用
#define TBMBBindPropertyWeak(bindable , keyPath , type , host , property)                                     \
    {                                                                                                         \
        TBMBBindObjectWeak(tbKeyPath(bindable,keyPath),host,^(type ____host ,id ____old,id ____new) {         \
                                    (____host).property = ____new;                                            \
                            });                                                                               \
    }

//直接绑定变量 ,对方对象是强引用
#define TBMBBindPropertyStrong(bindable , keyPath , host , property)                                          \
        {                                                                                                     \
            TBMBBindObject(tbKeyPath(bindable,keyPath) , ^(id ____old, id ____new) {                          \
                            (host).property = ____new;                                                        \
            });                                                                                               \
        }

#pragma mark  - Auto KeyPath Change Binding

#define  __TBMBAutoKeyPathChangeMethodNameSEP $_$
#define  __TBMBAutoKeyPathChangeMethodNameSEP_STR @TBMB_metamacro_stringify(__TBMBAutoKeyPathChangeMethodNameSEP)

#define __TBMBAutoKeyPathChangeMethodName(...)      \
    TBMB_metamacro_foreach_concat(,__TBMBAutoKeyPathChangeMethodNameSEP,__VA_ARGS__)


#define __TBMB_foreach_concat_iter(INDEX, BASE, ARG) .ARG

#define __TBMB_get_self_property(...)                                                                \
    self TBMB_metamacro_foreach_cxt_recursive(__TBMB_foreach_concat_iter, , ,__VA_ARGS__)

//编译时判断字段是否存在
#ifdef DEBUG
#define __TBMBTryWhenThisKeyPathChange(...)                                                                            \
    TBMB_metamacro_concat(-(void)__$$tryKeyPathChangeOnlyExistInDebugOn_, __TBMBAutoKeyPathChangeMethodName(__VA_ARGS__)) \
    {(void)(NO && ((void)__TBMB_get_self_property(__VA_ARGS__), NO));}
#else
#define __TBMBTryWhenThisKeyPathChange(...)
#endif


#define TBMBWhenThisKeyPathChange(...)                                                             \
     __TBMBTryWhenThisKeyPathChange(__VA_ARGS__)                                                   \
    TBMB_metamacro_concat(-(void)__$$keyPathChange_, __TBMBAutoKeyPathChangeMethodName(__VA_ARGS__))    \
    :(BOOL)isInit old:(id)old new:(id)new
