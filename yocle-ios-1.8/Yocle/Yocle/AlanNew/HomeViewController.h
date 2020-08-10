
//#import <UIKit/UIKit.h>
//#import "ContextMenuCell.h"
//#import "YALContextMenuTableView.h"
#import "WKWebView2.h"
#import <AVFoundation/AVFoundation.h>

@interface HomeViewController : UIViewController
<
    UIDocumentInteractionControllerDelegate,
    //QLPreviewControllerDataSource,
    //QLPreviewControllerDelegate,
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    //UIWebViewDelegate,
    NSURLConnectionDataDelegate,
    //AdditionalViewCDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    //YALContextMenuTableViewDelegate,
    WKNavigationDelegate,
    WKScriptMessageHandler,
    WKUIDelegate
>

//@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet WKWebView2 *webView;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topviewheightconstraint;
@property (strong, nonatomic) UIDocumentInteractionController *customInteractionController;
//@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;
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

//
// added by alantypoon 20190130
//
@property int                 _audio_recording;
@property AVAudioRecorder*    _recorder;
@property AVAudioPlayer*      _player;
@property AVAudioPlayer*      _mp3Player;

@property BOOL                _hasCAFFile;
@property BOOL                _recording;
@property BOOL                _playing;
@property BOOL                _hasMp3File;
@property BOOL                _playingMp3;

@property NSURL*              _recordedFile;
@property CGFloat             _sampleRate;
@property AVAudioQuality      _quality;
@property NSInteger           _formatIndex;
@property NSTimer*            _timer;
@property NSDate*            _startDate;

- (void)alert2:(NSString *)str;
- (void)init_record_audio;
- (void)record_audio;
- (void)encode_audio;
- (void)play_audio;
- (void)writeToTextFile:(NSString *)s :(NSString *)fileName;
- (void)send_audio_to_js:(NSString *)path;
- (void)timerUpdate;

@end
