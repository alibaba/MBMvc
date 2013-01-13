//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-29 上午9:03.
//


#import <objc/runtime.h>
#import "TBMBBind.h"

static BOOL __is_need_auto_unbind = YES;

static BOOL __bindable_run_thread_is_binding_thread = NO;

@implementation TBMBBindInitValue
+ (TBMBBindInitValue *)value {
    static TBMBBindInitValue *_instance = nil;
    static dispatch_once_t _oncePredicate_TBMBBindInitValue;

    dispatch_once(&_oncePredicate_TBMBBindInitValue, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    );

    return _instance;
}

- (NSString *)description {
    return @"TBMBBindInitValue";
}
@end

void TBMBSetAutoUnbind(BOOL yesOrNO) {
    __is_need_auto_unbind = yesOrNO;
}

void TBMBSetBindableRunThreadIsBindingThread(BOOL yesOrNO) {
    __bindable_run_thread_is_binding_thread = yesOrNO;
}

@protocol TBMBBindHandlerProtocol <TBMBBindObserver>
- (void)removeObserver;

- (id)bindableObject;

- (NSString *)keyPath;
@end

@interface TBMBBindObjectHandler : NSObject <TBMBBindHandlerProtocol>

@property(nonatomic, assign) id bindableObject;
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, copy) TBMB_CHANGE_BLOCK changeBlock;

- (id)initWithBindableObject:(id)bindableObject
                     keyPath:(NSString *)keyPath
                 changeBlock:(TBMB_CHANGE_BLOCK)changeBlock;

+ (id)objectWithBindableObject:(id)bindableObject
                       keyPath:(NSString *)keyPath
                   changeBlock:(TBMB_CHANGE_BLOCK)changeBlock;


- (void)removeObserver;

@end

@implementation TBMBBindObjectHandler {
@private
    TBMB_CHANGE_BLOCK _changeBlock;
    NSString *_keyPath;
    __unsafe_unretained id _bindableObject;
    NSOperationQueue *_bindingQueue;
}

@synthesize changeBlock = _changeBlock;
@synthesize keyPath = _keyPath;
@synthesize bindableObject = _bindableObject;

- (id)initWithBindableObject:(id)bindableObject
                     keyPath:(NSString *)keyPath
                 changeBlock:(TBMB_CHANGE_BLOCK)changeBlock {
    self = [super init];
    if (self) {
        _bindableObject = bindableObject;
        _keyPath = keyPath;
        _changeBlock = changeBlock;
        if (__bindable_run_thread_is_binding_thread) {
            _bindingQueue = [NSOperationQueue currentQueue];
        }
    }

    return self;
}

+ (id)objectWithBindableObject:(id)bindableObject
                       keyPath:(NSString *)keyPath
                   changeBlock:(TBMB_CHANGE_BLOCK)changeBlock {
    return [[TBMBBindObjectHandler alloc]
                                   initWithBindableObject:bindableObject keyPath:keyPath changeBlock:changeBlock];
}


- (void)removeObserver {
    [(id) _bindableObject removeObserver:self forKeyPath:_keyPath];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (_changeBlock) {
        id old = [change objectForKey:NSKeyValueChangeOldKey];
        id new = [change objectForKey:NSKeyValueChangeNewKey];
        old = old ? ([old isEqual:[NSNull null]] ? nil : old) : [TBMBBindInitValue value];
        new = [new isEqual:[NSNull null]] ? nil : new;
        if (_bindingQueue && !_bindingQueue.isSuspended) {
            __block id retainedObj = _bindableObject;  //强制retain一把,防止由于bindable被dealloc导致异步执行crash
            [_bindingQueue addOperationWithBlock:^{
                _changeBlock(old, new);
                retainedObj = nil;
            }];
        } else {
            _changeBlock(old, new);
        }

    }
}


@end

static char kTBMBBindableObjectKey;

@implementation NSObject (TBMBBindableObject)


- (NSMutableSet *)_$TBMBBindableObjectSet {
    return objc_getAssociatedObject(self, &kTBMBBindableObjectKey);
}

