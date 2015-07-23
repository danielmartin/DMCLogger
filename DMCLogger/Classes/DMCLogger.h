// DMCLogger.h
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

#import <Foundation/Foundation.h>
#import "DMCLogFormatter.h"
#import "DMCLogFilter.h"
#import "DMCLogWriter.h"

// Convenience macros
#define DMCLoggerDebug(...)  \
[[DMCLogger standardLogger] logDebug:__VA_ARGS__]
#define DMCLoggerInfo(...)   \
[[DMCLogger standardLogger] logInfo:__VA_ARGS__]
#define DMCLoggerError(...)  \
[[DMCLogger standardLogger] logError:__VA_ARGS__]
#define DMCLoggerAssert(...) \
[[DMCLogger standardLogger] logAssert:__VA_ARGS__]

/*
 DMCLogger
 
 This is the main logger class. It depends on a logFormatter, a logFilter,
 and an array of logWriters to do its job.
 */
@interface DMCLogger : NSObject

@property (nonatomic, strong) id<DMCLogFormatter> logFormatter;
@property (nonatomic, strong) id<DMCLogFilter> logFilter;
@property (nonatomic, strong) id<DMCLogWriter> logWriter;
@property (nonatomic, assign) DMCLogLevel logLevel;

/*
 Designated initializer. Creates an instance of a custom logger with the
 provided formatter, filter, and writers. It also sets the desired log level.
 */
- (instancetype)initWithFormatter:(id <DMCLogFormatter>)formatter filter:(id <DMCLogFilter>)filter writer:(id <DMCLogWriter>)writer logLevel:(DMCLogLevel)logLevel;
+ (instancetype)standardLoggerWithLogLevel:(DMCLogLevel)logLevel;
+ (instancetype)standardLogger;
+ (void)setSharedLogger:(DMCLogger *)logger;

- (void)logInfo:(NSString *)format, ...;
- (void)logVerbose:(NSString *)format, ...;
- (void)logDebug:(NSString *)format, ...;
- (void)logAssert:(NSString *)format, ...;
- (void)logError:(NSString *)format, ...;
- (void)logFunctionInfo:(NSString *)functionName message:(NSString *)message, ...;
- (void)logFunctionVerbose:(NSString *)functionName message:(NSString *)message, ...;
- (void)logFunctionDebug:(NSString *)functionName message:(NSString *)message, ...;
- (void)logFunctionAssert:(NSString *)functionName message:(NSString *)message, ...;
- (void)logFunctionError:(NSString *)functionName message:(NSString *)message, ...;

@end
