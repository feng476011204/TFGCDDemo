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
//    [self test2];
    // 并行队列 同步执行
//    [self test3];
    // 并行队列 异步执行
//    [self test4];
    // 队列组
//    [self test5];
    // 队列组优化版
    [self test6];
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
        for (int i = 0; i<5; i++) {
            NSLog(@"1111-%d --- %@", i, [NSThread currentThread]);
        }
        for (int i = 0; i<5; i++) {
            NSLog(@"2222-%d --- %@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(serQueue, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"3333-%d --- %@", i, [NSThread currentThread]);
        }
        for (int i = 0; i<5; i++) {
            NSLog(@"4444-%d --- %@", i, [NSThread currentThread]);
        }
    });
    NSLog(@"结束了");
}

/**
 栅栏函数
 */
- (void)test7 {
    // 1.创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    // 2.向队列中添加任务
    dispatch_async(queue, ^{  // 1.2是并行的
        NSLog(@"任务1, %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2, %@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"任务 barrier, %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{   // 这两个是同时执行的
        NSLog(@"任务3, %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务4, %@",[NSThread currentThread]);
    });
    
    // 注意: 输出结果: 任务1 任务2 ——》 任务 barrier ——》任务3 任务4
    // 其中的任务1与任务2，任务3与任务4 由于是并行处理先后顺序不定。
}

/**
 普通队列组 (全部加入才开始执行, 并发执行, 开辟线程.)
 */
- (void)test5 {
    
    NSLog(@"开始了");
    dispatch_group_t fGroup = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(fGroup, queue, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"1111-%d --- %@", i, [NSThread currentThread]);
        }
        for (int i = 0; i<5; i++) {
            NSLog(@"2222-%d --- %@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(fGroup, queue, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"3333-%d --- %@", i, [NSThread currentThread]);
        }
        for (int i = 0; i<5; i++) {
            NSLog(@"4444-%d --- %@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(fGroup, queue, ^{
        // 所有的任务都执行完成后的回调.
        NSLog(@"都执行完啦");
    });
    NSLog(@"结束了");
}
/**
 队列组优化版 (用户解决项目中发起网络回调)
 */
- (void)test6 {
    NSLog(@"开始了");
    dispatch_group_t fGroup = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    dispatch_group_enter(fGroup);
    dispatch_group_async(fGroup, queue, ^{
        // 发起网络请求
        // 成功或者失败都掉用这个方法.
        dispatch_group_leave(fGroup);
    });
    
    dispatch_group_enter(fGroup);
    dispatch_group_async(fGroup, queue, ^{
        // 发起网络请求
        // 成功或者失败都掉用这个方法.
        dispatch_group_leave(fGroup);
    });
    
    dispatch_group_notify(fGroup, queue, ^{
        // 所有的任务都执行完成后的回调.
        NSLog(@"都执行完啦");
    });
    NSLog(@"结束了");
}

@end
