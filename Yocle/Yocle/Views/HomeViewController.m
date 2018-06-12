
#import "HomeViewController.h"
#import "LatestNewsViewController.h"
#import "WeeklyReportViewController.h"
#import "NotificationViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "OtherViewController.h"
#import "ShareViewController.h"


static NSString *const menuCellIdentifier = @"rotationCell";
/*
@interface WKPreferences (MyPreferences)
- (void)_setOfflineApplicationCacheIsEnabled:(BOOL)offlineApplicationCacheIsEnabled;
@end
*/
@interface HomeViewController () <CAPSPageMenuDelegate, KINWebBrowserDelegate, UIAlertViewDelegate, ShareViewControllerDelegate>
{
    CAPSPageMenu *pageMenu;
    CAPSPageMenu *subPageMenu;
    NSString *downloadedFilePath;
 //   UIWebView *_web;
    NSURLConnection *_urlConnection;
    NSURLRequest *_request;
    Boolean _authenticated;
    Boolean loadingUnvalidatedHTTPSPage;
    UIRefreshControl *refreshControl;
    Boolean bRefreshAdded;
}

@property (weak, nonatomic) IBOutlet UIButton *addimage;

@end

/*
@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end
*/

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScreenObjects];
    self.loginButton.hidden = YES;
    [self.signupButton setTitle:@"" forState:UIControlStateNormal];
    self.signupButton.hidden = YES;

    
    self.closeimage = [UIImage imageNamed:@"Icnclose"];
    self.likeimage = [UIImage imageNamed:@"star"];

 //   NSString *str1 = @"{\"menuitems\":[{\"anchor\":\"paragraph1\",\"title\":\"Paragraph 1\"}, {\"anchor\":\"paragraph2\",\"title\":\"Paragraph 2\"},{\"anchor\":\"paragraph3\",\"title\":\"Paragraph 3\"},{\"anchor\":\"paragraph4\",\"title\":\"Paragraph 4\"},{\"anchor\":\"paragraph5\",\"title\":\"Paragraph 5\"},{\"anchor\":\"paragraph6\",\"title\":\"Paragraph 6\"},{\"anchor\":\"paragraph7\",\"title\":\"Paragraph 7\"},{\"anchor\":\"paragraph8\",\"title\":\"Paragraph 8\"}]}";

 //   [self generateCMenu:str1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!kAppDelegate.pushPerformed)
    {
  //      [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveRemote object:nil];
    }
}

- (void)initScreenObjects
{
//    [self showMainPageMenu];

//    self.webView.delegate = self;

    [self initWKWebview];
/*
    NSString *url = [NSString stringWithFormat:@"%s/%@?platform=ios", G_serverurl, @"dev/index.php"];
//    NSString *url = [NSString stringWithFormat:@"%s/%@?platform=ios", G_serverurl, @"datatable_test.php"];
//    NSString *url = @"https://alanpoon.ddns.net:8081/dev/";
//    NSString *url = @"https://videoboard.hk/uploadertest/";
    
    
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [self.webView loadRequest:request];
*/
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.webView.scrollView addSubview:refreshControl];
    bRefreshAdded = true;
    
    
