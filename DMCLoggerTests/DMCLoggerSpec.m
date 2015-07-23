//
//  DMCLoggerSpec.m
//  DMCLoggerTests
//
//  Created by Daniel Martín on 07/21/2015.
//  Copyright (c) 2015 Daniel Martín. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "DMCLogger.h"
#import "DMCASLReader.h"

SpecBegin(DMCLogger)

describe(@"Logger", ^{
    describe(@"logger with log level info", ^{
        
        __block NSDictionary *logDict;
        
        beforeAll(^{
            [DMCLogger standardLoggerWithLogLevel:DMCLogLevelInfo];
        });
        
        it(@"should log errors", ^{
            DMCLoggerError(@"This is an error");
            logDict = [DMCASLReader readASL];
            expect(logDict[@"Message"]).to.equal(@" [ERROR] : This is an error");
        });
        it(@"should log info", ^{
            DMCLoggerInfo(@"This is an info message");
            logDict = [DMCASLReader readASL];
            expect(logDict[@"Message"]).to.equal(@" [INFO] : This is an info message");
        });
        it(@"should not log asserts", ^{
            DMCLoggerAssert(@"This is an assertion");
            logDict = [DMCASLReader readASL];
            expect(logDict[@"Message"]).to.equal(@" [INFO] : This is an info message");
        });
        
        afterAll(^{
            [DMCLogger setSharedLogger:nil];
        });
    });
    
    describe(@"logger with log level error", ^{
        
        __block NSDictionary *logDict;
        
        beforeAll(^{
            [DMCLogger standardLoggerWithLogLevel:DMCLogLevelError];
        });
        
        it(@"should log errors", ^{
            DMCLoggerError(@"This is an error");
            logDict = [DMCASLReader readASL];
            expect(logDict[@"Message"]).to.equal(@" [ERROR] : This is an error");
        });
        it(@"should not log info", ^{
            DMCLoggerInfo(@"This is an info message");
            logDict = [DMCASLReader readASL];
            expect(logDict[@"Message"]).to.equal(@" [ERROR] : This is an error");
        });
        
        afterAll(^{
            [DMCLogger setSharedLogger:nil];
        });
    });
});

SpecEnd

