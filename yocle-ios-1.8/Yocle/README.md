# yocle-ios
Yocle for iOS platform


alantypoon 20190127
- Remove
    Aida_xxxxxxxx.xcworkspace
    DerivedData
    Yocle.xcworkspace111
    YocleTests
- Open yocle-ios-master/Yocle/Pods/Pods.xcodeproj/project.pbxproj and replace
    /Users/alanpoon/gdrive/_WEB/yocle/_ios/Yocle/Pods/
  to
    .
- Open Yocle/Yocle.xcworkspace
- remove unnecessary urls
  #define G_uploadertesturl                       "https://alanpoon.ddns.net:8081/dev/"
  #define G_serverapiurl                          "https://m.adiai.com"
  #define G_logout                                G_serverapiurl "/invest/servlet/logout"
  #define G_notregisterurl                        G_serverapiurl "/invest/servlet/notregister"
  #define G_mapuserurl                            G_serverapiurl "/invest/servlet/mapuser"
  #define sharetokenurl                           G_serverapiurl "/invest/servlet/sharegentoken"
  #define shareresult                             G_serverapiurl "/invest/servlet/shareshare"

- UIWebView: stretch to fullscreen in iphone X
  https://novemberfive.co/blog/apple-september-event-iphonex-apps/
  - upgrade ios from 9 to 11

- WKWebView: stretch to fullscreen in iphone X
  https://stackoverflow.com/questions/47244002/make-wkwebview-real-fullscreen-on-iphone-x-remove-safe-area-from-wkwebview
  override safeAreaInsets for WKWebView in Objective-C
  https://stackoverflow.com/questions/51547468/override-safeareainsets-for-wkwebview-in-objective-c
  #import <WebKit/WebKit.h>
  @interface FullScreenWKWebView : WKWebView
  @end
  @implementation FullScreenWKWebView
  - (UIEdgeInsets)safeAreaInsets {
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
  }
  @end
  https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/
  https://blog.csdn.net/u013190088/article/details/81194066
  https://medium.com/thefork/updating-your-app-for-the-iphone-x-33209fc894d3
