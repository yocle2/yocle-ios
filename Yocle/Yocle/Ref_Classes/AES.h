//
//  AES.h
//  
//
//  Created by Charles Moon on 1/6/16.
//
//

#import <Foundation/Foundation.h>

@interface AES : NSObject

+ (instancetype)sharedInstance;
- (NSString *)encrypt:(NSString *)string;
- (NSString *)decrypt:(NSString *)string;

@end
