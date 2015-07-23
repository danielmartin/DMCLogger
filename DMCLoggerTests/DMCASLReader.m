//
//  DMCASLReader.m
//  DMCLogger
//
//  Created by Daniel Martín on 7/22/15.
//  Copyright (c) 2015 Daniel Martín. All rights reserved.
//

#import <asl.h>
#import "DMCASLReader.h"

@implementation DMCASLReader

+ (NSDictionary *)readASL
{
    aslmsg q, m;
    int i;
    const char *key, *val;
    
    q = asl_new(ASL_TYPE_QUERY);
    
    aslresponse r = asl_search(NULL, q);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    while (NULL != (m = asl_next(r)))
    {
        for (i = 0; (NULL != (key = asl_key(m, i))); i++)
        {
            NSString *keyString = [NSString stringWithUTF8String:(char *)key];
            
            val = asl_get(m, key);
            
            NSString *string = val?[NSString stringWithUTF8String:val]:@"";
            [dict setObject:string forKey:keyString];
        }
    }
    asl_free(r);
    return dict;
}

@end
