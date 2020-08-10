
#import "AppDelegate.h"
#import "WXApi.h"
#import "CustomDataProtocol.h"
#import "NSURLProtocol+WebKitSupport.h"
#import "AllCacheTool.h"
#import "NSData+AES.h"
//#import <OHHTTPStubs/NSURLRequest+HTTPBodyTesting.h>
#import <objc/runtime.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        
    } else {
        // This is the first lanuch ever
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
      //  [self showUserAgreementAlert];
    }
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];  
    }
    else {
        [self performRegisterNotification:application];
    }
    _userName = [NSUserDefaults userName];
    _userEmail = [NSUserDefaults userEamil];
    _userPhoto = @"";
//    [GlobalDefine deleteCookies];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)performRegisterNotification:(UIApplication *)application
{
    //Registering user notification - (Handles user and remote notifications)
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [application registerForRemoteNotifications];
}

-   (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation
//            ];
//}

#pragma mark - Push notification methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if ([deviceToken description].length != 0)
    {
        self.deviceTokenId = [deviceToken hexadecimalString];
        self.registeredPushNotification = YES;
        NSLog(@"Did Register for Remote Notifications with Device Token (%@)", [deviceToken description]);
        
     //   [NSThread sleepForTimeInterval:10.0f];

     //   [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateDeviceTokenToJs object:nil];
        
        
/*
        if (!self.logined)
        {
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *notid = [[AES sharedInstance] encrypt:kAppDelegate.deviceTokenId];
                
                dispatch_async( dispatch_get_main_queue(), ^{
                    //                    [[ApiClient sharedInstance] getDataWithPost:@G_notregisterurl parameters:@{@"param":dataString}
                    [[ApiClient sharedInstance] getDataWithPost:@G_notregisterurl parameters:@{@"nid":notid, @"device":@"iphone"}                                                        success:^(id responseObject) {
                        NSString* newStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        NSLog(@"%@", newStr);
                    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                        NSLog(@"%@ error: %@", @G_notregisterurl, errorString);
                    }];
                });
            });
        }
 */
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [ProgressHUD showError:error.localizedDescription Interaction:NO];
}

/*
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    self.pushResponse = userInfo[@"uri"];
    self.pushPerformed = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveRemote object:nil];
    
    NSString *title = NSLocalizedString(@"Push Notification", nil);
    
    if ([kAppDelegate.pushResponse hasPrefix:@"n"])
    {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                       description:NSLocalizedString(@"You got notification kind", nil)
                                                              type:TWMessageBarMessageTypeInfo];
    }
    else if ([kAppDelegate.pushResponse hasPrefix:@"f"])
    {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                       description:NSLocalizedString(@"You got google form kind", nil)
                                                              type:TWMessageBarMessageTypeInfo];
    }
    else if ([kAppDelegate.pushResponse hasPrefix:@"w"])
    {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                       description:NSLocalizedString(@"You got weekly report kind", nil)
                                                              type:TWMessageBarMessageTypeInfo];
    }
}
*/

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
//    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    [self application:application didReceiveRemoteNotification_orig:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification_orig:(NSDictionary *)userInfo
{
    self.pushResponse = userInfo[@"aps"][@"uri"];
    self.pushPerformed = NO;
    
    NSArray *array = [kAppDelegate.pushResponse componentsSeparatedByString: @":::"];
    NSString* title = [array objectAtIndex:0];
    NSString* shorttext = [array objectAtIndex:1];
    NSString* newUrl = [array objectAtIndex:2];

    
    
 //   NSString *title = NSLocalizedString(@"Push Notification", nil);
    
    if(application.applicationState == UIApplicationStateActive) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                       description:shorttext
                                                              type:TWMessageBarMessageTypeInfo duration:20.0
                                                          callback:^{[[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveRemote object:nil];}
         ];
        
/*
        if ([kAppDelegate.pushResponse hasPrefix:@"n"])
        {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:NSLocalizedString(@"You got notification kind", nil)
                                                                  type:TWMessageBarMessageTypeInfo duration:20.0
                                                              callback:^{[[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveRemote object:nil];}
             ];
        }
        else if ([kAppDelegate.pushResponse hasPrefix:@"f"])
        {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:NSLocalizedString(@"You got google form kind", nil)
                                                                  type:TWMessageBarMessageTypeInfo duration:20.0
                                                              callback:^{[[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveRemote object:nil];}
             ];
        }
        else if ([kAppDelegate.pushResponse hasPrefix:@"w"])
        {
            
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:NSLocalizedString(@"You got weekly report kind", nil)
                                                                  type:TWMessageBarMessageTypeInfo duration:20.0
                                                              callback:^{[[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveRemote object:nil];}
             ];
        }
        else if ([kAppDelegate.pushResponse hasPrefix:@"a"])
        {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:NSLocalizedString(@"You got new article kind", nil)
                                                                  type:TWMessageBarMessageTypeInfo duration:20.0
                                                              callback:^{[[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveRemote object:nil];}
             ];
        }
 */
        
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveRemote object:nil];
        
    /*
        
        if ([kAppDelegate.pushResponse hasPrefix:@"n"])
        {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:NSLocalizedString(@"You got notification kind", nil)
                                                                  type:TWMessageBarMessageTypeInfo];
        }
        else if ([kAppDelegate.pushResponse hasPrefix:@"f"])
        {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:NSLocalizedString(@"You got google form kind", nil)
                                                                  type:TWMessageBarMessageTypeInfo];
        }
        else if ([kAppDelegate.pushResponse hasPrefix:@"w"])
        {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:NSLocalizedString(@"You got weekly report kind", nil)
                                                                  type:TWMessageBarMessageTypeInfo];
        }
        else if ([kAppDelegate.pushResponse hasPrefix:@"a"])
        {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                           description:NSLocalizedString(@"You got new article kind", nil)
                                                                  type:TWMessageBarMessageTypeInfo];
        }
     */
    }
}