//xxx    [self.TopView setHidden:FALSE];

}
- (void)initWKWebview
{

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
/*
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 0;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
*/
    
    config.userContentController = [[WKUserContentController alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"app"];

//    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
//    [webView.configuration.preferences _setOfflineApplicationCacheIsEnabled:YES];
    
    //  webView.navigationDelegate = self;
    self.webView = webView;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
  //  self.webView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
    
    NSString *url = [NSString stringWithFormat:@"%s/%@?platform=ios&separate=1", G_serverurl, @"index.php"];
//    NSString *url = [NSString stringWithFormat:@"%s/%@?platform=ios", G_serverurl, @"datatable_test.php"];
//NSString *url = [NSString stringWithFormat:@"%s/%@?platform=ios&separate=1", G_serverurl, @"dev/redirect.php"];
    
    NSURL *nsurl=[NSURL URLWithString:url];
//    NSMutableURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:nsurl];

    NSString *cookiestr = [NSUserDefaults getCookieStr];
    if([cookiestr length]>0) {
        [request addValue:cookiestr forHTTPHeaderField:@"Cookie"];
    }
    
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [self setWebViewConstraints];
}

-(void)setWebViewConstraints {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.TopView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *sentData = (NSDictionary*)message.body;
    NSString *response = sentData[@"cmd"];
 //   NSLog(@"%s", __FUNCTION__);
    
    if ([response hasPrefix:newwin])
    {
        
        response = [response stringByReplacingOccurrencesOfString:newwin withString:@""];
        
        NSRange range = [response rangeOfString:@">"];
        
        NSString *url = [NSString stringWithFormat:@"%s/%@?platform=ios", G_serverurl, [response substringToIndex:range.location]];
        
        
        NSString *jsfunc = [response substringFromIndex:range.location+1];
        
        AdditionalViewController *add = [[AdditionalViewController alloc] init];
        add.delegate = self;
        add.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [add setup:url jsfunc:jsfunc];
        [self presentViewController:add animated:YES completion:nil];
        
        
        //          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowLevel3 object:nil userInfo:@{@"datatable":response}];
    }
    else if ([response hasPrefix:cmenu])
    {
        response = [response stringByReplacingOccurrencesOfString:cmenu withString:@""];
        [self generateCMenu:response];
    }
    else if ([response hasPrefix:changeprofile])
    {
        response = [response stringByReplacingOccurrencesOfString:changeprofile withString:@""];
        [self changemenuprofile:response];
    }
    else if ([response hasPrefix:postdata])
    {
        kAppDelegate.postData = [response copy];
    }
    else if ([response hasPrefix:showhideactionbar])
    {
        response = [response stringByReplacingOccurrencesOfString:showhideactionbar withString:@""];

        if([response hasPrefix:@"1"])
            self.topviewheightconstraint.constant = 65;
        else
            self.topviewheightconstraint.constant = 0;
        [self.TopView layoutIfNeeded];
    }
    else if([response hasPrefix:pullrefresh]) {
        response = [response stringByReplacingOccurrencesOfString:pullrefresh withString:@""];
        
        if([response hasPrefix:@"1"]) {
            if(!bRefreshAdded) {
                [self.webView.scrollView addSubview:refreshControl];
                
                bRefreshAdded = true;
            }
        }
        else {
            if(bRefreshAdded) {
//                [self.webView.scrollView willRemoveSubview:refreshControl];
                [refreshControl removeFromSuperview];
                bRefreshAdded = false;
            }
        }

    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSString *url = navigationAction.request.URL.absoluteString.lowercaseString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && ![url hasPrefix:@G_serverurl]) {
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }


 //   NSLog(@"%s", __FUNCTION__);
}

// 在响应完成时，会回调此方法
// 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
 //   NSLog(@"%s", __FUNCTION__);
}

// 开始导航跳转时会回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
 //   NSLog(@"%s", __FUNCTION__);
}

// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
 //   NSLog(@"%s", __FUNCTION__);
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
  //  NSLog(@"%s", __FUNCTION__);
}

// 页面内容到达main frame时回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
  //  NSLog(@"%s", __FUNCTION__);
    [ProgressHUD show:nil Interaction:NO];
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
 //   NSLog(@"%s", __FUNCTION__);
    [ProgressHUD dismiss];
    
    
    [self updateDeviceTokenToJs];
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
  //  NSLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
 //   NSLog(@"%s", __FUNCTION__);
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
 //   NSLog(@"%s", __FUNCTION__);
}

// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
    
    if(self.navigationController.topViewController != self) {
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alert", nil) message:message                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
 //   NSLog(@"%@", message);
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
  //  NSLog(@"%s", __FUNCTION__);
    if(self.navigationController.topViewController != self) {
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"confirm", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
 //   NSLog(@"%@", message);
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
    
//    NSLog(@"%@", prompt);
    if(self.navigationController.topViewController != self) {
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"textinout", nil) message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}


- (void)showMainPageMenu
{
    [self.settingButton setBackgroundImage:[UIImage imageNamed:@"Setting Button.png"] forState:UIControlStateNormal];
    subPageMenu.delegate = nil;
    [subPageMenu.view removeFromSuperview];
    
    pageMenu.delegate = nil;
    [pageMenu.view removeFromSuperview];
    
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    // Create variables for all view controllers you want to put in the
    // page menu, initialize them, and add each to the controller array.
    // (Can be any UIViewController subclass)
    // Make sure the title property of all view controllers is set
    // Example:
    LatestNewsViewController *controller1 = [[LatestNewsViewController alloc] initWithNibName:@"LatestNewsViewController" bundle:nil];
    controller1.title = NSLocalizedString(@"最新消息", nil);
    [controllerArray addObject:controller1];
    
    WeeklyReportViewController *controller2 = [[WeeklyReportViewController alloc] initWithNibName:@"WeeklyReportViewController" bundle:nil];
    controller2.title = NSLocalizedString(@"每週預測", nil);
    [controllerArray addObject:controller2];
    
    NotificationViewController *controller3 = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    controller3.title = NSLocalizedString(@"最新走勢", nil);
    [controllerArray addObject:controller3];
    
    // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
    // Example:
    NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorWidth: @(4.3),
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(YES),
                                 CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1),
                                 CAPSPageMenuOptionScrollMenuBackgroundColor:AIDACOLOR1,
                                 CAPSPageMenuOptionSelectionIndicatorColor:[GlobalDefine colorWithHexString:@"dcdcdc"],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor:[GlobalDefine colorWithHexString:@"a4a4f1"]
                                 };
    
    // Initialize page menu with controller array, frame, and optional parameters
    pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 64.0f, self.view.frame.size.width, self.view.frame.size.height - 64.0f) options:parameters];
    pageMenu.delegate = self;
    
    // Lastly add page menu as subview of base view controller view
    // or use pageMenu controller in you view hierachy as desired
    [self.view addSubview:pageMenu.view];
    [self setPageMenuTitle:0];
    
    if (kAppDelegate.logined)
    {
        self.loginButton.hidden = YES;
        self.signupButton.hidden = NO;
        [self.signupButton setBackgroundImage:[UIImage imageNamed:@"Logined Button.png"] forState:UIControlStateNormal];
        [self.signupButton setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        self.loginButton.hidden = NO;
        self.signupButton.hidden = NO;
        [self.signupButton setTitle:NSLocalizedString(@"加入", nil) forState:UIControlStateNormal];
        [self.signupButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)moveToPageViewController:(NSInteger)index removeAllSubviews:(BOOL)removeAllSubviews
{
   /*
    if (removeAllSubviews)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    if ([subPageMenu.view.superview isEqual:self.view])
    {
        [self.settingButton setBackgroundImage:[UIImage imageNamed:@"Setting Button.png"] forState:UIControlStateNormal];
        [subPageMenu.view removeFromSuperview];
    }
    [pageMenu moveToPage:index];
    
   */
 /*
    NSString *fullURL = self.webView.request.URL.absoluteString;
    fullURL = @"https://dev.adiai.com:8441/anchortest.php";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
*/

}

#pragma page menu delegate
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index
{
    [self setPageMenuTitle:index];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

- (void)setPageMenuTitle:(NSInteger)index
{
    self.titleLabel.text = NSLocalizedString(@"home", nil);
 /*
    if (index == 0)
        self.titleLabel.text = [NSString stringWithFormat:@"%@-%@", NSLocalizedString(@"顥森天下", nil), NSLocalizedString(@"最新消息", nil)];
    else if (index == 1)
        self.titleLabel.text = [NSString stringWithFormat:@"%@-%@", NSLocalizedString(@"顥森天下", nil), NSLocalizedString(@"每週預測", nil)];
    else if (index == 2)
        self.titleLabel.text = [NSString stringWithFormat:@"%@-%@", NSLocalizedString(@"顥森天下", nil), NSLocalizedString(@"最新走勢", nil)];
*/
}

- (void)showSubPageMenu:(UIViewController *)viewController title:(NSString *)title
{
    [subPageMenu.view removeFromSuperview];
    subPageMenu.delegate = nil;
    
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    [controllerArray addObject:viewController];
    
    NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemSeparatorWidth: @(4.3),
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(YES),
                                 CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1),
                                 CAPSPageMenuOptionScrollMenuBackgroundColor:AIDACOLOR1,
                                 CAPSPageMenuOptionSelectionIndicatorColor:[GlobalDefine colorWithHexString:@"dcdcdc"],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor:[GlobalDefine colorWithHexString:@"a4a4f1"],
                                 CAPSPageMenuOptionHideTopMenuBar:@YES
                                 };
    subPageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 64.0f, self.view.frame.size.width, self.view.frame.size.height - 64.0f) options:parameters];
    [self.view addSubview:subPageMenu.view];
    
    [self.settingButton setBackgroundImage:[UIImage imageNamed:@"Back Button.png"] forState:UIControlStateNormal];
    self.titleLabel.text = title;
}

