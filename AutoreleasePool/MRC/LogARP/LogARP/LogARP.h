//
//  LogARP.h
//  LogARP
//
//  Created by 巩 鹏军 on 13-6-27.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#ifndef LogARP_LogARP_h
#define LogARP_LogARP_h

/*
 * display autorelease pool status for debug.
 *
 * Note: Private function, implemented in Objective-C runtime
 * 
 * It works on iOS 5.x at least. doesn't work on iOS 6.x.
 */

@interface NSAutoreleasePool ()

+ (void)showPools;

@end

#endif
