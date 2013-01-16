//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 上午11:50.
//


#import "TBMBDemoStep2ViewController.h"
#import "TBMBDemoStep2View.h"
#import "TBMBBind.h"
#import "TBMBDefaultRootViewController+TBMBProxy.h"

@interface TBMBDemoStep2ViewController () <TBMBDemoStep2Delegate>
@property(nonatomic, copy) NSString *alertText;
@end

@implementation TBMBDemoStep2ViewController {

}

- (void)loadView {
    [super loadView];
    TBMBDemoStep2View *navView = [[TBMBDemoStep2View alloc] initWithFrame:self.view.frame withViewDO:nil];
    navView.delegate = self.proxyObject;
    [self.view addSubview:navView];
    //这里做一次绑定 当alertText改变时 调用的逻辑
    TBMBBindObjectWeak(tbKeyPath(self, alertText), navView, ^(TBMBDemoStep2View *host, id old, id new) {
        if (old != [TBMBBindInitValue value]) {
            [host alert:new];
        }
    }
    );
}

- (void)showTime {
    //这里发消息出去 到 业务层去 请求数据
    [self sendNotificationForSEL:@selector($$getDate:)];
}

- (void)$$receiveDate:(id <TBMBNotification>)notification {
    //业务层返回数据给 ViewController
    if (notification.key == self.notificationKey) {
        self.alertText = [NSString stringWithFormat:@"现在时间:%@", notification.body];
    }
}


@end