- (void)showSignupView
{
    SignupViewController *viewController = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    [self showSubPageMenu:viewController title:NSLocalizedString(@"home", nil)];
}

- (void)showLoginView
{
//    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    [self showSubPageMenu:viewController title:NSLocalizedString(@"home", nil)];
    
    NSURL *url = [NSURL URLWithString:@G_serverurl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
}

- (void)showOtherView:(NSString *)title url:(NSString *)url
{
    OtherViewController *viewController = [[OtherViewController alloc] initWithNibName:@"OtherViewController" bundle:nil];
    viewController.url = url;
    [self showSubPageMenu:viewController title:[NSString stringWithFormat:@"%@-%@", NSLocalizedString(@"home", nil), title]];
}

- (void)openShareView:(NSDictionary *)shareData
{
    ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    viewController.shareData = shareData;
    viewController.delegate = self;
    [self showSubPageMenu:viewController title:NSLocalizedString(@"home", nil)];
}

#pragma share view controller delegate
- (void)backedWithCancelButton:(ShareViewController *)viewController
{
    viewController.delegate = nil;
    if ([subPageMenu.view.superview isEqual:self.view])
    {
        [self.settingButton setBackgroundImage:[UIImage imageNamed:@"Setting Button.png"] forState:UIControlStateNormal];
        [subPageMenu.view removeFromSuperview];
        
        [self setPageMenuTitle:pageMenu.currentPageIndex];
    }
}

- (void)openDoc:(NSString *)path
{
    downloadedFilePath = path;
    
    [self setupDocumentControllerWithURL:[NSURL fileURLWithPath:path]];
    // for case 3 we use the QuickLook APIs directly to preview the document -
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    
    // start previewing the document at the current section index
    previewController.currentPreviewItemIndex = 1;
    [self presentViewController:previewController animated:NO completion:nil];
    //            self.navigationController.navigationBarHidden = NO;
    //            [[self navigationController] pushViewController:previewController animated:YES];
}

- (void)openNewUrl:(NSString *)newUrl
{
    if ([newUrl hasPrefix:fakedomain])
    {
        if (![newUrl hasSuffix:@".docx"])
            return;
        
        if (!kAppDelegate.logined)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"清先登錄", nil) message:NSLocalizedString(@"清先登錄, and then start share again", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Login", nil), nil];
            [alertView show];
            return;
        }
        
        [ProgressHUD show:nil Interaction:NO];
        newUrl = [newUrl stringByReplacingOccurrencesOfString:fakedomain withString:@G_serverurl];
        NSString* theFileName = [newUrl lastPathComponent];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:newUrl]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:theFileName];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
        if (fileExists)
        {
            [self openDoc:path];
            [ProgressHUD showSuccess:nil Interaction:NO];
        }
        else
        {
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Successfully downloaded file to %@", path);
                [ProgressHUD showSuccess:nil Interaction:NO];
                [self openDoc:path];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [ProgressHUD showError:error.localizedDescription Interaction:NO];
            }];
            
            [operation start];
        }
    }
    else
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        
        UINavigationController *webBrowserNavigationController = [KINWebBrowserViewController navigationControllerWithWebBrowser];
        KINWebBrowserViewController *webBrowser = [webBrowserNavigationController rootWebBrowser];
        [webBrowser setDelegate:self];
        webBrowser.showsURLInNavigationBar = YES;
        webBrowser.tintColor = [UIColor whiteColor];
        webBrowser.barTintColor = AIDACOLOR1;
        webBrowser.showsPageTitleInNavigationBar = NO;
        webBrowser.showsURLInNavigationBar = NO;
        [self presentViewController:webBrowserNavigationController animated:YES completion:nil];
        
        [webBrowser loadURLString:newUrl];
    }
}

#pragma alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPerformLogin object:nil];
    }
}

- (void)playYoutubeVideo:(NSString *)videoId
{
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoId];
    videoPlayerViewController.moviePlayer.fullscreen = YES;
    [self presentViewController:videoPlayerViewController animated:NO completion:nil];
}

