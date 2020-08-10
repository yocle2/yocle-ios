//
//  AES.m
//  
//
//  Created by Charles Moon on 1/6/16.
//
//

#import "AES.h"

@interface AES ()
{
    NSString *cryptoJSpath;
    NSError *error;
    NSString *cryptoJS;
    JSContext *cryptoJScontext;
    JSValue *encryptFunction;
    JSValue *decryptFunction;
}

@end

@implementation AES

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        cryptoJSpath = [[NSBundle mainBundle] pathForResource:@"aes" ofType:@"js"];
        cryptoJS = [NSString stringWithContentsOfFile:cryptoJSpath encoding:NSUTF8StringEncoding error:NULL];
        cryptoJScontext = [[JSContext alloc] init];
        [cryptoJScontext evaluateScript:cryptoJS];
        encryptFunction = [cryptoJScontext objectForKeyedSubscript:@"encrypt"];
        decryptFunction = [cryptoJScontext objectForKeyedSubscript:@"decrypt"];
    }
    
    return self;
}

- (NSString *)encrypt:(NSString *)string
{
    return [[encryptFunction callWithArguments:[NSArray arrayWithObject:string]] toString];
}

- (NSString *)decrypt:(NSString *)string
{
    return [[decryptFunction callWithArguments:[NSArray arrayWithObject:string]] toString];
}

@end
