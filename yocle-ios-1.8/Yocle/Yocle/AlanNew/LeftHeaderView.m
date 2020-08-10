
#import "LeftHeaderView.h"
//#import "UIImageView+AFNetworking.h"


#define kLabelHorizontalInsets      15.0f
#define kLabelVerticalInsets        10.0f

@interface LeftHeaderView ()
{
}

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation LeftHeaderView

- (id)initWithFrame:(CGRect)frame
{
    //return 0; // added alantypoon 20190318
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        BOOL logined = kAppDelegate.logined;
        
        if (logined)
            self.backgroundColor = [UIColor colorWithRed:89.0/255.0 green:131.0/255.0 blue:182.0/255.0 alpha:1.0];
        else
            self.backgroundColor = AIDACOLOR2;
        
        
        // top view
        if (!logined)
        {
            self.memberAreaLabel = [UILabel newAutoLayoutView];
            [self.memberAreaLabel setText:NSLocalizedString(@"member zone", nil)];
            self.memberAreaLabel.backgroundColor = [UIColor clearColor];
            self.memberAreaLabel.textColor = AIDACOLOR3;
            self.memberAreaLabel.textAlignment = NSTextAlignmentLeft;
            
            self.memberRegisterButton = [UIButton newAutoLayoutView];
            [self.memberRegisterButton setTitle:NSLocalizedString(@"sign up", nil) forState:UIControlStateNormal];
            self.memberRegisterButton.backgroundColor = AIDACOLOR3;
            self.memberRegisterButton.titleLabel.textColor = [UIColor whiteColor];
            [self.memberRegisterButton addTarget:self action:@selector(memberRegisterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            self.memberRegisterButton.hidden = YES;
            
            self.memberRegisterContent = [UILabel newAutoLayoutView];
            [self.memberRegisterContent setText:NSLocalizedString(@"sign up for member", nil)];
            self.memberRegisterContent.backgroundColor = [UIColor clearColor];
            self.memberRegisterContent.textColor = [UIColor blackColor];
            self.memberRegisterContent.textAlignment = NSTextAlignmentLeft;
        }
        else
        {
            self.userImage = [NZCircularImageView newAutoLayoutView];
            [self.userImage setImageWithResizeURL:kAppDelegate.userPhoto usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            self.userNameLabel = [UILabel newAutoLayoutView];
            self.userNameLabel.text = kAppDelegate.userName;
            self.userNameLabel.backgroundColor = [UIColor clearColor];
            self.userNameLabel.textColor = [UIColor whiteColor];
            self.userNameLabel.textAlignment = NSTextAlignmentLeft;
       
            self.paidMemberLabel = [UILabel newAutoLayoutView];
            self.paidMemberLabel.text = NSLocalizedString(@"member", nil);
            self.paidMemberLabel.backgroundColor = [UIColor clearColor];
            self.paidMemberLabel.textColor = AIDACOLOR5;
            self.paidMemberLabel.textAlignment = NSTextAlignmentLeft;
        
        }
        
        if (!logined)
        {
            [self addSubview:self.memberAreaLabel];
            [self addSubview:self.memberRegisterButton];
            [self addSubview:self.memberRegisterContent];
        }
        else
        {
            [self addSubview:self.userImage];
            [self addSubview:self.userNameLabel];
        }
        
        [self updateFonts];
    }
    
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints)
    {
        CGFloat userImageWidthHeight = 90.0f;
        CGFloat buttonVerticalInsets = (kViewWidth > kViewHeight) ? kViewHeight : kViewWidth;
        
        // top view ////////////////////////////////////////////
        BOOL logined = kAppDelegate.logined;
        
        if (!logined)
        {
            [self.memberRegisterButton autoSetDimension:ALDimensionHeight toSize:40.0f relation:NSLayoutRelationEqual];
            [self.memberRegisterButton autoSetDimension:ALDimensionWidth toSize:buttonVerticalInsets / 3.0f relation:NSLayoutRelationEqual];
            [self.memberRegisterButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelVerticalInsets];
            [self.memberRegisterButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
            
            [self.memberAreaLabel autoSetDimension:ALDimensionHeight toSize:30.0f relation:NSLayoutRelationEqual];
            [self.memberAreaLabel autoSetDimension:ALDimensionWidth toSize:160.0f relation:NSLayoutRelationEqual];
            [self.memberAreaLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelVerticalInsets];
            [self.memberAreaLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.memberRegisterButton];
            
            [self.memberRegisterContent autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.memberRegisterButton withOffset:kLabelVerticalInsets];
            [self.memberRegisterContent autoSetDimension:ALDimensionHeight toSize:30.0f relation:NSLayoutRelationEqual];
            [self.memberRegisterContent autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelVerticalInsets];
            [self.memberRegisterContent autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelVerticalInsets];
            [self.memberRegisterContent setFont: [self.memberRegisterContent.font fontWithSize: 11]];
        }
        else
        {
            // after logined
            [self.userImage autoSetDimension:ALDimensionHeight toSize:userImageWidthHeight relation:NSLayoutRelationEqual];
            [self.userImage autoSetDimension:ALDimensionWidth toSize:userImageWidthHeight relation:NSLayoutRelationEqual];
            [self.userImage autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:5.0f];
            [self.userImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [self.userImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            
            
            [self.userNameLabel autoSetDimension:ALDimensionHeight toSize:30.0f relation:NSLayoutRelationEqual];
            [self.userNameLabel autoSetDimension:ALDimensionWidth toSize:160.0f relation:NSLayoutRelationEqual];
            [self.userNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImage withOffset:25.0f];
            [self.userNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImage withOffset:30.0f];
        }
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)updateFonts
{
    
    BOOL logined = kAppDelegate.logined;
    if (!logined)
    {
        self.memberAreaLabel.font = [UIFont systemFontOfSize:19.0f];
        self.memberRegisterContent.font = [UIFont systemFontOfSize:13.0f];
        self.memberRegisterButton.titleLabel.font = [UIFont systemFontOfSize:19.0f];
    }
    else
    {
        self.userNameLabel.font = [UIFont systemFontOfSize:18.0f];
    }
}

- (void)weekCastClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWeekReportClicked object:nil];
}

- (void)newsClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNotificationClicked object:nil];
}

- (void)memberRegisterButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRegisterClicked object:nil];
}

@end
