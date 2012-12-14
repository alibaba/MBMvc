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

#define tbKeyPath(OBJ,PATH) OBJ , @(((void)(NO && ((void)OBJ.PATH, NO)), #PATH))

extern inline void TBMBBindObject(id bindable, NSString *keyPath, TBMB_CHANGE_BLOCK changeBlock);

extern inline void TBMBBindObjectWeak(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock);

extern inline void TBMBBindObjectStrong(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock);

extern inline void TBMBUnbindObject(id bindable);

#define TBMBBindPropertyWeak(bindable , keyPath , type , host , property)                                     \
        {                                                                                                     \
            __block __unsafe_unretained type ___host = (type) host;                                           \
            TBMBBindObject(tbKeyPath(bindable,keyPath), ^(id ____old, id ____new) {                           \
                                (___host).property = ____new;                                                 \
                        });                                                                                   \
        }

#define TBMBBindPropertyStrong(bindable , keyPath , host , property)                                          \
        {                                                                                                     \
            TBMBBindObject(tbKeyPath(bindable,keyPath) , ^(id ____old, id ____new) {                          \
                            (host).property = ____new;                                                        \
            });                                                                                               \
        }