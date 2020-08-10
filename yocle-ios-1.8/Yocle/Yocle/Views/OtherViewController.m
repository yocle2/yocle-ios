
#import "OtherViewController.h"

@interface OtherViewController () <UIWebViewDelegate>
{
    NSString *currentUrl;
    NSTimer *refreshTimer;
}

@end

@implementation OtherViewController

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
    
    currentUrl = self.url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:7]];
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
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:OtherTimerInterval target:self selector:@selector(refreshTimerTicked:) userInfo:nil repeats:NO];
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

/*
        if ([response hasPrefix:googlemapurl])
            return YES;
        
        if ([response hasPrefix:shareurl])
        {
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
*/
        NSArray *urlArray = [response componentsSeparatedByString:@"url="];
        if (![response hasPrefix:currentUrl] && urlArray.count != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOpenNewUrl object:nil userInfo:@{@"newurl":[urlArray lastObject]}];
            return NO;
        }
    }
    
    return YES;
}

@end