- (void)performLogout:(Boolean)fromLeftMenu
{
/*
    [ProgressHUD show:nil Interaction:NO];
    [[ApiClient sharedInstance] getDataWithGet:@G_logout parameters:nil success:^(id responseObject) {
        NSString* newStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseObject);
        NSLog(@"%@", newStr);
        
        [GlobalDefine deleteCookies];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogouted object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"logoutsuccess", nil) message:NSLocalizedString(@"logoutuseagain", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        [ProgressHUD dismiss];
        [self.settingButton setBackgroundImage:[UIImage imageNamed:@"Setting Button.png"] forState:UIControlStateNormal];
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        NSLog(@"%@", errorString);
        [ProgressHUD dismiss];
    }];
 */
    if(fromLeftMenu) {
    [self external_call:@"logout"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogouted object:nil];
//    [self getWebViewCookie:true];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogouted object:nil];
        [self getWebViewCookie:true];        
    }
}

- (IBAction)showMenu:(id)sender
{
    if ([subPageMenu.view.superview isEqual:self.view])
    {
        [self.settingButton setBackgroundImage:[UIImage imageNamed:@"Setting Button.png"] forState:UIControlStateNormal];
        [subPageMenu.view removeFromSuperview];
        
        [self setPageMenuTitle:pageMenu.currentPageIndex];
    }
    else
    {
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        [self.frostedViewController presentMenuViewController];
    }
}

- (IBAction)loginButtonClicked:(id)sender
{
    [self showLoginView];
}

- (IBAction)registerButtonClicked:(id)sender
{
    
    
/*
    if (self.loginButton.hidden) // logout
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"登出", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self performLogout];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:logoutAction];
        [alert addAction:cancelAction];
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = sender;
        popPresenter.sourceRect = ((UIButton *)sender).bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
    else // sign up
    {
        [self showSignupView];
    }
*/
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.05f;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        //optional - implement menu items layout
        self.contextMenuTableView.menuItemsSide = Right;
        self.contextMenuTableView.menuItemsAppearanceDirection = FromTopToBottom;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];

    
 }

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    //checks if docInteractionController has been initialized with the URL
    if (self.customInteractionController == nil)
    {
        self.customInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.customInteractionController.delegate = self;
    }
    else
    {
        self.customInteractionController.URL = url;
    }
}

#pragma quicklook delegate
#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}

#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    self.navigationController.navigationBarHidden = YES;
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    NSURL *fileURL = nil;
//    NSString *fileName = [GlobalDefine getImageNameFromUrl:[NSURL URLWithString:selectedData[Name_Media_Response][Name_Media_Url]]];
//    NSString *filePath = [[GlobalDefine applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    fileURL = [NSURL fileURLWithPath:downloadedFilePath];
    
//    fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"adiai.js" ofType:nil]];
    
    return fileURL;
}
- (IBAction)addimagebuttonclick:(id)sender {
/*
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
 */
    
    AdditionalViewController *add = [[AdditionalViewController alloc] init];
    add.delegate = self;
    add.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:add animated:YES completion:nil];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}



//#pragma mark - Webview delegate

// Note: This method is particularly important. As the server is using a self signed certificate,
// we cannot use just UIWebView - as it doesn't allow for using self-certs. Instead, we stop the
// request in this method below, create an NSURLConnection (which can allow self-certs via the delegate methods
// which UIWebView does not have), authenticate using NSURLConnection, then use another UIWebView to complete
// the loading and viewing of the page. See connection:didReceiveAuthenticationChallenge to see how this works.




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authenticated);
    
    if (loadingUnvalidatedHTTPSPage)
    {
        _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [_urlConnection start];
        return NO;
    }
    
 
    if (navigationType == UIWebViewNavigationTypeOther)
    {
        NSString *response = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
    //    if([response hasPrefix:@"about:blank"]) {
    //        return NO;
    //    }
        
        
        if ([response hasPrefix:newwin])
        {
            
            response = [response stringByReplacingOccurrencesOfString:newwin withString:@""];
            
            NSRange range = [response rangeOfString:@">"];
            
            NSString *url = [NSString stringWithFormat:@"%s/%@?platform=ios", G_serverurl, [response substringToIndex:range.location]];
                                                                               
                                                                               
            NSString *jsfunc = [response substringFromIndex:range.location+1];
            
            AdditionalViewController *add = [[AdditionalViewController alloc] init];
            add.delegate = self;
            add.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [add setup:url jsfunc:jsfunc];
            [self presentViewController:add animated:YES completion:nil];

            
            //          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowLevel3 object:nil userInfo:@{@"datatable":response}];
            
            return NO;
        }
        else if ([response hasPrefix:cmenu])
        {
            response = [response stringByReplacingOccurrencesOfString:cmenu withString:@""];
            [self generateCMenu:response];
            return NO;
        }
        else if ([response hasPrefix:changeprofile])
        {
            response = [response stringByReplacingOccurrencesOfString:changeprofile withString:@""];
            [self changemenuprofile:response];
            return NO;
        }

    }
    
    return YES;
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
 /*
    if ([error.domain isEqualToString: NSURLErrorDomain]) {
      //  if (error.code == kCFURLErrorServerCertificateHasBadDate        ||
       //     error.code == kCFURLErrorServerCertificateUntrusted         ||
      //      error.code == kCFURLErrorServerCertificateHasUnknownRoot    ||
      //      error.code == kCFURLErrorServerCertificateNotYetValid)
        {
       //     NSURL *url=[NSURL URLWithString:@"https://videoboard.hk/uploadertest/"];
            
        //    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSString *theURLString = [error.userInfo objectForKey:@"NSErrorFailingURLStringKey"]; //this works
            
            
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:theURLString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
            loadingUnvalidatedHTTPSPage = YES;
            [self.webView loadRequest:requestObj];
            
        }
    }
  */
}