- (void)_$AddTBMBBindableObjectSet:(id <TBMBBindHandlerProtocol>)handler {
    NSMutableSet *v = objc_getAssociatedObject(self, &kTBMBBindableObjectKey);
    if (!v) {
        v = [[NSMutableSet alloc] init];
        objc_setAssociatedObject(self, &kTBMBBindableObjectKey, v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [v addObject:handler];
}

- (void)_$TBMBBindableObject_dealloc {
    NSSet *objectSet;
    if (__is_need_auto_unbind && (objectSet = [self _$TBMBBindableObjectSet]) && objectSet.count > 0) {
        for (id <TBMBBindHandlerProtocol> handler in objectSet) {
            [handler removeObserver];
        }
    }
    objc_setAssociatedObject(self, &kTBMBBindableObjectKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // Call original implementation
    [self _$TBMBBindableObject_dealloc];
}
@end

static inline void _initBind() {
    if (!__is_need_auto_unbind) {
        return;
    }
    static dispatch_once_t _oncePredicate_TBMBBindableObject;
    dispatch_once(&_oncePredicate_TBMBBindableObject, ^{
        Class class = [NSObject class];
        Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"dealloc"));
        Method newMethod = class_getInstanceMethod(class, @selector(_$TBMBBindableObject_dealloc));
        method_exchangeImplementations(originalMethod, newMethod);
    }
    );
}

inline id <TBMBBindObserver> TBMBBindObject(id bindable, NSString *keyPath, TBMB_CHANGE_BLOCK changeBlock) {
    if (changeBlock) {
        _initBind();
        TBMBBindObjectHandler *handler = [TBMBBindObjectHandler objectWithBindableObject:bindable
                                                                                 keyPath:keyPath
                                                                             changeBlock:changeBlock];
        [bindable addObserver:handler
                   forKeyPath:keyPath
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial
                      context:nil];

        [bindable _$AddTBMBBindableObjectSet:handler];
        return handler;
    }
    return nil;
}

inline id <TBMBBindObserver> TBMBBindObjectWeak(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock) {
    if (changeBlock) {
        __block __unsafe_unretained id _host = host;
        return TBMBBindObject(bindable, keyPath, ^(id old, id new) {
            changeBlock(_host, old, new);
        }
        );
    }
    return nil;
}

inline id <TBMBBindObserver> TBMBBindObjectStrong(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock) {
    if (changeBlock) {
        return TBMBBindObject(bindable, keyPath, ^(id old, id new) {
            changeBlock(host, old, new);
        }
        );
    }
    return nil;
}

inline void TBMBUnbindObject(id bindable) {
    if (!bindable) {
        return;
    }
    NSMutableSet *objectSet;
    if ((objectSet = [bindable _$TBMBBindableObjectSet]) && objectSet.count > 0) {
        NSSet *objectSetCopy = [NSSet setWithSet:objectSet];
        for (id <TBMBBindHandlerProtocol> handler in objectSetCopy) {
            [handler removeObserver];
            [objectSet removeObject:handler];
        }
    }
}

inline void TBMBUnbindObjectWithKeyPath(id bindable, NSString *keyPath) {
    if (!bindable || !keyPath) {
        return;
    }
    NSMutableSet *objectSet;
    if ((objectSet = [bindable _$TBMBBindableObjectSet]) && objectSet.count > 0) {
        NSSet *objectSetCopy = [NSSet setWithSet:objectSet];
        for (id <TBMBBindHandlerProtocol> handler in objectSetCopy) {
            if ([handler.keyPath isEqualToString:keyPath]) {
                [handler removeObserver];
                [objectSet removeObject:handler];
            }
        }
    }
}

inline void TBMBUnbindObserver(id <TBMBBindObserver> observer) {
    if (!observer) {
        return;
    }
    if ([observer conformsToProtocol:@protocol(TBMBBindHandlerProtocol)]) {
        id <TBMBBindHandlerProtocol> _observer = (id <TBMBBindHandlerProtocol>) observer;
        id bindable = _observer.bindableObject;
        NSMutableSet *objectSet;
        if ((objectSet = [bindable _$TBMBBindableObjectSet]) && objectSet.count > 0) {
            [objectSet removeObject:_observer];
        }
        [_observer removeObserver];
    } else {
        TBMB_LOG(@"Unkown observer[%@]", observer);
    }
}

