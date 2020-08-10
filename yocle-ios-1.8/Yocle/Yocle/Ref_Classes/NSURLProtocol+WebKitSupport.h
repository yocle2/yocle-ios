//
//  NSURLProtocol+WebKitSupport.h
//  Yocle
//
//  Created by CP Lau on 3/1/2017.
//  Copyright © 2017 CP Lau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLProtocol (WebKitSupport)

+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;

@end