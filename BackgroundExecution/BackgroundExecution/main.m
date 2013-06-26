//
//  main.m
//  BackgroundExecution
//
//  Created by 巩 鹏军 on 13-6-26.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s,%d START",__FUNCTION__, __LINE__);
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    CGRect rect = CGRectMake(0, CGRectGetMidY(self.window.bounds), CGRectGetMaxX(self.window.bounds), 0);
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    label.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    label.text = [label.text stringByAppendingString:@"\n\nTo start test\nplease press HOME button to let the app enter background mode."];
    label.numberOfLines = 0;
    [label sizeToFit];
    label.center = self.window.center;
    [self.window addSubview:label];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSLog(@"%s,%d END took time: %.3f seconds",__FUNCTION__, __LINE__, CFAbsoluteTimeGetCurrent() - startTime);
    return YES;
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
    
    __block UIBackgroundTaskIdentifier bgTaskId = UIBackgroundTaskInvalid;
    bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler: ^{
        NSLog(@"%s,%d %@ callstack:%@",__FUNCTION__, __LINE__, [NSThread isMainThread]?@"MainThread":[NSThread currentThread],[NSThread callStackSymbols]);
        // This method can be safely called on a non-main thread.
        [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
        bgTaskId = UIBackgroundTaskInvalid;
    }];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTimeInterval timeLeft = [UIApplication sharedApplication].backgroundTimeRemaining;
        NSLog(@"%s,%d START background time remaining: %f seconds (%d minutes)",__FUNCTION__, __LINE__, timeLeft, (int)(timeLeft / 60));
        
        [self saveUserData];
        
        timeLeft = [UIApplication sharedApplication].backgroundTimeRemaining;
        NSLog(@"%s,%d END   background time remaining: %f seconds (%d minutes)",__FUNCTION__, __LINE__, timeLeft, (int)(timeLeft / 60));
        
        [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
        bgTaskId = UIBackgroundTaskInvalid;
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"%s,%d",__FUNCTION__, __LINE__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%s,%d",__FUNCTION__, __LINE__);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
{
    // try to clean up as much memory as possible. next step is to terminate app
    NSLog(@"%s,%d",__FUNCTION__, __LINE__);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%s,%d",__FUNCTION__, __LINE__);
}

#pragma mark - Priviate Implementation

// source : http://www.thinkbroadband.com/download.html
#define kTestFileName @"200MB"
#define kTestFileExt  @"zip"

// save user data in background thread
- (void)saveUserData
{
    NSLog(@"%s,%d START %@",__FUNCTION__, __LINE__, [NSThread isMainThread]?@"MainThread":[NSThread currentThread]);
    //NSLog(@"%s,%d callstack:%@",__FUNCTION__, __LINE__, [NSThread callStackSymbols]);
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    NSData* data = [self readLargeFile];
    [self saveLargeFile:data];
    NSLog(@"%s,%d END took time: %.3f seconds",__FUNCTION__, __LINE__, CFAbsoluteTimeGetCurrent() - startTime);
}

- (NSData*)readLargeFile
{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    NSURL* fileURL = [self sourceFileURL];
    NSLog(@"%s,%d START source file:%@",__FUNCTION__,__LINE__,[fileURL lastPathComponent]);
    NSDataReadingOptions options = NSDataReadingMappedAlways|NSDataReadingUncached;
    NSError * error = nil;
    NSData* data = [NSData dataWithContentsOfURL:fileURL options:options error:&error];
    NSLog(@"%s,%d %@",__FUNCTION__,__LINE__,error?[error description]:@"SUCCEED");
    NSLog(@"%s,%d END data:0x%X size:%lu Bytes took time: %.3f seconds",__FUNCTION__, __LINE__, (unsigned int)data,(unsigned long)[data length], CFAbsoluteTimeGetCurrent() - startTime);
    return data;
}

- (void)saveLargeFile:(NSData*)data
{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    NSURL* fileURL = [self targetFileURL];
    NSLog(@"%s,%d START target file url:%@",__FUNCTION__,__LINE__,fileURL);
    NSDataWritingOptions options = NSDataWritingAtomic;
    NSError * error = nil;
    [data writeToURL:fileURL options:options error:&error];
    NSLog(@"%s,%d %@",__FUNCTION__,__LINE__,error?[error description]:@"SUCCEED");
    NSLog(@"%s,%d END data:0x%X size:%lu Bytes took time: %.3f seconds",__FUNCTION__, __LINE__, (unsigned int)data,(unsigned long)[data length], CFAbsoluteTimeGetCurrent() - startTime);
}

- (NSURL*)sourceFileURL
{
    return [[NSBundle mainBundle] URLForResource:kTestFileName withExtension:kTestFileExt];
}

- (NSURL*)targetFileURL
{
    NSURL* fileURL = nil;
    fileURL = [self userDataRootPathURL];
    fileURL = [fileURL URLByAppendingPathComponent:kTestFileName isDirectory:NO];
    fileURL = [fileURL URLByAppendingPathExtension:kTestFileExt];
    //NSLog(@"%s,%d %@",__FUNCTION__,__LINE__,fileURL);
    return fileURL;
}

- (NSURL *)userDataRootPathURL
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dataRootPath = [documentDirectory stringByAppendingPathComponent:@"data"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:dataRootPath])
    {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:dataRootPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSURL* fileURL = [NSURL fileURLWithPath:dataRootPath isDirectory:YES];
    return fileURL;
}

@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        NSLog(@"%s,%d START",__FUNCTION__, __LINE__);
        int result = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        NSLog(@"%s,%d END",__FUNCTION__, __LINE__);
        return result;
    }
}
