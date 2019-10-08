//
//  main.m
//  CitronTemperature
//
//  Created by kouhei.takemoto on 2019/10/06.
//  Copyright © 2019 citrus.tk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CitrusNiccolum/CNCCursor.h>
#import <CitrusFerrum/CFString.h>
#import <CitrusFerrum/CFDate.h>

#include <sys/sysctl.h>
#import "smc.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        // CPU数
        unsigned cpu_count;
        int mib[2U] = { CTL_HW, HW_NCPU };
        size_t size_of_cpu_count = sizeof(cpu_count);
        int status = sysctl(mib, 2U, &cpu_count, &size_of_cpu_count, NULL, 0U);
        if (status != 0)
        {
            cpu_count = 1;
        }
        
        while (true)
        {
            SMCOpen();
            
            printf("--------------------------------------------------------------------------------\n");
            printf("  macOS temperature at %s\n", [[CFDate stringWithDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"] UTF8String]);
            printf("--------------------------------------------------------------------------------\n");
            
            // CPU
            for (int i = 1; i <= cpu_count; i++)
            {
                NSString *key = CFStringf(@"TC%dC", i);
                NSString *message = CFStringf(@"CPU Core %d : %.0f\n", i, SMCGetTemperature((char *)[key UTF8String]));
                printf("%s", [message UTF8String]);
            }
            SMCClose();
            
            // 描画スリープ
            sleep(2);
            
            // 戻る
            [CNCCursor moveUp:(3 + cpu_count)];
        }
    }
    return 0;
}
