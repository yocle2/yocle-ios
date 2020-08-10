/*
// UIWebView+AFNetworking.h
// Copyright (c) 2011–2015 Alamofire Software Foundation (http://alamofire.org/)
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

#import <Foundation/Foundation.h>

#import <Availability.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AFHTTPRequestSerializer, AFHTTPResponseSerializer;
@protocol AFURLRequestSerialization, AFURLResponseSerialization;


// This category adds methods to the UIKit framework's `UIWebView` class. The methods in this category provide increased control over the request cycle, including progress monitoring and success / failure handling.

// @discussion When using these category methods, make sure to assign `delegate` for the web view, which implements `–webView:shouldStartLoadWithRequest:navigationType:` appropriately. This allows for tapped links to be loaded through AFNetworking, and can ensure that `canGoBack` & `canGoForward` update their values correctly.
 
@interface UIWebView (AFNetworking)

// The request serializer used to serialize requests made with the `-loadRequest:...` category methods. By default, this is an instance of `AFHTTPRequestSerializer`.
 
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;

// The response serializer used to serialize responses made with the `-loadRequest:...` category methods. By default, this is an instance of `AFHTTPResponseSerializer`.

@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;


- (void)loadRequest:(NSURLRequest *)request
           progress:(nullable void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
            success:(nullable NSString * (^)(NSHTTPURLResponse *response, NSString *HTML))success
            failure:(nullable void (^)(NSError *error))failure;


- (void)loadRequest:(NSURLRequest *)request
           MIMEType:(nullable NSString *)MIMEType
   textEncodingName:(nullable NSString *)textEncodingName
           progress:(nullable void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
            success:(nullable NSData * (^)(NSHTTPURLResponse *response, NSData *data))success
            failure:(nullable void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

#endif
*/
