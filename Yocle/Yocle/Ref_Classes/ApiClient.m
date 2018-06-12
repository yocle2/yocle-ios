//
//  ApiClient.m
//  
//
//  Created by Admin on 12/8/15.
//
//

#import "ApiClient.h"

@interface ApiClient () <NSURLConnectionDelegate>
{
    NSMutableData *receivedData_;
    id successBlock;
    id failureBlock;
}

@end

@implementation ApiClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Methods

- (AFHTTPRequestOperationManager*) getAFHTTPRequestOperationManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager.securityPolicy setAllowInvalidCertificates:YES];
    return manager;
}

#pragma mark - APIs

- (void)getDataWithPost:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    AFHTTPResponseSerializer *response = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = response;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

- (void)getDataWithGet:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    AFHTTPRequestOperationManager *manager = [self getAFHTTPRequestOperationManager];
    AFHTTPResponseSerializer *response = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = response;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error.localizedDescription);
        }
    }];
}

- (void)postRequest:(NSString *)url dataString:(NSString *)dataString success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *errorString))failure
{
    successBlock = success;
    failureBlock = failure;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
//    //set headers
//    NSString *contentType = @"text/xml";
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    [request addValue:@"any-value" forHTTPHeaderField: @"User-Agent"];
//    
//    //create the body
//    NSMutableData *postBody = [NSMutableData data];
//    [postBody appendData:[dataString dataUsingEncoding:NSASCIIStringEncoding]];
    
//    //pos
//    [request setHTTPBody:postBody];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %ld bytes of data", (long)[receivedData_ length]);
    NSString *responeString = [[NSString alloc] initWithData:receivedData_
                                                    encoding:NSASCIIStringEncoding];
    // Assume lowercase
    if ([responeString isEqualToString:@"true"]) {
        // Deal with true
        return;
    }
    // Deal with an error
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

@end
