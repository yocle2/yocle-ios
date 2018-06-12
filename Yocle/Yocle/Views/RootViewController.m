
#import "RootViewController.h"
#import "HomeNavigationController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"

@interface RootViewController ()
{
    HomeNavigationController *homeNav;
    LeftViewController *leftView;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    [self initScreenObjects];
    self.contentViewController = homeNav;
    self.menuViewController = leftView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weekReportClicked:) name:NotificationWeekReportClicked object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationClicked:) name:NotificationNotificationClicked object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(latestNewsClicked:) name:NotificationLatestNewsClicked object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerClicked:) name:NotificationRegisterClicked object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherViewClicked:) name:NotificationOtherViewClicked object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playYoutube:) name:NotificationPlayYoutube object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logined:) name:NotificationLogined object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logouted:) name:NotificationLogouted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performLogin:) name:NotificationPerformLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openNewUrl:) name:NotificationOpenNewUrl object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemote:) name:NotificationReceiveRemote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationShare:) name:NotificationShare object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performLogout:) name:NotificationPerformLogout object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLeftMenu:) name:NotificationUpdateLeftMenu object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceTokenToJs:) name:NotificationUpdateDeviceTokenToJs object:nil];
    
 /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLevel2:) name:NotificationShowLevel2 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLevel3:) name:NotificationShowLevel3 object:nil];
 */   
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initScreenObjects
{
    homeNav = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigation"];
    leftView = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftView"];
}

- (void)gotoViewInHomeView:(NSInteger)index
{
    UINavigationController *nav = (UINavigationController *)self.contentViewController;
    if ([[nav.viewControllers firstObject] isKindOfClass:[HomeViewController class]])
    {
        [((HomeViewController *)[nav.viewControllers firstObject]) moveToPageViewController:index removeAllSubviews:NO];
        [self hideMenuViewController];
    }
}

- (void)performLogout:(NSNotification *)notification
{
    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
    [homeView performLogout:true];
    [self hideMenuViewController];
}

- (void)notificationShare:(NSNotification *)notification
{
    //http://toshare.adiai.com/share.php?socialnetwork=1&itemid=72&itemimageuri=/images/weeklyreport20151223_app.jpg
    NSString *url = notification.userInfo[@"shareurl"];
    url = [url stringByReplacingOccurrencesOfString:shareurl withString:@""];
    
    NSArray *items = [url componentsSeparatedByString:@"&"];
    NSString *socialnetwork;
    NSString *itemid;
    NSString *imageuri;
    
    if (items.count == 3)
    {
        socialnetwork = [[items firstObject] stringByReplacingOccurrencesOfString:@"socialnetwork=" withString:@""];
        itemid = [items[1] stringByReplacingOccurrencesOfString:@"itemid=" withString:@""];
        imageuri = [[items lastObject] stringByReplacingOccurrencesOfString:@"imageuri=" withString:@""];
        imageuri = [imageuri stringByReplacingOccurrencesOfString:@"item" withString:@""];
        imageuri = [NSString stringWithFormat:@"%@%@", @G_serverurl, imageuri];
        
        //http://m.adiai.com/invest/servlet/sharegentoken?iid=68&media=fa
        
        [ProgressHUD show:nil Interaction:NO];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async( dispatch_get_main_queue(), ^{
                NSDictionary *parameters = @{@"iid":itemid, @"media":MediaKind[[socialnetwork integerValue]]};
                [[ApiClient sharedInstance] getDataWithPost:@sharetokenurl parameters:parameters success:^(id responseObject) {
                    NSError* error;
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                    
                    NSMutableDictionary *data = [json mutableCopy];
                    data[@"imageurl"] = imageuri;
                    
                    [ProgressHUD showSuccess:nil Interaction:NO];
                    
                    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
                    [homeView openShareView:data];
                    [self hideMenuViewController];
                } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                    NSLog(@"%@ error: %@", @G_mapuserurl, errorString);
                    [ProgressHUD showError:nil Interaction:NO];
                }];
            });
        });
    }
}

- (void)performPushNotification
{
    if (!kAppDelegate.pushPerformed)
    {
        NSArray *array = [kAppDelegate.pushResponse componentsSeparatedByString: @":::"];
        NSString* title = [array objectAtIndex:0];
        NSString* shorttext = [array objectAtIndex:1];
        NSString* newUrl = [array objectAtIndex:2];
        
        HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
        [homeView openNewUrl:newUrl];
        [self hideMenuViewController];
        kAppDelegate.pushPerformed = YES;

/*
        if ([kAppDelegate.pushResponse hasPrefix:@"n"])
        {
            NSString *newUrl = [NSString stringWithFormat:@"%@%@", @G_serverurl, [kAppDelegate.pushResponse substringFromIndex:1]];
            HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
            [homeView openNewUrl:newUrl];
            [self hideMenuViewController];
            kAppDelegate.pushPerformed = YES;
        }
        else if ([kAppDelegate.pushResponse hasPrefix:@"f"])
        {
            NSString *newUrl = [kAppDelegate.pushResponse substringFromIndex:1];
            HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
            [homeView openNewUrl:newUrl];
            [self hideMenuViewController];
            kAppDelegate.pushPerformed = YES;
        }
        else if ([kAppDelegate.pushResponse hasPrefix:@"w"])
        {
            HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
            [homeView moveToPageViewController:1 removeAllSubviews:YES];
            [self hideMenuViewController];
            kAppDelegate.pushPerformed = YES;
        }
 */
    }
}

