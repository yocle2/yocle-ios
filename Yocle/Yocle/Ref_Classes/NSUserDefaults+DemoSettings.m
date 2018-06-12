
#import "NSUserDefaults+DemoSettings.h"

@implementation NSUserDefaults (DemoSettings)

+ (void)saveLoginedCookie:(NSHTTPCookie *)cookie
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:cookie];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kLoginedCookie];
}

+ (NSHTTPCookie *)loginedCookie
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginedCookie];
    NSHTTPCookie *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    return object;
}

+ (void)saveUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:kUserName];
}

+ (NSString *)userName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kUserName];
}

+ (void)saveUserEmail:(NSString *)userEamil
{
    [[NSUserDefaults standardUserDefaults] setValue:userEamil forKey:kUserEmail];
}

+ (NSString *)userEamil
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kUserEmail];
}

+ (void)saveFBShareAlertShowed:(BOOL)performed
{
    [[NSUserDefaults standardUserDefaults] setBool:performed forKey:kFBShareAlertShowed];
}

+ (BOOL)FBShareAlertShowed
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFBShareAlertShowed];
}


+ (void)saveCookieStr:(NSString *)cookie
{
    [[NSUserDefaults standardUserDefaults] setValue:cookie forKey:@"cookiestr"];
}

+ (NSString *)getCookieStr
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"cookiestr"];
}



@end
