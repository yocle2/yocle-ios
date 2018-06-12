
#import "LeftViewController.h"
#import "LeftHeaderView.h"

@interface LeftViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL performOnce;
    NSArray *dataSource;
    NSArray *imageDataSource;
    CGFloat screenWidth;
    LeftHeaderView *leftHeaderView;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [GlobalDefine colorWithHexString:@"f3f3f3"];
    
    performOnce = NO;
    dataSource = @[NSLocalizedString(@"home", nil), NSLocalizedString(@"profile", nil), NSLocalizedString(@"activity", nil), NSLocalizedString(@"schedule", nil), NSLocalizedString(@"messenger", nil), NSLocalizedString(@"whatsup", nil), NSLocalizedString(@"peers", nil), NSLocalizedString(@"logout", nil)];
    imageDataSource = @[@"ic_home", @"user", @"checkered-flag", @"calendar", @"messenger", @"whatsup", @"peers", @"power"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    if (!performOnce)
    {
        performOnce = YES;
        [self showLeftHeaderView];
    }
}

- (void)showLeftHeaderView
{
    [leftHeaderView removeFromSuperview];
    [leftHeaderView updateFonts];
    
    leftHeaderView = [[LeftHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kViewWidth, 100.0f)];
    self.tableView.tableHeaderView = leftHeaderView;
    [leftHeaderView setNeedsUpdateConstraints];
    [leftHeaderView updateConstraintsIfNeeded];
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (kAppDelegate.logined)
        return dataSource.count;
    else
    //    return dataSource.count - 1;
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIImageView *mainIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 4.0f, 36.0f, 36.0f)];
    mainIcon.image = [UIImage imageNamed:imageDataSource[indexPath.row]];
    mainIcon.image = [mainIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [mainIcon setTintColor:[GlobalDefine colorWithHexString:@"9e9e9e"]];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 0.0f, 150.0f, 44.0f)];
    textLabel.text = dataSource[indexPath.row];
    if(indexPath.row==0) textLabel.text = @"Home";
    cell.contentView.backgroundColor = [GlobalDefine colorWithHexString:@"f3f3f3"];
    
    [cell.contentView addSubview:mainIcon];
    [cell.contentView addSubview:textLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/*
    if (indexPath.row == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLatestNewsClicked object:nil];
    }
    else if (indexPath.row == dataSource.count - 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPerformLogout object:nil];
    }
*/
    if (indexPath.row == dataSource.count - 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPerformLogout object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOtherViewClicked object:nil userInfo:@{@"Index":@(indexPath.row)}];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    
    // If you are not using ARC:
    // return [[UIView new] autorelease];
}
@end
