//
//  JYCustomDataProtocol.m
//

//

#import "CustomDataProtocol.h"

static NSString * const hasInitKey = @"CustomDataProtocolKey";

@interface CustomDataProtocol ()

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation CustomDataProtocol


+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    
		NSString *url = [[request URL] absoluteString];
        url = [url stringByReplacingOccurrencesOfString:@G_serverurl withString:@""];
    
        NSRange range = [url rangeOfString:@"/" options:NSBackwardsSearch];
        NSString *fileName = [url substringFromIndex:range.location+1];
	
        range = [fileName rangeOfString:@"?"];
        if(range.length > 0) fileName = [fileName substringToIndex:range.location];
    
		NSString *pathAndFileName = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
		if ([[NSFileManager defaultManager] fileExistsAtPath:pathAndFileName])
		{
			if ([NSURLProtocol propertyForKey:hasInitKey inRequest:request]) {
                return NO;
			}
			else {
				return YES;
			}
		}
		else
		{
			return NO;
		}
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    // you can change request header here
    return mutableReqeust;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableRequest = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:hasInitKey inRequest:mutableRequest];
    
    NSString *url = [[mutableRequest URL] absoluteString];
    url = [url stringByReplacingOccurrencesOfString:@G_serverurl withString:@""];
    
    NSRange range = [url rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *fileName = [url substringFromIndex:range.location+1];
//    fileName = @"Login Button.png";
    
    range = [fileName rangeOfString:@"?"];
    if(range.length > 0) fileName = [fileName substringToIndex:range.location];

    
    NSString *mime = [self guessMIMETypeFromFileName:fileName];
    
    range = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    NSString *fileExt = [fileName substringFromIndex:range.location+1];
    fileName = [fileName substringToIndex:range.location];

    NSData *data;
    if([fileExt isEqualToString:@"js"] || [fileExt isEqualToString:@"html"] || [fileExt isEqualToString:@"css"]) {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
        NSError *error;
        NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
        
        data = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    }
    else {
        NSURL *imgPath = [[NSBundle mainBundle] URLForResource:fileName withExtension:fileExt];
        NSString *stringPath = [imgPath absoluteString];
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringPath]];
        
    }
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableRequest.URL
                                                            MIMEType:mime
                                               expectedContentLength:data.length
                                                    textEncodingName:nil];
    [self.client URLProtocol:self
              didReceiveResponse:response
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (NSString *)guessMIMETypeFromFileName: (NSString *)fileName {
    // Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[fileName pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}


@end