- (void)receiveRemote:(NSNotification *)notification
{
    [self performPushNotification];
}

- (void)weekReportClicked:(NSNotification *)notification
{
    [self gotoViewInHomeView:1];
}

- (void)notificationClicked:(NSNotification *)notification
{
    [self gotoViewInHomeView:2];
}

- (void)latestNewsClicked:(NSNotification *)notification
{
    [self gotoViewInHomeView:0];
}

- (void)registerClicked:(NSNotification *)notification
{
    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
    [homeView showSignupView];
    [self hideMenuViewController];
}

- (void)openNewUrl:(NSNotification *)notification
{
    NSString *newUrl = notification.userInfo[@"newurl"];
    NSLog(@"%@", newUrl);
    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
    [homeView openNewUrl:newUrl];
    [self hideMenuViewController];
}

- (void)performLogin:(NSNotification *)notification
{
    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
    [homeView showLoginView];
    [self hideMenuViewController];
}

- (void)playYoutube:(NSNotification *)notification
{
    NSString *videoId = notification.userInfo[@"videoid"];
    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
    [homeView playYoutubeVideo:videoId];
    [self hideMenuViewController];
}

- (void)otherViewClicked:(NSNotification *)notification
{
    NSInteger index = [notification.userInfo[@"Index"] integerValue];
    
    NSString *url = @"";
    NSString *title = @"";
    
    switch (index) {
        case 0:
        {
            title = @"home";
        }
            break;
        case 1:
        {
            url = @G_records;
            title = NSLocalizedString(@"profile", nil);
        }
            break;
            
        case 2:
        {
            url = @G_prediction;
            title = NSLocalizedString(@"activity", nil);
        }
            break;
            
        case 3:
        {
            url = @G_services;
            title = NSLocalizedString(@"schedule", nil);
            
        }
            break;
        case 4:
        {
            url = @G_services;
            title = NSLocalizedString(@"messenger", nil);
            
        }
            break;
        case 5:
        {
            url = @G_services;
            title = NSLocalizedString(@"whatsup", nil);
            
        }
            break;
        case 6:
        {
            url = @G_services;
            title = NSLocalizedString(@"peers", nil);
            
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
    url = @G_uploadertesturl;
    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
//    [homeView showOtherView:title url:url];
    
    [homeView external_call:title];
    [self hideMenuViewController];
}

- (void)logined:(NSNotification *)notification
{
    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
    [homeView showMainPageMenu];
    [leftView showLeftHeaderView];
    [leftView reloadTableView];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataString = [NSString stringWithFormat:@"uid=%@&nid=%@&device=iphone", kAppDelegate.userEmail, kAppDelegate.deviceTokenId];
        dataString = [[AES sharedInstance] encrypt:dataString];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [[ApiClient sharedInstance] getDataWithPost:@G_mapuserurl parameters:@{@"param":dataString} success:^(id responseObject) {
                NSString* newStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"%@", newStr);
            } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
                NSLog(@"%@ error: %@", @G_mapuserurl, errorString);
            }];
        });
    });
}

- (void)logouted:(NSNotification *)notification
{
    kAppDelegate.userEmail = @"";
    kAppDelegate.userName = @"";
    kAppDelegate.userPhoto = @"";

    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
//    [homeView showMainPageMenu];
    [leftView showLeftHeaderView];
    [leftView reloadTableView];
    
}
/*
- (void)showLevel2:(NSNotification *)notification
{
    NSString *datatable = notification.userInfo[@"datatable"];
    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
    [homeView showLevel2:@"https://dev.adiai.com:8441/datatable_level2.php" datatable:datatable];    
}

- (void)showLevel3:(NSNotification *)notification
{
    NSString *datatable = notification.userInfo[@"datatable"];
    HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
    [homeView showLevel3:@"https://dev.adiai.com:8441/datatable_level3.php" datatable:datatable];
}

*/

- (void)updateLeftMenu:(NSNotification *)notification
{
 //   HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
 //   [homeView showMainPageMenu];
    [leftView showLeftHeaderView];
    [leftView reloadTableView];
}

- (void)updateDeviceTokenToJs:(NSNotification *)notification
{
       HomeViewController *homeView = (HomeViewController *)[homeNav.viewControllers firstObject];
       [homeView updateDeviceTokenToJs];
}

@end