-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if ( self.presentedViewController)
    {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}


//#pragma mark - NURLConnection delegate
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
/*
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    NSURLCredential *cred;
    cred = [NSURLCredential credentialForTrust:trust];
    [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
*/
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
/*
    NSURL *url = [response URL];
    NSString *myString = [url absoluteString];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    loadingUnvalidatedHTTPSPage = NO;
    [self.webView loadRequest: requestObj];
    [_urlConnection cancel];
*/
}

- (void)resultFromAdditionalViewC:(NSString *)result
{
    [self.webView evaluateJavaScript:result completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //       NSLog(@"response: %@ error: %@", response, error);
        //       NSLog(@"call js alert by native");
    }];

}

-(void)handleRefresh:(UIRefreshControl *)refresh {
/*
    NSString *fullURL = self.webView.request.URL.absoluteString;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
 */
    [self.webView reload];
    
    [refresh endRefreshing];
}

/*
-(void)showLevel2:(NSString *)url datatable:(NSString *)datatable {
    AdditionalViewController *add = [[AdditionalViewController alloc] init];
    add.delegate = self;
    add.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [add setUrlDatatable:url datatable:datatable];
    [self presentViewController:add animated:YES completion:nil];
}

-(void)showLevel3:(NSString *)url datatable:(NSString *)datatable {
    AdditionalViewController *add = [[AdditionalViewController alloc] init];
    add.delegate = self;
    add.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [add setUrlDatatable:url datatable:datatable];
    [self presentViewController:add animated:YES completion:nil];
}
*/

/*
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSLog(@"Allow all");
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFDataRef exceptions = SecTrustCopyExceptions (serverTrust);
    SecTrustSetExceptions (serverTrust, exceptions);
    CFRelease (exceptions);
    completionHandler (NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
}
 */

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}

- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"Section 1",
                        @"Section 2",
                        @"Section 3",
                        @"Section 4",
                        @"Section 5"];
    
    self.menuIcons = @[[UIImage imageNamed:@"Icnclose"],
                       [UIImage imageNamed:@"LikeIcn"],
                       [UIImage imageNamed:@"LikeIcn"],
                       [UIImage imageNamed:@"LikeIcn"],
                       [UIImage imageNamed:@"LikeIcn"],
                       [UIImage imageNamed:@"LikeIcn"]];
}


