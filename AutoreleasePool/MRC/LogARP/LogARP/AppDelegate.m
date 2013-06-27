//
//  AppDelegate.m
//  LogARP
//
//  Created by 巩 鹏军 on 13-6-27.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import "AppDelegate.h"
#import "LogARP.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    CGRect rect = CGRectMake(0, CGRectGetMidY(self.window.bounds), CGRectGetMaxX(self.window.bounds), 0);
    UILabel* label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    label.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    [label sizeToFit];
    label.center = self.window.center;
    [self.window addSubview:label];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    [NSAutoreleasePool showPools];
    
    [self testAutoreleasePool];
    
    [self performSelector:@selector(logAutoreleasePool) withObject:nil afterDelay:0];
        
    return YES;
}

- (void)testAutoreleasePool
{
    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    @autoreleasepool
    {
        // 下面的函数由于不属于 alloc/new/copy/mutableCopy 范畴的函数，所以都使用了 autorelease
        NSMutableArray* array = [NSMutableArray array];
        for(int i = 0; i < 10; i++)
        {
            NSString *str = [NSString stringWithFormat:@"TestCode"];
            [array addObject:str];
        }
        
        // 通过下面的函数，可以随时监控pool中的对象
        [NSAutoreleasePool showPools];
        
        @autoreleasepool
        {
            NSLog(@"%s,%d",__FUNCTION__,__LINE__);
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            for(int i = 0; i < 5; i++)
            {
                [dict setObject:@"Object" forKey:[NSString stringWithFormat:@"key%d",i]];
            }
            [NSAutoreleasePool showPools];
        }
        NSLog(@"%s,%d",__FUNCTION__,__LINE__);
        [NSAutoreleasePool showPools];
    }
    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    [NSAutoreleasePool showPools];
}

- (void)logAutoreleasePool
{
    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    [NSAutoreleasePool showPools];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
