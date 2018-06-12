
#import "LatestNewsViewController.h"

@interface LatestNewsViewController () <UIWebViewDelegate, UIAlertViewDelegate, NSURLConnectionDelegate>
{
    NSString *currentUrl;
    NSTimer *refreshTimer;
    BOOL _authenticated;
    NSURLConnection *_urlConnection;
    NSURLRequest *_request;
}

@end

@implementation LatestNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentUrl = @G_latestnews;
//    currentUrl = @"https://www.godaddy.com/ssl.aspx";
//    currentUrl = @"https://www.google.com";
    _request = [NSURLRequest requestWithURL:[NSURL URLWithString:currentUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [self.webView loadRequest:_request];
    [ProgressHUD show:nil Interaction:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%@ - %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [ProgressHUD dismiss];
    [GlobalDefine injectJavascript:@"adiai" webView:self.webView];
    [self startTimer];
}

- (void)startTimer
{
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:MainTimerInterval target:self selector:@selector(refreshTimerTicked:) userInfo:nil repeats:NO];
}

- (void)refreshTimerTicked:(NSTimer *)timer
{
    [self.webView reload];
    [self stopTimer];
}

- (void)stopTimer
{
    [refreshTimer invalidate];
    refreshTimer = nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authenticated);
    
    if (!_authenticated) {
        _authenticated = NO;
        
        _urlConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
        
        [_urlConnection start];
        
        return NO;
    }
    
    if (navigationType == UIWebViewNavigationTypeOther)
    {
        NSString *response = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([response hasPrefix:shareurl])
        {
            NSLog(@"%@", response);
            if (!kAppDelegate.logined)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"清先登錄", nil) message:NSLocalizedString(@"清先登錄, and then start share again", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Login", nil), nil];
                [alertView show];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShare object:nil userInfo:@{@"shareurl":response}];
            }
            
            return NO;
        }
        else if ([response hasPrefix:youtubeurl])
        {
            NSString *videoId = [response stringByReplacingOccurrencesOfString:youtubeurl withString:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayYoutube object:nil userInfo:@{@"videoid":videoId}];
            return NO;
        }
        
        NSArray *urlArray = [response componentsSeparatedByString:@"url="];
        if (![response hasPrefix:currentUrl] && urlArray.count != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOpenNewUrl object:nil userInfo:@{@"newurl":[urlArray lastObject]}];
            return NO;
        }
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

#pragma alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPerformLogin object:nil];
    }
}

#pragma mark - NURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"WebController Got auth challange via NSURLConnection");
    
    if ([challenge previousFailureCount] == 0)
    {
        _authenticated = YES;
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"WebController received response via NSURLConnection");
    
    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [self.webView loadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

@end
