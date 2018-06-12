
#import <UIKit/UIKit.h>
#import "AdditionalViewController.h"
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"



@interface HomeViewController : UIViewController <UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,
UIWebViewDelegate, NSURLConnectionDataDelegate, AdditionalViewCDelegate,
UITableViewDelegate, UITableViewDataSource, YALContextMenuTableViewDelegate, WKNavigationDelegate,
WKScriptMessageHandler, WKUIDelegate
>

/*
@interface HomeViewController : UIViewController <UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, NSURLConnectionDataDelegate, AdditionalViewCDelegate, WKNavigationDelegate
>
*/
@property (weak, nonatomic) IBOutlet UIView *TopView;
//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topviewheightconstraint;

@property (strong, nonatomic) UIDocumentInteractionController *customInteractionController;


@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;
@property (nonatomic, strong) NSMutableArray *menuTitles;
@property (nonatomic, strong) NSMutableArray *menuIcons;
@property (nonatomic, strong) NSMutableArray *menuAnchors;
@property (nonatomic, strong) UIImage *likeimage;
@property (nonatomic, strong) UIImage *closeimage;


- (void)showMainPageMenu;
- (void)showSignupView;
- (void)showLoginView;
- (void)showOtherView:(NSString *)title url:(NSString *)url;
- (void)moveToPageViewController:(NSInteger)index removeAllSubviews:(BOOL)removeAllSubviews;
- (void)playYoutubeVideo:(NSString *)videoId;
- (void)openNewUrl:(NSString *)newUrl;
- (void)openShareView:(NSDictionary *)shareData;
- (void)performLogout:(Boolean)fromLeftMenu;
- (void)external_call:(NSString *)str;
- (void)updateDeviceTokenToJs;
//-(void)showLevel2:(NSString *)url datatable:(NSString *)datatable;
//-(void)showLevel3:(NSString *)url datatable:(NSString *)datatable;



@end
