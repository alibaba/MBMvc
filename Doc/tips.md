#小提示:

##### 自动注册为Notification Observer

在`TBMBDefaultRootViewController`类似的`TBMBMessageReceiver`  或 `TBMBCommand` 中
如果方法名以`$$`开头的话,这个方法会自动被注册为Notification Observer

如:


    //这里用来处理业务逻辑哦
    @interface TBMBDemoStep2Command : TBMBSimpleStaticCommand

    //以$$开头的方法 会被自动注册为Notification,然后用  TBMBGlobalSendXXX 的方法发通知,这里就能被执行
    //如果有相同的方法名的话,是都会被执行到的
    + (void)$$getDate:(id <TBMBNotification>)notification;
    @end


那么使用 `TBMBGlobalSendNotificationForSEL` 就可以直接发消息调用到这个方法

##### ProxyObject

在`TBMBDefaultRootViewController`类似的`TBMBMessageReceiver`  或 `TBMBCommand` 中 有一个
`proxyObject`属性或方法来返回一个`TBMBMessageProxy`对象,这是一个代理对象,用这个对象去调用,会使调用消息化,直接变成异步执行,(所以这里方法调用有return的话都是return nil了,因为是异步了)

如:

    - (void)showTime {
        //这是在主线程执行
        //用proxyObject 而不是self 传递到 command的回调Block中,使Block不对self做一次retain,从而不干扰self本身的生命周期
        TBMBDemoStep3ViewController *delegate = self.proxyObject;
        //用Command的proxyObject来调用 ,是这个调用被消息化,并被异步执行
        [[TBMBDemoStep3Command proxyObject] getData:^(NSDate *date) {
            //这是在worker线程被执行
            //这个delegate是个代理,他的调用receiveDate也会被消息化,如果这个时候 self被dealloc ,delegate也不会变成野指针从而导致crash
            [delegate receiveDate:date];
        }];
    }

    - (void)receiveDate:(NSDate *)date {
        //这是在主线程执行
        self.alertText = [NSString stringWithFormat:@"现在时间:%@", date];
    }



##### KVO的封装

KVO的封装的用法

MBMVC对KVO进行了一次封装,主要特点就是autoUnbind,即不需要你主动调用removeObserver,MBMvc对NSObject的dealloc做了一次AOP,在调用dealloc前会自动remove掉它上面的所有KVO的Observer
AutoBind可以通过TBMBSetAutoUnbind来进行开关

* TBMBBindObject

Demo 如下:


    TBMBBindObject(tbKeyPath(self, viewDO.alertText),  ^(id old, id new) {
        if (old != [TBMBBindInitValue value]) {
            [self alert:new];
        }
    }
    );

TBMBBindObject的效果就是绑定,当self的viewDO这个属性下面的alertText这个属性发生改变时,后面的Change Block会被执行
并且可以取得以前的值和现在是值,而如果当old值是`[TBMBBindInitValue value]`时表明,这是第一次调用,因为MBMvc是封装了KVO,
`[TBMBBindInitValue value]`的出现对应的就是`NSKeyValueObservingOptionInitial`的效果

其中TBMBBindObject调用后会返回一个TBMBBindObserver,这个TBMBBindObserver包含了Change Block
而这个TBMBBindObserver是会被挂载在TBMBBindObject调用的第一个参数的对象上面


其中`tbKeyPath`是一个宏,比如`tbKeyPath(self, alertText)` 展开后对应`self , @"alertText"`
,而使用`tbKeyPath`的目的就是为了在编译期做校验,当keypath错误时,使编译不通过

* TBMBBindObjectWeak

Demo 如下:

    TBMBBindObjectWeak(tbKeyPath(self, alertText), navView, ^(TBMBDemoStep1View *host, id old, id new) {
        if (old != [TBMBBindInitValue value]) {
            [host alert:new];
        }
    }
    );


