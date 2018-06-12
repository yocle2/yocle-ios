
#import <Foundation/Foundation.h>

static NSString * const kLoginedCookie      = @"kLoginedCookie";
static NSString * const kUserName           = @"kUserName";
static NSString * const kUserEmail          = @"kUserEmail";
static NSString * const kFBShareAlertShowed = @"kFBShareAlertShowed";

@interface NSUserDefaults (DemoSettings)

+ (void)saveLoginedCookie:(NSHTTPCookie *)cookie;
+ (NSHTTPCookie *)loginedCookie;

+ (void)saveUserName:(NSString *)userName;
+ (NSString *)userName;

+ (void)saveUserEmail:(NSString *)userEamil;
+ (NSString *)userEamil;

+ (void)saveFBShareAlertShowed:(BOOL)performed;
+ (BOOL)FBShareAlertShowed;

+ (void)saveCookieStr:(NSString *)cookie;
+ (NSString *)getCookieStr;

@end
