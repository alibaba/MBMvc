//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-29 上午9:03.
//


#import <Foundation/Foundation.h>
#import "TBMBUtil.h"
#import "metamacros.h"

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
// TBMBBindableRunSafeThreadStrategy_Retain 再异步执行前对bindable retain一把,执行完后在release,并发高时占用很多内存
// TBMBBindableRunSafeThreadStrategy_Ignore 在异步执行前判断bindable是否dealloc 已经dealloc就不执行了 ,对内存友好
extern void TBMBSetBindableRunSafeThreadStrategy(TBMBBindableRunSafeThreadStrategy strategy);

typedef void (^TBMB_CHANGE_BLOCK)(id old, id new);

typedef void (^TBMB_HOST_CHANGE_BLOCK)(id host, id old, id new);

//这个宏 可以用来在编译期就判断这个OBJ下的这个keyPath是否存在,可以避免出错
#define tbKeyPath(OBJ,PATH) OBJ , @(((void)(NO && ((void)OBJ.PATH, NO)), #PATH))
#pragma mark  - Binding
//绑定对象当bindable的这个keyPath发生改变时, changeBlock会被执行
extern inline id <TBMBBindObserver> TBMBBindObject(id bindable, NSString *keyPath, TBMB_CHANGE_BLOCK changeBlock);

//绑定对象当bindable的这个keyPath发生改变时, changeBlock会被执行 ,其中 host 是弱引用
extern inline id <TBMBBindObserver> TBMBBindObjectWeak(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock);

//绑定对象当bindable的这个keyPath发生改变时, changeBlock会被执行 ,其中 host 是强引用
extern inline id <TBMBBindObserver> TBMBBindObjectStrong(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock);

#pragma mark  - UnBinding

//解绑bindable上的所有observer
extern inline void TBMBUnbindObject(id bindable);

//解绑bindable上keyPath对应的所有observer
extern inline void TBMBUnbindObjectWithKeyPath(id bindable, NSString *keyPath);

//直接解绑一个Observer
extern inline void TBMBUnbindObserver(id <TBMBBindObserver> observer);

//直接绑定变量 ,对放对象是弱引用
#define TBMBBindPropertyWeak(bindable , keyPath , type , host , property)                                     \
        {                                                                                                     \
            __block __unsafe_unretained type ___host = (type) host;                                           \
            TBMBBindObject(tbKeyPath(bindable,keyPath), ^(id ____old, id ____new) {                           \
                                (___host).property = ____new;                                                 \
                        });                                                                                   \
        }
//直接绑定变量 ,对放对象是强引用
#define TBMBBindPropertyStrong(bindable , keyPath , host , property)                                          \
        {                                                                                                     \
            TBMBBindObject(tbKeyPath(bindable,keyPath) , ^(id ____old, id ____new) {                          \
                            (host).property = ____new;                                                        \
            });                                                                                               \
        }

#pragma mark  - Auto KeyPath Change Binding

#define  __TBMBAutoKeyPathChangeMethodNameSEP $_$
#define  __TBMBAutoKeyPathChangeMethodNameSEP_STR @metamacro_stringify(__TBMBAutoKeyPathChangeMethodNameSEP)

#define __TBMBAutoKeyPathChangeMethodName(...)      \
    metamacro_foreach_concat(,__TBMBAutoKeyPathChangeMethodNameSEP,__VA_ARGS__)


#define __TBMB_foreach_concat_iter(INDEX, BASE, ARG) .ARG

#define __TBMB_get_self_property(...)                                                                \
    self metamacro_foreach_cxt_recursive(__TBMB_foreach_concat_iter, , ,__VA_ARGS__)

//编译时判断字段是否存在
#ifdef DEBUG
#define __TBMBTryWhenThisKeyPathChange(...)                                                                            \
    metamacro_concat(-(void)__$$tryKeyPathChangeOnlyExistInDebugOn_, __TBMBAutoKeyPathChangeMethodName(__VA_ARGS__)) \
    {(void)(NO && ((void)__TBMB_get_self_property(__VA_ARGS__), NO));}
#else
#define __TBMBTryWhenThisKeyPathChange(...)
#endif


#define TBMBWhenThisKeyPathChange(...)                                                             \
     __TBMBTryWhenThisKeyPathChange(__VA_ARGS__)                                                   \
    metamacro_concat(-(void)__$$keyPathChange_, __TBMBAutoKeyPathChangeMethodName(__VA_ARGS__))    \
    :(BOOL)isInit old:(id)old new:(id)new
