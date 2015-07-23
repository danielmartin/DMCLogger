// DMCLogStandardFormatter.m
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Daniel Martín
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DMCLogStandardFormatter.h"
#import <pthread.h>

@implementation DMCLogStandardFormatter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        _pid = [[NSProcessInfo processInfo] processIdentifier];
        _processName = [[NSProcessInfo processInfo] processName];
    }
    
    return self;
}

- (NSString *)stringForFunction:(NSString *)function withFormat:(NSString *)format valist:(va_list)valist level:(DMCLogLevel)level
{
    NSString *formattedDate = [self.dateFormatter stringFromDate:[NSDate date]];
    NSString *formattedMessage = [super stringForFunction:function withFormat:format valist:valist level:level];
    NSString *logLevel;
    switch (level) {
        case DMCLogLevelInfo:
            logLevel = @"INFO";
            break;
        case DMCLogLevelVerbose:
            logLevel = @"VERBOSE";
            break;
        case DMCLogLevelDebug:
            logLevel = @"DEBUG";
            break;
        case DMCLogLevelAssert:
            logLevel = @"ASSERT";
            break;
        case DMCLogLevelError:
            logLevel = @"ERROR";
            break;
    }
    
    NSString *prettyNameForFunction = [self _prettyNameForFunction:function];
    return [self _prettyPrintedLogForFunction:prettyNameForFunction logLevel:logLevel date:formattedDate message:formattedMessage];
}

- (NSString *)_prettyNameForFunction:(NSString *)function
{
    if (!function) {
        return nil;
    }
    return [super prettyNameForFunction:function];
}

- (NSString *)_prettyPrintedLogForFunction:(NSString *)prettyNameForFunction
                                  logLevel:(NSString *)logLevel
                                      date:(NSString *)formattedDate
                                   message:(NSString *)formattedMessage
{
    if (prettyNameForFunction) {
        return [NSString stringWithFormat:@"%@ %@[%d:%p] [%@] : %@ %@",
                formattedDate,
                self.processName,
                self.pid,
                pthread_self(),
                logLevel,
                formattedMessage,
                prettyNameForFunction];
    } else {
        return [NSString stringWithFormat:@"%@ %@[%d:%p] [%@] : %@",
                formattedDate,
                self.processName,
                self.pid,
                pthread_self(),
                logLevel,
                formattedMessage];
    }
}

@end
