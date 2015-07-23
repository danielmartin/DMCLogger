// DMCLogASLWriter.m
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

#import "DMCLogASLWriter.h"
#import "DMCLogASLClient.h"

@implementation DMCLogASLWriter

- (void)logMessage:(NSString *)message
{
    static NSString *const kASLClientKey = @"DMCLoggerASLClientKey";
    
    // Lookup the ASL client in the thread-local storage dictionary
    NSMutableDictionary *tls = [[NSThread currentThread] threadDictionary];
    DMCLogASLClient *client = [tls objectForKey:kASLClientKey];
    
    // If the ASL client wasn't found (e.g., the first call from this thread),
    // then create it and store it in the thread-local storage dictionary
    if (client == nil) {
        client = [[[DMCLogASLClient class] alloc] init];
        [tls setObject:client forKey:kASLClientKey];
    }
    
    NSRange endRange = [message rangeOfString:@"]"];
    NSString *strippedMessage = [message stringByReplacingCharactersInRange:NSMakeRange(0, endRange.location+1) withString:@""];
    
    [client log:strippedMessage level:ASL_LEVEL_NOTICE];
}

@end
