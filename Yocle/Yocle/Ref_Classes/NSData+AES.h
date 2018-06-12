//
//  NSData+AES.h
//  Yocle
//
//  Created by CP Lau on 6/1/2017.
//  Copyright © 2017 CP Lau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface NSData (AES)
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSString *)base64Encoding;
+ (id)dataWithBase64EncodedString:(NSString *)string;
@end