TBMBBindObjectWeak的目的就是在TBMBBindObject的基础上使上面Demo中的navView在后面的Change Block的是弱引用的方式存在的.
为什么要有TBMBBindObjectWeak?
如上 TBMBBindObjectWeak会生成一个包含了Change Block的TBMBBindObserver,而这个TBMBBindObserver是会被上面Demo中的self强引用的
那么如果上面Demo中的navView也强引用了上面Demo中的self的话,会形成循环引用,导致内存泄露,所以这里使用的弱引用来包含navView

那么使用弱引用会不会导致野指针了,这里TBMBBindObjectWeak做了一个优化,可以看TBMBBindObjectWeak的实现


    inline id <TBMBBindObserver> TBMBBindObjectWeak(id bindable, NSString *keyPath, id host, TBMB_HOST_CHANGE_BLOCK changeBlock) {
        if (changeBlock) {
            __block __unsafe_unretained id _host = host;
            id <TBMBBindObserver> observer = TBMBBindObject(bindable, keyPath, ^(id old, id new) {
                changeBlock(_host, old, new);
            }
            );
            if (bindable != host) {       //弱引用则自动挂载 避免弱引用导致野指针 最后crash
                TBMBAttachBindObserver(observer, host);
            }
            return observer;
        }
        return nil;
    }

可以看到对于host会做一次TBMBAttachBindObserver,使TBMBBindObserver也会绑定在host上,那么当host被dealloc的时候, TBMBBindObserver会执行removeObserver,
这时Change Block会被释放,从而避免野指针的产生

* TBMBBindObjectStrong

Demo 如下:

    TBMBBindObjectWeak(tbKeyPath(self, title), view, ^(TBMBTestMemoryView *host, id old, id new) {
        if (old != [TBMBBindInitValue value]) {
            NSLog(@"%@", host);
        }
    }
    );

TBMBBindObjectStrong相对TBMBBindObjectWeak即change block对host的引用是强引用

* TBMBAttachBindObserver

这个在TBMBBindObjectWeak的实现中已经看到了,目的是把TBMBBindObserver绑定到其他对象上,从而使TBMBBindObserver的生命周期<=被绑的对象

* TBMBAutoNilDelegate

Demo 如下:

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds];
    //用TBMBAutoNilDelegate设置delegate可以保证在delegate dealloc的时候 会被自动置为nil
    TBMBAutoNilDelegate(UITableView *, tableView, delegate, self)
    TBMBAutoNilDelegate(UITableView *, tableView, dataSource, self)


对于被标为assign的delegate属性 用TBMBAutoNilDelegate来设置delegate的话在,delegate对象被dealloc的时候会自动把delegate属性设置为nil,从而避免野指针的产生
目的是可以当你在dealloc的时候少写一行代码来设置`X.delegate=nil`

* TBMBWhenThisKeyPathChange

Demo 如下:

    //这里监听 当self.viewDO.alertText被改变时会触发这个操作
    TBMBWhenThisKeyPathChange(viewDO, alertText){
        if (!isInit && new) {
            [[[UIAlertView alloc]
                           initWithTitle:@"title"
                                 message:new
                                delegate:nil cancelButtonTitle:@"关闭"
                       otherButtonTitles:nil] show];
        }
    }


TBMBWhenThisKeyPathChange是一个宏,用来生成一个可以自动绑定的方法,上如Demo会生成如下代码


    //这里监听 当self.viewDO.alertText被改变时会触发这个操作
    __$$keyPathChange_viewDO$_$alertText:(BOOL)isInit old:(id)old new:(id)new{
        if (!isInit && new) {
            [[[UIAlertView alloc]
                           initWithTitle:@"title"
                                 message:new
                                delegate:nil cancelButtonTitle:@"关闭"
                       otherButtonTitles:nil] show];
        }
    }

而这个方法在`TBMBDefaultRootViewController`或`TBMBDefaultPage`中会被自动注册为Bind
即self.viewDO.alertText被改变时会调用这个方法

如果其他地方需要使用可以调用TBMBAutoBindingKeyPath来对方法进行解析和绑定