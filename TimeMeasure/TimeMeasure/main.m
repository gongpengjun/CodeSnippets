//
//  main.m
//  TimeMeasure
//
//  Created by 巩 鹏军 on 13-6-25.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import <Foundation/Foundation.h>

void do_somthing()
{
    char* buffer = NULL;
    for(int i = 0; i < 1000000; i++)
    {
        buffer = malloc(sizeof(CGRect));
        free(buffer);
    }
    buffer = NULL;
}

void time_measure1()
{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    do_somthing();
    NSLog(@"%s,%d took time: %.3f seconds",__FUNCTION__, __LINE__, CFAbsoluteTimeGetCurrent() - startTime);
}

void time_measure2()
{
    NSDate *startDate = [NSDate date];
    do_somthing();
    //NSTimeInterval timeElapsed = [[NSDate date] timeIntervalSinceDate:startDate];
    NSLog(@"%s,%d took time: %.3f seconds",__FUNCTION__, __LINE__, [[NSDate date] timeIntervalSinceDate:startDate]);
}


// Technical Q&A QA1398 Mach Absolute Time Units
//  http://developer.apple.com/library/mac/#qa/qa1398/_index.html
#import <mach/mach_time.h>
void time_measure3()
{    
    uint64_t startTime = 0;
    uint64_t endTime = 0;
    uint64_t elapsedTime = 0;
    uint64_t elapsedTimeNano = 0;
    
    mach_timebase_info_data_t timeBaseInfo;
    mach_timebase_info(&timeBaseInfo);
    
    startTime = mach_absolute_time();
    
    //do something here
    do_somthing();
    
    endTime = mach_absolute_time();
    
    elapsedTime = endTime - startTime;
    elapsedTimeNano = elapsedTime * timeBaseInfo.numer / timeBaseInfo.denom;
    NSLog(@"%s,%d took time: %.3f secons",__FUNCTION__, __LINE__, elapsedTimeNano/1000000000.0f);
}

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        time_measure1();
        time_measure2();
        time_measure3();
    }
    return 0;
}

