
#import "NotificationViewController.h"

@interface NotificationViewController () <UIWebViewDelegate>
{
    NSString *currentUrl;
    NSTimer *refreshTimer;
}

@end

@implementation NotificationViewController

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
/*
    currentUrl = @G_notification;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:7]];
 */
    [ProgressHUD show:nil Interaction:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    if (navigationType == UIWebViewNavigationTypeOther)
    {
        NSString *response = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *urlArray = [response componentsSeparatedByString:@"url="];
        if (![response hasPrefix:currentUrl] && urlArray.count != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOpenNewUrl object:nil userInfo:@{@"newurl":[NSString stringWithFormat:@"%@%@", @G_serverurl, [urlArray lastObject]]}];
            return NO;
        }
    }
    
    return YES;
}

@end
