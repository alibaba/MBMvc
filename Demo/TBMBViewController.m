//
//  TBMBViewController.m
//  MBMvc
//
//  Created by 黄 若慧 on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBMBViewController.h"
#import "TBMBDemoView.h"
#import "TBMBInstanceHelloCommand.h"
#import "TBMBStaticHelloCommand.h"
#import "TBMBDefaultRootViewController+TBMBProxy.h"
#import "TBMBSimpleInstanceCommand+TBMBProxy.h"
#import "TBMBSimpleStaticCommand+TBMBProxy.h"
#import "TBMBTestCommand.h"
#import "TBMBBind.h"
#import "TBMBViewDO.h"

//提供了两种方式 与View交互 一种是走delegate 但是使用proxyObject
//还有一种是通过Bind viewDO 由viewDO的值的改变来 触发操作
//两种都是基于消息 安全

@interface TBMBViewController () <TBMBDemoViewProtocol>
@property(nonatomic, strong) TBMBViewDO *viewDO;
@end

@implementation TBMBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewDO = [[TBMBViewDO alloc] init];
        //绑定self.viewDO.requestStatic改变时 执行[self requestStatic]
        TBMBBindObjectWeak(tbKeyPath(self, viewDO.requestStatic), self, ^(TBMBViewController *host, id old, id new) {
            if (old != [TBMBBindInitValue value])
                [host requestStatic];
        }
        );
    }

    return self;
}

//我这里也支持自动绑定哦
TBMBWhenThisKeyPathChange(viewDO, requestInstance){
    //由于本TBMBViewController重载了initWithNibName 所以autoBindKeyPath会在 initWithNibName之前被执行,
    //导致这里会被调用两次,需要注意
    if (!isInit && old) {
        NSLog(@"Send Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
        TBMBViewController *delegate = self.proxyObject;
        [TBMBInstanceHelloCommand.proxyObject sayHello:self.viewDO.text Age:20
                                                result:^(NSString *ret) {
                                                    [delegate sayHello:ret];
                                                }];
    }
}


- (id)init {
    self = [super init];
    if (self) {
        //用来测试高并发的
        id proxyObject = self.proxyObject;
        [[TBMBTestCommand proxyObject] justTest:^{
            NSLog(@"%@ return just Test", proxyObject);
            [proxyObject justTest];
        }];

    }
    return self;
}


- (void)justTest {
    NSLog(@"%@ just Test", self);
}

- (void)loadView {
    [super loadView];
    TBMBDemoView *view = [[TBMBDemoView alloc] initWithFrame:self.view.frame withViewDO:self.viewDO];
    //用self.proxyObject 来作为view的delegate <必须是retain的哦,因为这个是NSProxy>
    view.delegate = self.proxyObject;
    [self.view addSubview:view];
}

//执行下一个按钮
- (void)prev {
    NSLog(@"click Prev button");
    [[TBMBTestCommand proxyObject] changeViewDOText:self.viewDO];
}

//执行上一个按钮
- (void)next {
    for (NSUInteger i = 0; i < 10; i++) {
        [[[TBMBViewController alloc] init] sayNo:@"123"];
    }
}

- (void)requestStatic {
    NSLog(@"Send Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    TBMBViewController *delegate = self.proxyObject;
    [TBMBStaticHelloCommand.proxyObject sayNo:[TBMBTestDO objectWithName:self.viewDO.text]
                                       result:[^(NSString *ret) {
                                           [delegate sayNo:ret];
                                       } copy]];
    [self sendNotificationForSEL:@selector($$staticHello:name:)];
}

- (void)sayNo:(NSString *)name {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);

    self.viewDO.buttonTitle1 = name;
}

- (NSString *)sayHello:(NSString *)name {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    self.viewDO.buttonTitle2 = name;
    return @"hello";
}

//这里没有被使用
- (void)$$receiveStaticHello:(id <TBMBNotification>)notification title:(NSString *)title {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    NSLog(@"isSendByMe:%d", notification.key == self.notificationKey);
}

//这里没有被使用
- (void)$$receiveInstanceHello:(id <TBMBNotification>)notification {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    NSLog(@"isSendByMe:%d", notification.key == self.notificationKey);
}

- (void)$$receiveLog:(id <TBMBNotification>)notification {
    self.viewDO.log = [NSString stringWithFormat:@"%@ \n\r %@", notification.body, self.viewDO.log];
}

- (id)$$receiveNonLog:(id <TBMBNotification>)notification {
    return [NSNumber numberWithBool:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);

}


@end