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

@implementation TBMBViewDO

- (id)init {
    self = [super init];
    if (self) {
        _buttonTitle1 = @"请求";
        _buttonTitle2 = @"请求";
        _text = @"test";
        _log = @"";
    }

    return self;
}

@end

@interface TBMBViewController ()
@property(nonatomic, strong) TBMBViewDO *viewDO;
@end

@implementation TBMBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewDO = [[TBMBViewDO alloc] init];
        TBMBBindObjectWeak(tbKeyPath(self, viewDO.clickPrev), self, ^(TBMBViewController *host, id old, id new) {
            if (old != [TBMBBindInitValue value])
                [host prev];
        }
        );

        TBMBBindObjectWeak(tbKeyPath(self, viewDO.clickNext), self, ^(TBMBViewController *host, id old, id new) {
            if (old != [TBMBBindInitValue value])
                [host next];
        }
        );

        TBMBBindObjectWeak(tbKeyPath(self, viewDO.requestInstance), self, ^(TBMBViewController *host, id old, id new) {
            if (old != [TBMBBindInitValue value])
                [host requestInstance];
        }
        );

        TBMBBindObjectWeak(tbKeyPath(self, viewDO.requestStatic), self, ^(TBMBViewController *host, id old, id new) {
            if (old != [TBMBBindInitValue value])
                [host requestStatic];
        }
        );
    }

    return self;
}


- (id)init {
    self = [super init];
    if (self) {
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
    [self.view addSubview:view];
}

- (void)prev {
}

- (void)next {
    for (NSUInteger i = 0; i < 10; i++)
        [[TBMBViewController alloc] init];
}

- (void)requestStatic {
    NSLog(@"Send Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    TBMBViewController *delegate = self.proxyObject;
    [TBMBStaticHelloCommand.proxyObject sayNo:[TBMBTestDO objectWithName:self.viewDO.text]
                                       result:[^(NSString *ret) {
                                           [delegate sayNo:ret];
                                       } copy]];
//    [self sendNotificationForSEL:@selector($$staticHello:name:) body:view.text];
}

- (void)requestInstance {
    NSLog(@"Send Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    TBMBViewController *delegate = self.proxyObject;
    [TBMBInstanceHelloCommand.proxyObject sayHello:self.viewDO.text Age:20
                                            result:^(NSString *ret) {
                                                [delegate sayHello:ret];
                                            }];
//    [self sendNotificationForSEL:@selector($$instanceHello:) body:view.text];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);

}


@end