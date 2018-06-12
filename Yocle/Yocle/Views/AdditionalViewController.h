//
//  AdditionalViewController.h
//  Yocle
//
//  Created by CP Lau on 25/10/2016.
//  Copyright © 2016 Nazima. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdditionalViewCDelegate <NSObject>
@required
-(void)resultFromAdditionalViewC:(NSString *)result;
@end // end of delegate protocol

@interface AdditionalViewController : UIViewController<UIWebViewDelegate, AdditionalViewCDelegate,
WKNavigationDelegate,
WKScriptMessageHandler, WKUIDelegate>

@property (weak, nonatomic) IBOutlet UIView *TopView;
//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@property (weak, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *jsfunc;

@property (nonatomic, weak) id<AdditionalViewCDelegate> delegate;



- (void)setup:(NSString *)url jsfunc:(NSString *)jsfunc;
- (void)start2Load;
- (void)opennewwin;


@end



