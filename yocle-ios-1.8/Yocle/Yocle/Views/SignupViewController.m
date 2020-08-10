
#import "SignupViewController.h"

@interface SignupViewController () <UIWebViewDelegate, UIAlertViewDelegate>

@end

@implementation SignupViewController

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
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@G_register] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:7]];
 */
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
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeOther)
    {
        NSString *response = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([response rangeOfString:@"message="].location != NSNotFound)
        {
            NSArray *stringArray = [response componentsSeparatedByString:@"message="];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"註册失敗", nil) message:[stringArray lastObject] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
        }
/*
        else if ([response hasSuffix:showuseragreement])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TermsTitle", nil) message:NSLocalizedString(@"Terms", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            [alertView show];
        }
*/
        else if ([response rangeOfString:@"歡迎 "].location != NSNotFound && [response rangeOfString:@", 你已成功註冊成為會員!"].location != NSNotFound)
        {
            NSArray *stringArray = [response componentsSeparatedByString:@"<>"];
            NSArray *emailArray = [[stringArray firstObject] componentsSeparatedByString:@"/"];
            NSString *userName = [stringArray lastObject];
            
            userName = [userName stringByReplacingOccurrencesOfString:@"歡迎 " withString:@""];
            userName = [userName stringByReplacingOccurrencesOfString:@", 你已成功註冊成為會員!" withString:@""];
            kAppDelegate.userName = userName;
            kAppDelegate.userEmail = [emailArray lastObject];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"加入成功", nil) message:[NSString stringWithFormat:NSLocalizedString(@"歡迎 %@, 你已成功註冊成為會員!", nil), userName] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogined object:nil];
        }
    }
    
    return YES;
}

#pragma alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.webView stringByEvaluatingJavaScriptFromString:@"continueregister()"];
    }
}

@end
