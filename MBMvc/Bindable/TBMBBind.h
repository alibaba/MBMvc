//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-11-29 上午9:03.
//


#import <Foundation/Foundation.h>
#import "TBMBUtil.h"

extern void TBMBSetAutoUnbind(BOOL yesOrNO);

typedef void (^TBMB_CHANGE_BLOCK)(id old, id new);

typedef void (^TBMB_HOST_CHANGE_BLOCK)(id host, id old, id new);


@interface TBMBBind : NSObject
+ (void)bindObject:(id)bindable forKeyPath:(NSString *)keyPath withChange:(TBMB_CHANGE_BLOCK)changeBlock;

+ (void)unbindObject:(id)bindable;
@end

extern inline void TBMBBindObject(id bindable, NSString *keyPath, TBMB_CHANGE_BLOCK changeBlock);

extern inline void TBMBBindObjectWeak(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock);

extern inline void TBMBBindObjectStrong(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock);

extern inline void TBMBUnbindObject(id bindable);


#define TBMBBindO(bindable , keyPath , block)                                                                 \
        {TBMB_GET_KEY_PATH_VALID(bindable , keyPath) TBMBBindObject(bindable,@#keyPath,block);}

#define TBMBBindOWeak(bindable , keyPath , host, block)                                                       \
        {TBMB_GET_KEY_PATH_VALID(bindable , keyPath) TBMBBindObjectWeak(bindable,@#keyPath,host,block);}

#define TBMBBindOStrong(bindable , keyPath ,host, block)                                                      \
        {TBMB_GET_KEY_PATH_VALID(bindable , keyPath) TBMBBindObjectStrong(bindable,@#keyPath,host,block);}

#define TBMBBindPropertyWeak(bindable , keyPath , type , host , property)                                     \
        {   TBMB_GET_KEY_PATH_VALID(bindable , keyPath)                                                       \
            __block __unsafe_unretained type ___host = (type) host;                                           \
            TBMBBindObject((bindable) , @#keyPath , ^(id ____old, id ____new) {                               \
                                (___host).property = ____new;                                                 \
                        });                                                                                   \
        }

#define TBMBBindPropertyStrong(bindable , keyPath , host , property)                                          \
        {   TBMB_GET_KEY_PATH_VALID(bindable , keyPath)                                                       \
            TBMBBindObject((bindable) , @#keyPath , ^(id ____old, id ____new) {                               \
                            (host).property = ____new;                                                        \
            });                                                                                               \
        }