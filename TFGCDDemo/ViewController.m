//
//  ViewController.m
//  TFGCDDemo
//
//  Created by feng on 2018/8/6.
//  Copyright © 2018年 feng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 串行队列 同步执行
//    [self test1];
    // 串行队列 异步执行
    [self test2];
    // 并行队列 同步执行
//    [self test3];
    // 并行队列 异步执行
//    [self test4];
    
    
    /*
     总结:
     1.同步(dispatch_sync)  一进入任务就直接开始执行. 不开辟线程.
     2.异步(dispatch_async) 所有的任务都进入了,才开始执行,会开辟线程.
    */
}


/**
 串行队列 同步执行 (一加入就开始执行, 按照顺序执行, 不开辟线程.)
 */
- (void)test1 {
    NSLog(@"开始了");
    dispatch_queue_t serQueue = dispatch_queue_create("feng", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serQueue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"1111-%d --- %@", i, [NSThread currentThread]);
        }
    });
    dispatch_sync(serQueue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"2222-%d --- %@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"结束了");
}

/**
 串行队列 异步执行 (全部加入才开始执行, 按照顺序执行, 开辟线程.)
 */
- (void)test2 {
    NSLog(@"开始了");
    dispatch_queue_t serQueue = dispatch_queue_create("feng", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serQueue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"1111-%d --- %@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(serQueue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"2222-%d --- %@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"结束了");
}

/**
 并行队列 同步执行 (一加入就开始执行, 按照顺序执行, 不开辟线程.)
 */
- (void)test3 {
    NSLog(@"开始了");
    dispatch_queue_t serQueue = dispatch_queue_create("feng", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(serQueue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"1111-%d --- %@", i, [NSThread currentThread]);
        }
    });
    dispatch_sync(serQueue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"2222-%d --- %@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"结束了");
}

/**
 并行队列 异步执行(全部加入才开始执行, 并发执行, 开辟线程.)
 */
- (void)test4 {
    NSLog(@"开始了");
    dispatch_queue_t serQueue = dispatch_queue_create("feng", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(serQueue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"1111-%d --- %@", i, [NSThread currentThread]);
        }
        for (int i = 0; i<10; i++) {
            NSLog(@"2222-%d --- %@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(serQueue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"3333-%d --- %@", i, [NSThread currentThread]);
        }
        for (int i = 0; i<10; i++) {
            NSLog(@"4444-%d --- %@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"结束了");
}

@end
