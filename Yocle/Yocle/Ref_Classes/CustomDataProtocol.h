//
//  CustomDataProtocol.h
//  
//


#import <Foundation/Foundation.h>

@interface CustomDataProtocol : NSURLProtocol

- (NSString *)guessMIMETypeFromFileName: (NSString *)fileName;

@end