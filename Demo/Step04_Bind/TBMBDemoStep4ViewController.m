//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午12:41.
//


#import "TBMBDemoStep4ViewController.h"
#import "TBMBDemoStep4ViewDO.h"
#import "TBMBDemoStep4View.h"
#import "TBMBBind.h"
#import "TBMBDemoStep3Command.h"
#import "TBMBSimpleInstanceCommand+TBMBProxy.h"
#import "TBMBDefaultRootViewController+TBMBProxy.h"

@interface TBMBDemoStep4ViewController ()
@property(nonatomic, strong) TBMBDemoStep4ViewDO *viewDO;
@end

@implementation TBMBDemoStep4ViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewDO = [[TBMBDemoStep4ViewDO alloc] init];
    }
    return self;
}


- (void)loadView {
    [super loadView];
    //这里将 self.viewDO 传给View 使他们都使用一个ViewDO,那么对这个ViewDO的操作都能被触发
    TBMBDemoStep4View *view = [[TBMBDemoStep4View alloc] initWithFrame:self.view.frame withViewDO:self.viewDO];
    [self.view addSubview:view];
}
//这里监听 当self.viewDO.showTime被改变时会触发这个操作
TBMBWhenThisKeyPathChange(viewDO, showTime) {
    if (!isInit && old && [new boolValue]) {
        //这还是用Step3的Command做例子
        //用proxyObject 而不是self 传递到 command的回调Block中,使Block不对self做一次retain,从而不干扰self本身的生命周期
        TBMBDemoStep4ViewController *delegate = self.proxyObject;
        //用Command的proxyObject来调用 ,是这个调用被消息化,并被异步执行
        [[TBMBDemoStep3Command proxyObject] getData:^(NSDate *date) {
            //这个delegate是个代理,他的调用receiveDate也会被消息化,如果这个时候 self被dealloc ,delegate也不会变成野指针从而导致crash
            [delegate receiveDate:date];
        }];
    }
}

- (void)receiveDate:(NSDate *)date {
    //这里改变了这个值 那么在View里面对这个alertText进行绑定的操作就会被触发
    self.viewDO.alertText = [NSString stringWithFormat:@"现在时间:%@", date];
}
@end