//====================For iOS 10====================
// iOS 10收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        //Called when a notification is delivered to a foreground app.
        NSDictionary *userInfo = notification.request.content.userInfo;
        self.pushResponse = userInfo[@"aps"][@"uri"];
        self.pushPerformed = NO;
//        NSArray *array = [kAppDelegate.pushResponse componentsSeparatedByString: @":::"];
//        NSString* title = [array objectAtIndex:0];
//        NSString* shorttext = [array objectAtIndex:1];
//        NSString* newUrl = [array objectAtIndex:2];
/*
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:title
                                                       description:shorttext
                                                              type:TWMessageBarMessageTypeInfo duration:20.0
                                                          callback:^{[[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveRemote object:nil];}
         ];
*/
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        NSDictionary *userInfo = response.notification.request.content.userInfo;
        self.pushResponse = userInfo[@"aps"][@"uri"];
        self.pushPerformed = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceiveRemote object:nil];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();  // 系统要求执行这个方法
    
}


- (BOOL)logined
{
    BOOL result = NO;

    [GlobalDefine getCookies];
    self.myCookie = [NSUserDefaults loginedCookie];
    
    if (self.myCookie != nil)
        if ([GlobalDefine getDurationAsNumber:[NSDate date] endDate:self.myCookie.expiresDate] > 0)
            result = YES;

    
    if(_userPhoto.length) {
        result = YES;
    }
    
    return result;
    
}

- (void)showUserAgreementAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"home", nil) message:NSLocalizedString(@"Terms", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    [NSUserDefaults saveUserName:userName];
}

- (void)setUserEmail:(NSString *)userEmail
{
    _userEmail = userEmail;
    [NSUserDefaults saveUserEmail:userEmail];
}

- (NSURLSessionConfiguration *)zw_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self zw_defaultSessionConfiguration];
    NSArray *protocolClasses = @[[AllCacheTool class]];
    configuration.protocolClasses = protocolClasses;
    
    return configuration;
}
- (void)load{
    Method systemMethod = class_getClassMethod([NSURLSessionConfiguration class], @selector(defaultSessionConfiguration));
    Method zwMethod = class_getClassMethod([self class], @selector(zw_defaultSessionConfiguration));
    method_exchangeImplementations(systemMethod, zwMethod);
}

@end
