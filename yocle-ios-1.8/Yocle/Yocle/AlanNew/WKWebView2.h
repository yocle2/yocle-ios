//
//  WKWebView2.h
//  Yocle
//
//  Created by Chloe Lo on 28/1/2019.
//

// https://stackoverflow.com/questions/51547468/override-safeareainsets-for-wkwebview-in-objective-c


#import <WebKit/WebKit.h>

@interface WKWebView2 : WKWebView

- (UIEdgeInsets)safeAreaInsets;

@end

