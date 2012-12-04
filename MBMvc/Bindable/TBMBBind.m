//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-29 上午9:03.
//


#import <objc/runtime.h>
#import "TBMBBind.h"

@protocol TBMBBindHandlerProtocol
- (void)removeObserver;
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
        _changeBlock([change objectForKey:NSKeyValueChangeOldKey], [change objectForKey:NSKeyValueChangeNewKey]);
    }
}


@end

inline void TBMBBindObject(id bindable, NSString *keyPath, TBMB_CHANGE_BLOCK changeBlock) {
    [TBMBBind bindObject:bindable
              forKeyPath:keyPath
              withChange:changeBlock];
}


inline void TBMBBindObjectWeak(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock) {
    if (changeBlock) {
        __block __unsafe_unretained id _host = host;
        TBMBBindObject(bindable, keyPath, ^(id old, id new) {
            changeBlock(_host, old, new);
        }
        );
    }
}

inline void TBMBBindObjectStrong(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock) {
    if (changeBlock) {
        TBMBBindObject(bindable, keyPath, ^(id old, id new) {
            changeBlock(host, old, new);
        }
        );
    }
}

inline void TBMBUnbindObject(id bindable) {
    [TBMBBind unbindObject:bindable];
}

static char kTBMBBindableObjectKey;

@implementation NSObject (TBMBBindableObject)


- (NSSet *)_$TBMBBindableObjectSet {
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
    if ((objectSet = [self _$TBMBBindableObjectSet]) && objectSet.count > 0) {
        for (id <TBMBBindHandlerProtocol> handler in objectSet) {
            [handler removeObserver];
        }
    }
    // Call original implementation
    [self _$TBMBBindableObject_dealloc];
}
@end


@implementation TBMBBind {

}

+ (void)initBind {
    static dispatch_once_t _oncePredicate_TBMBBindableObject;
    dispatch_once(&_oncePredicate_TBMBBindableObject, ^{
        Class class = [NSObject class];
        Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"dealloc"));
        Method newMethod = class_getInstanceMethod(class, @selector(_$TBMBBindableObject_dealloc));
        method_exchangeImplementations(originalMethod, newMethod);
    }
    );
}

+ (void)bindObject:(id)bindable
        forKeyPath:(NSString *)keyPath
        withChange:(TBMB_CHANGE_BLOCK)changeBlock {
    if (changeBlock) {
        [self initBind];
        TBMBBindObjectHandler *handler = [TBMBBindObjectHandler objectWithBindableObject:bindable
                                                                                 keyPath:keyPath
                                                                             changeBlock:changeBlock];
        [bindable addObserver:handler
                   forKeyPath:keyPath
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:nil];

        [bindable _$AddTBMBBindableObjectSet:handler];
    }
}

+ (void)unbindObject:(id)bindable {
    NSSet *objectSet;
    if ((objectSet = [bindable _$TBMBBindableObjectSet]) && objectSet.count > 0) {
        for (id <TBMBBindHandlerProtocol> handler in objectSet) {
            [handler removeObserver];
        }
    }
}


@end
