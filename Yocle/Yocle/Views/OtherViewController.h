
#import <UIKit/UIKit.h>

@interface OtherViewController : UIViewController

@property (nonatomic, strong) NSString *url;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
