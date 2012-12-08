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

@interface TBMBViewController ()

@end

@implementation TBMBViewController


- (void)loadView {
    [super loadView];
    TBMBDemoView *view = [[TBMBDemoView alloc] initWithFrame:self.view.frame];
    view.delegate = self.proxyDelegate;
    [self.view addSubview:view];
}

- (void)prev:(id)prev {
}

- (void)next:(id)next {
    [[TBMBViewController alloc] init];
}

- (void)requestStatic:(UIButton *)sender {
    NSLog(@"Send Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    UITextField *view = (UITextField *) [self.view viewWithTag:3];
    TBMBViewController *delegate = self.proxyDelegate;
    [[TBMBStaticHelloCommand proxy] sayNo:[TBMBTestDO objectWithName:view.text]
                                   result:[^(NSString *ret) {
                                       [delegate sayNo:ret];
                                   } copy]];
//    [self sendNotificationForSEL:@selector($$staticHello:name:) body:view.text];
}

- (void)requestInstance:(UIButton *)sender {
    NSLog(@"Send Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    UITextField *view = (UITextField *) [self.view viewWithTag:3];
    TBMBViewController *delegate = self.proxyDelegate;
    [[TBMBInstanceHelloCommand proxy] sayHello:[TBMBTestDO objectWithName:view.text]
                                        result:[^(NSString *ret) {
                                            [delegate sayHello:ret];
                                        } copy]];
//    [self sendNotificationForSEL:@selector($$instanceHello:) body:view.text];
}

- (void)sayNo:(NSString *)name {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    UIButton *view = (UIButton *) [self.view viewWithTag:1];
    [view setTitle:name forState:UIControlStateNormal];
}

- (NSString *)sayHello:(NSString *)name {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    UIButton *view = (UIButton *) [self.view viewWithTag:2];
    [view setTitle:name forState:UIControlStateNormal];
    return @"hello";
}


- (void)$$receiveStaticHello:(id <TBMBNotification>)notification title:(NSString *)title {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    NSLog(@"isSendByMe:%d", notification.key == self.notificationKey);
    UIButton *view = (UIButton *) [self.view viewWithTag:1];
    [view setTitle:title forState:UIControlStateNormal];
}

- (void)$$receiveInstanceHello:(id <TBMBNotification>)notification {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    NSLog(@"isSendByMe:%d", notification.key == self.notificationKey);
    UIButton *view = (UIButton *) [self.view viewWithTag:2];
    [view setTitle:notification.body forState:UIControlStateNormal];
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