//
//  ViewController.m
//  RunLoop
//
//  Created by liqiang on 2018/12/28.
//  Copyright © 2018 ORVIBO. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti) name:NSThreadWillExitNotification object:nil];
    
    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(testMethod1) object:nil];
    [thread start];
    [self performSelector:@selector(testMethod) onThread:thread withObject:nil waitUntilDone:NO];
    
//    [self performSelector:@selector(testSelector) withObject:nil afterDelay:0];
    
    NSLog(@"viewDidLoad");

    
    // Do any additional setup after loading the view, typically from a nib.
}




- (void)testSelector {
    NSLog(@"testSelector");

}

- (void)testMethod1 {
    
    NSLog(@"testMethod1");
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                   selector:@selector(doFireTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
    
    [self performSelector:@selector(noti) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];

    
}
- (void)doFireTimer:(NSTimer *)timer {
    CFRunLoopRef    cfLoop = [[NSRunLoop currentRunLoop] getCFRunLoop];
    CFRunLoopStop(cfLoop);
}
- (void)addRunloopObserver {
    //创建监听者
    /*
     第一个参数 CFAllocatorRef allocator：分配存储空间 CFAllocatorGetDefault()默认分配
     第二个参数 CFOptionFlags activities：要监听的状态 kCFRunLoopAllActivities 监听所有状态
     第三个参数 Boolean repeats：YES:持续监听 NO:不持续
     第四个参数 CFIndex order：优先级，一般填0即可
     第五个参数 ：回调 两个参数observer:监听者 activity:监听的事件
     */
    /*
     所有事件
     typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
     kCFRunLoopEntry = (1UL << 0),   //   即将进入RunLoop
     kCFRunLoopBeforeTimers = (1UL << 1), // 即将处理Timer
     kCFRunLoopBeforeSources = (1UL << 2), // 即将处理Source
     kCFRunLoopBeforeWaiting = (1UL << 5), //即将进入休眠
     kCFRunLoopAfterWaiting = (1UL << 6),// 刚从休眠中唤醒
     kCFRunLoopExit = (1UL << 7),// 即将退出RunLoop
     kCFRunLoopAllActivities = 0x0FFFFFFFU
     };
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop要处理Timers了");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop要处理Sources了");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop要休息了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop醒来了");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出了");
                break;
                
            default:
                break;
        }
    });
    
    // 给RunLoop添加监听者
    /*
     第一个参数 CFRunLoopRef rl：要监听哪个RunLoop,这里监听的是主线程的RunLoop
     第二个参数 CFRunLoopObserverRef observer 监听者
     第三个参数 CFStringRef mode 要监听RunLoop在哪种运行模式下的状态
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    /*
     CF的内存管理（Core Foundation）
     凡是带有Create、Copy、Retain等字眼的函数，创建出来的对象，都需要在最后做一次release
     GCD本来在iOS6.0之前也是需要我们释放的，6.0之后GCD已经纳入到了ARC中，所以我们不需要管了
     */
    CFRelease(observer);
}

- (void)testMethod {
    
    NSLog(@"testMethod");
    [self addRunloopObserver];
    
//    [self performSelector:@selector(noti) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
}

- (void)noti {
    
    NSLog(@"NSThreadWillExitNotification");
    CFRunLoopRef    cfLoop = [[NSRunLoop currentRunLoop] getCFRunLoop];
    CFRunLoopStop(cfLoop);

    
    
}

@end
