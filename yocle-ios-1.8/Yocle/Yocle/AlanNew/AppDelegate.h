
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

// database
@property (nonatomic, strong) NSArray *fullDatabaseStructure;
@property (nonatomic, strong) NSArray *tableNames;

@property (nonatomic, strong) NSHTTPCookie *myCookie;
@property (nonatomic) BOOL logined;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userPhoto;

// for push notification
@property (nonatomic, strong) NSString *deviceTokenId;
@property (nonatomic) BOOL registeredPushNotification;

// for performing push notification
@property (nonatomic, strong) NSString *pushResponse;
@property (nonatomic) BOOL pushPerformed;

@property (nonatomic, strong) NSString *postData;
@property (nonatomic, strong) NSString *cookiestr;


- (void)showUserAgreementAlert;

@end

