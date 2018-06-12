//
//  AdditionalViewController.m
//  Yocle
//
//  Created by CP Lau on 25/10/2016.
//  Copyright © 2016 Nazima. All rights reserved.
//

#import "AdditionalViewController.h"

@interface AdditionalViewController ()
@end

@implementation AdditionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWKWebview];
//    _webView.delegate = self;
    
    [self start2Load];
    
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.webView.scrollView addSubview:refreshControl];
    
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    [_webView reload];
    [refresh endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(resultFromAdditionalViewC:)]) {
//        [self.delegate resultFromAdditionalViewC:@"this is the result from additional viewc"];
//    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)setup:(NSString *)url jsfunc:(NSString *)jsfunc {
    self.url = url;
    self.jsfunc = jsfunc;
}

- (void)start2Load {
    NSURL *nsUrl = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    BOOL bDone = YES;
    
    [_webView evaluateJavaScript:@"document.readyState" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
     //   NSLog(@"response: %@ error: %@", response, error);
     //   NSLog(@"call js alert by native");
    }];


//    if ([[_webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
        // UIWebView object has fully loaded.
    if(bDone==YES) {
        NSLog(@"Dom ready");

        
 //       [_webView stringByEvaluatingJavaScriptFromString:self.jsfunc];
        
        [_webView evaluateJavaScript:self.jsfunc completionHandler:^(id _Nullable response, NSError * _Nullable error) {
      //      NSLog(@"response: %@ error: %@", response, error);
      //      NSLog(@"call js alert by native");
        }];
        
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    
    
    if (navigationType == UIWebViewNavigationTypeOther)
    {
        NSString *response = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([response hasPrefix:newwin])
        {
            
            response = [response stringByReplacingOccurrencesOfString:newwin withString:@""];
            
            NSRange range = [response rangeOfString:@">"];
            self.url = [NSString stringWithFormat:@"%s/%@?platform=ios", G_serverurl, [response substringToIndex:range.location]];
            self.jsfunc = [response substringFromIndex:range.location+1];
            [self opennewwin];
            
  //          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShowLevel3 object:nil userInfo:@{@"datatable":response}];
            
            return NO;
        }
        else if ([response hasPrefix:backwin])
        {
            
            response = [response stringByReplacingOccurrencesOfString:backwin withString:@""];
            if (self.delegate && [self.delegate respondsToSelector:@selector(resultFromAdditionalViewC:)]) {
                [self.delegate resultFromAdditionalViewC:response];
            }
            return NO;
        
        }

    }
    
    return YES;
}


-(void)opennewwin {
    AdditionalViewController *add = [[AdditionalViewController alloc] init];
    add.delegate = self;
    add.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [add setup:self.url jsfunc:self.jsfunc];
    [self presentViewController:add animated:YES completion:nil];
}

-(void)resultFromAdditionalViewC:(NSString *)result {
//    [_webView stringByEvaluatingJavaScriptFromString:result];
    
    [_webView evaluateJavaScript:result completionHandler:^(id _Nullable response, NSError * _Nullable error) {
 //       NSLog(@"response: %@ error: %@", response, error);
 //       NSLog(@"call js alert by native");
    }];

    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    //  webView.navigationDelegate = self;
    self.webView = webView;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    //  self.webView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
    
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
  //  NSLog(@"%s", __FUNCTION__);
    
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
    else if ([response hasPrefix:backwin])
    {
        
        response = [response stringByReplacingOccurrencesOfString:backwin withString:@""];
        if (self.delegate && [self.delegate respondsToSelector:@selector(resultFromAdditionalViewC:)]) {
            [self.delegate resultFromAdditionalViewC:response];
        }
        [self dismissViewControllerAnimated:NO completion:nil];        
    }
    else if ([response hasPrefix:backwinclose])
    {
        
        response = [response stringByReplacingOccurrencesOfString:backwinclose withString:@""];
        if (self.delegate && [self.delegate respondsToSelector:@selector(resultFromAdditionalViewC:)]) {
            [self.delegate resultFromAdditionalViewC:response];
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else if([response hasPrefix:pullrefresh]) {
        response = [response stringByReplacingOccurrencesOfString:pullrefresh withString:@""];
        
        /*
         if([response hasPrefix:@"1"])
         [self.webView.scrollView addSubview:refreshControl];
         else
         [self.webView.scrollView willRemoveSubview:refreshControl];
         */
        
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



  //  NSLog(@"%s", __FUNCTION__);
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
 //   NSLog(@"%s", __FUNCTION__);
}

// 页面内容到达main frame时回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
    [ProgressHUD show:nil Interaction:NO];
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
 //   NSLog(@"%s", __FUNCTION__);
    [ProgressHUD dismiss];
    
    BOOL bDone = YES;
    
    [_webView evaluateJavaScript:@"document.readyState" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"response: %@ error: %@", response, error);
  //      NSLog(@"call js alert by native");
    }];
    
    
    //    if ([[_webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
    // UIWebView object has fully loaded.
    if(bDone==YES) {
        NSLog(@"Dom ready");
        
        
        //       [_webView stringByEvaluatingJavaScriptFromString:self.jsfunc];
        
        [_webView evaluateJavaScript:self.jsfunc completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
         //   NSLog(@"call js alert by native");
        }];
        
    }
    
    
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
  //  NSLog(@"%s", __FUNCTION__);
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
 //   NSLog(@"%s", __FUNCTION__);
}

// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
 //   NSLog(@"%s", __FUNCTION__);
    completionHandler();
    
    if(self.navigationController.topViewController != self) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alert", nil) message:message                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
//    NSLog(@"%@", message);
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
 //   NSLog(@"%s", __FUNCTION__);
    completionHandler(NO);
    
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
    
//    NSLog(@"%@", message);
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



@end
