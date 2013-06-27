//
//  main.m
//  LogARP
//
//  Created by 巩 鹏军 on 13-6-27.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LogARP.h"

int main(int argc, char *argv[])
{
    NSLog(@"%s,%d",__FUNCTION__,__LINE__);
    _objc_autoreleasePoolPrint();
    @autoreleasepool {
        NSLog(@"%s,%d",__FUNCTION__,__LINE__);
        _objc_autoreleasePoolPrint();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