#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"Menu dismissed with indexpath = %ld", (long)indexPath.item);
    
    long no = indexPath.item;
    NSString *anchor = @"";
    if(no > 0) {
        anchor = self.menuAnchors[no];
        NSString *js = [NSString stringWithFormat:@"window.location.hash = '%@'", anchor];
        
 // xxx
//        [_webView stringByEvaluatingJavaScriptFromString:js];
        
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
            NSLog(@"call js alert by native");
        }];
        
        
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView dismisWithIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)generateCMenu:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];

    if(self.menuTitles !=nil && [self.menuTitles count] > 0) {
        [self.menuTitles removeAllObjects];
        [self.menuIcons removeAllObjects];
        [self.menuAnchors removeAllObjects];
        self.menuTitles = nil;
        self.menuIcons = nil;
        self.menuAnchors = nil;
        
    }

    self.menuTitles = [[NSMutableArray alloc] init];
    self.menuIcons = [[NSMutableArray alloc] init];
    self.menuAnchors = [[NSMutableArray alloc] init];
    
    [self.menuTitles addObject:@""];
    [self.menuIcons addObject:self.closeimage];
    [self.menuAnchors addObject:@""];
  
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *menuitems = [json objectForKey:@"menuitems"];
    NSString *a;
    NSString *t;
    NSUInteger count = [menuitems count];
    for(NSUInteger i=0; i<count; i++) {
        a = [[menuitems objectAtIndex:i] objectForKey:@"anchor"];
        t = [[menuitems objectAtIndex:i] objectForKey:@"title"];
        [self.menuTitles addObject:t];
        [self.menuAnchors addObject:a];
        [self.menuIcons addObject:self.likeimage];
    }
    
    if(count >0) {
    
        if(self.contextMenuTableView) {
            self.contextMenuTableView = nil;
        }
    
        if (!self.contextMenuTableView) {
            self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
            self.contextMenuTableView.animationDuration = 0.01f;
            //optional - implement custom YALContextMenuTableView custom protocol
            self.contextMenuTableView.yalDelegate = self;
            //optional - implement menu items layout
            self.contextMenuTableView.menuItemsSide = Right;
            self.contextMenuTableView.menuItemsAppearanceDirection = FromTopToBottom;
        
            //register nib
            UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
            [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
        }
        
        self.signupButton.hidden = NO;
    }
    else {
        self.signupButton.hidden = YES;
    }
}
-(void)changemenuprofile:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    kAppDelegate.userPhoto = [NSString stringWithFormat:@"%@/%@'", @G_serverurl, [json objectForKey:@"uri"]];
    kAppDelegate.userName = [json objectForKey:@"name"];
    kAppDelegate.userEmail = @"test@gmail.com";
    kAppDelegate.cookiestr = [json objectForKey:@"cookiestr"];
    NSLog(@"photo=%@", kAppDelegate.userPhoto);
    NSString *i = [json objectForKey:@"status"];
    
    if([i isEqual:@"2"]) { // logoned successful
        [self getWebViewCookie:false];
        [self updateDeviceTokenToJs];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateLeftMenu object:nil];
    }
    else {
        [self performLogout:false];
    }
}
-(void)external_call:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    str = [str lowercaseString];
    
    NSString *js = [NSString stringWithFormat:@"external_call('%@')", str];
    // xxx
    dispatch_async(dispatch_get_main_queue(), ^{
  //      [_webView stringByEvaluatingJavaScriptFromString:js];
        
        [_webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
            NSLog(@"call js alert by native");
        }];
        
    });
}
-(void)updateDeviceTokenToJs {
    BOOL bDone = YES;
    
    [_webView evaluateJavaScript:@"document.readyState" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"response: %@ error: %@", response, error);
        //      NSLog(@"call js alert by native");
    }];
    
    
    //    if ([[_webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
    // UIWebView object has fully loaded.
    if(bDone==YES && [kAppDelegate.deviceTokenId length]>0) {
        NSLog(@"Dom ready");
        
        
        //       [_webView stringByEvaluatingJavaScriptFromString:self.jsfunc];
        
        NSString *jsfunc = [NSString stringWithFormat:@"external_call('%@', '%@')", @"notify_token", kAppDelegate.deviceTokenId];
        [_webView evaluateJavaScript:jsfunc completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
            //   NSLog(@"call js alert by native");
        }];
        
    }
    
}
-(void)getWebViewCookie:(Boolean)blogout {
    if(!blogout) {
    [_webView evaluateJavaScript:@"document.cookie;" completionHandler:^(NSString *result, NSError *error)
     {
         NSLog(@"Error getting cookies: %@",error);
         kAppDelegate.cookiestr = result;
         [NSUserDefaults saveCookieStr:result];

     }];
    }
    else {
        [_webView evaluateJavaScript:@"document.cookie=\"\";" completionHandler:^(NSString *result, NSError *error)
         {
             NSLog(@"Error getting cookies: %@",error);
             kAppDelegate.cookiestr = @"";
             [NSUserDefaults saveCookieStr:@""];
         }];
        
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                             for (WKWebsiteDataRecord *record  in records)
                             {
                                 if ( [record.displayName containsString:@"facebook"])
                                 {
                                     [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                               forDataRecords:@[record]
                                                                            completionHandler:^{
                                                                                NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                            }];
                                 }
                             }
                         }];
        
        
    }
}

@end
