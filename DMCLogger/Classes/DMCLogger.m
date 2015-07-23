// DMCLogger.m
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

#import "DMCLogger.h"
#import "DMCLogStandardFormatter.h"
#import "DMCLogNoFilter.h"
#import "DMCLogStandardFilter.h"
#import "NSArray+FNAArrayCompositeLogger.h"
#import "DMCLogStdoutWriter.h"
#import "DMCLogASLWriter.h"

static DMCLogger *sharedLogger = nil;

@implementation DMCLogger

- (instancetype)initWithFormatter:(id <DMCLogFormatter>)formatter filter:(id <DMCLogFilter>)filter writer:(id <DMCLogWriter>)writer logLevel:(DMCLogLevel)logLevel {
    self = [super init];
    if (self) {
        [self setLogFormatter:formatter];
        [self setLogFilter:filter];
        [self setLogWriter:writer];
        [self setLogLevel:logLevel];
    }
    
    return self;
}

+ (instancetype)standardLoggerWithLogLevel:(DMCLogLevel)logLevel
{
    @synchronized(self) {
        if (sharedLogger == nil) {
            id<DMCLogFormatter> standardFormatter = [[DMCLogStandardFormatter alloc] init];
            id<DMCLogFilter> standardFilter = [[DMCLogStandardFilter alloc] init];
            NSArray *writers = @[[[DMCLogASLWriter alloc] init], [[DMCLogStdoutWriter alloc] init]];
            sharedLogger = [[self alloc] initWithFormatter:standardFormatter filter:standardFilter writer:writers logLevel:logLevel];
        }
        return sharedLogger;
    }
}

+ (instancetype)standardLogger
{
    @synchronized(self) {
        if (sharedLogger == nil) {
            id<DMCLogFormatter> standardFormatter = [[DMCLogStandardFormatter alloc] init];
            id<DMCLogFilter> standardFilter = [[DMCLogStandardFilter alloc] init];
            NSArray *writers = @[[[DMCLogASLWriter alloc] init], [[DMCLogStdoutWriter alloc] init]];
            sharedLogger = [[self alloc] initWithFormatter:standardFormatter filter:standardFilter writer:writers logLevel:DMCLogLevelInfo];
        }
        return sharedLogger;
    }
}

+ (void)setSharedLogger:(DMCLogger *)logger
{
    @synchronized(self) {
        sharedLogger = logger;
    }
}

- (void)logInfo:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self _logFunction:nil format:format valist:args level:DMCLogLevelInfo];
    va_end(args);
}

- (void)logVerbose:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self _logFunction:nil format:format valist:args level:DMCLogLevelVerbose];
    va_end(args);
}

- (void)logDebug:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self _logFunction:nil format:format valist:args level:DMCLogLevelDebug];
    va_end(args);
}

- (void)logAssert:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self _logFunction:nil format:format valist:args level:DMCLogLevelAssert];
    va_end(args);
}

- (void)logError:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self _logFunction:nil format:format valist:args level:DMCLogLevelError];
    va_end(args);
}

- (void)logFunctionInfo:(NSString *)functionName message:(NSString *)message, ...
{
    va_list args;
    va_start(args, message);
    [self _logFunction:functionName format:message valist:args level:DMCLogLevelInfo];
    va_end(args);
}

- (void)logFunctionVerbose:(NSString *)functionName message:(NSString *)message, ...
{
    va_list args;
    va_start(args, message);
    [self _logFunction:functionName format:message valist:nil level:DMCLogLevelVerbose];
    va_end(args);
}

- (void)logFunctionDebug:(NSString *)functionName message:(NSString *)message, ...
{
    va_list args;
    va_start(args, message);
    [self _logFunction:functionName format:message valist:nil level:DMCLogLevelDebug];
    va_end(args);
}

- (void)logFunctionAssert:(NSString *)functionName message:(NSString *)message, ...
{
    va_list args;
    va_start(args, message);
    [self _logFunction:functionName format:message valist:nil level:DMCLogLevelAssert];
    va_end(args);
}

- (void)logFunctionError:(NSString *)functionName message:(NSString *)message, ...
{
    va_list args;
    va_start(args, message);
    [self _logFunction:functionName format:message valist:nil level:DMCLogLevelError];
    va_end(args);
}

- (void)_logFunction:(NSString *)function format:(NSString *)format valist:(va_list)valist level:(DMCLogLevel)level
{
    NSString *functionString = [self.logFormatter stringForFunction:function withFormat:format valist:valist level:level];
    if (functionString && [self.logFilter shouldAllowMessage:functionString level:level desiredLevel:self.logLevel]) {
        [self.logWriter logMessage:functionString];
    }
}

- (void)setLogWriter:(id<DMCLogWriter>)logWriter
{
    if (logWriter) {
        _logWriter = logWriter;
    } else {
        _logWriter = [[DMCLogStdoutWriter alloc] init];
    }
}

- (void)setLogFormatter:(id<DMCLogFormatter>)logFormatter
{
    if (logFormatter) {
        _logFormatter = logFormatter;
    } else {
        _logFormatter = [[DMCLogBasicFormatter alloc] init];
    }
}

- (void)setLogFilter:(id<DMCLogFilter>)logFilter
{
    if (logFilter) {
        _logFilter = logFilter;
    } else {
        _logFilter = [[DMCLogNoFilter alloc] init];
    }
}

@end
