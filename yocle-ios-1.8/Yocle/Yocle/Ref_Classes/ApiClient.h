//
//  ApiClient.h
//  
//
//  Created by Admin on 12/8/15.
//
//

#import <Foundation/Foundation.h>

@interface ApiClient : NSObject

+ (instancetype)sharedInstance;

- (void)postRequest:(NSString *)url dataString:(NSString *)dataString success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
- (void)getDataWithPost:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;
- (void)getDataWithGet:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure;

@end
