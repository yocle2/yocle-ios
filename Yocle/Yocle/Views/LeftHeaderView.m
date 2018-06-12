
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
    self = [super initWithFrame:frame];
    
    if (self)
    {
        BOOL logined = kAppDelegate.logined;
        
        if (logined)
            self.backgroundColor = [UIColor colorWithRed:89.0/255.0 green:131.0/255.0 blue:182.0/255.0 alpha:1.0];
        else
            self.backgroundColor = AIDACOLOR2;
        
        
        // bottom view
//        self.bottomView = [UIView newAutoLayoutView];
        /*
        if (logined)
            self.bottomView.backgroundColor = AIDACOLOR4;
        else
            self.bottomView.backgroundColor = AIDACOLOR3;
        
        self.weekCastButton = [UIButton newAutoLayoutView];
        [self.weekCastButton setBackgroundImage:[UIImage imageNamed:@"ic_weeklyreport"] forState:UIControlStateNormal];
        [self.weekCastButton addTarget:self action:@selector(weekCastClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.weekCastLabel = [UILabel newAutoLayoutView];
        [self.weekCastLabel setText:NSLocalizedString(@"每週預測", nil)];
        self.weekCastLabel.backgroundColor = [UIColor clearColor];
        self.weekCastLabel.textColor = [UIColor whiteColor];
        self.weekCastLabel.textAlignment = NSTextAlignmentCenter;
        
        self.newsButton = [UIButton newAutoLayoutView];
        [self.newsButton setBackgroundImage:[UIImage imageNamed:@"ic_newtrend"] forState:UIControlStateNormal];
        [self.newsButton addTarget:self action:@selector(newsClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.newsLabel = [UILabel newAutoLayoutView];
        [self.newsLabel setText:NSLocalizedString(@"最新消息", nil)];
        self.newsLabel.backgroundColor = [UIColor clearColor];
        self.newsLabel.textColor = [UIColor whiteColor];
        self.newsLabel.textAlignment = NSTextAlignmentCenter;
        */
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
           // self.memberRegisterContent.font = [UIColor blackColor];
//            self.memberRegisterContent.font = [UIFont systemFontOfSize:8.0f];
            self.memberRegisterContent.textAlignment = NSTextAlignmentLeft;
        }
        else
        {
            self.userImage = [NZCircularImageView newAutoLayoutView];
            [self.userImage setImageWithResizeURL:kAppDelegate.userPhoto usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            
//            [self.userImage setImageWithResizeURL:@"https://videoboard.hk/people/m10.jpg" usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            
          //  self.userImage.contentMode = UIViewContentModeScaleAspectFit;
            
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
        
    //    [self addSubview:self.bottomView];
        
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
           // [self addSubview:self.paidMemberLabel];
        }
        
    //    [self.bottomView addSubview:self.weekCastButton];
    //    [self.bottomView addSubview:self.weekCastLabel];
    //    [self.bottomView addSubview:self.newsButton];
    //    [self.bottomView addSubview:self.newsLabel];
        
        [self updateFonts];
    }
    
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints)
    {
        
  //      CGFloat bottomViewHeight = 10.0f; // 70.0f;
  //      CGFloat buttomButtonHeight = 30.0f;
        CGFloat userImageWidthHeight = 90.0f;
        CGFloat buttonVerticalInsets = (kViewWidth > kViewHeight) ? kViewHeight : kViewWidth;
        
        // bottom view ///////////////////////////////////////
        /*
        [self.bottomView autoSetDimension:ALDimensionHeight toSize:bottomViewHeight relation:NSLayoutRelationEqual];
        [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0.0f];
        [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0.0f];
        [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
         */
  /*
        // week cast button
        [self.weekCastButton autoSetDimension:ALDimensionHeight toSize:buttomButtonHeight relation:NSLayoutRelationEqual];
        [self.weekCastButton autoSetDimension:ALDimensionWidth toSize:buttomButtonHeight relation:NSLayoutRelationEqual];
        [self.weekCastButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bottomView withOffset:10.0f];
        [self.weekCastButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.bottomView withOffset:buttonVerticalInsets / 4.0f - 25.0f];
        
        // week cast label
        [self.weekCastLabel autoSetDimension:ALDimensionHeight toSize:20.0f relation:NSLayoutRelationEqual];
        [self.weekCastLabel autoSetDimension:ALDimensionWidth toSize:100.0f relation:NSLayoutRelationEqual];
        [self.weekCastLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bottomView withOffset:-10.0f];
        [self.weekCastLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.weekCastButton];
        
        // news button
        [self.newsButton autoSetDimension:ALDimensionHeight toSize:buttomButtonHeight relation:NSLayoutRelationEqual];
        [self.newsButton autoSetDimension:ALDimensionWidth toSize:buttomButtonHeight relation:NSLayoutRelationEqual];
        [self.newsButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bottomView withOffset:10.0f];
        [self.newsButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.bottomView withOffset:-(buttonVerticalInsets / 4.0f - 25.0f)];
        
        // news label
        [self.newsLabel autoSetDimension:ALDimensionHeight toSize:20.0f relation:NSLayoutRelationEqual];
        [self.newsLabel autoSetDimension:ALDimensionWidth toSize:100.0f relation:NSLayoutRelationEqual];
        [self.newsLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bottomView withOffset:-kLabelVerticalInsets];
        [self.newsLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.newsButton];
  */
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
/*
            [self.userImage autoSetDimension:ALDimensionWidth toSize:userImageWidthHeight relation:NSLayoutRelationEqual];
            [self.userImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomView withOffset:5.0f];
            [self.userImage autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:5.0f];
            [self.userImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
*/
            
            
            [self.userImage autoSetDimension:ALDimensionWidth toSize:userImageWidthHeight relation:NSLayoutRelationEqual];
            [self.userImage autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:5.0f];
            [self.userImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [self.userImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            
            
            [self.userNameLabel autoSetDimension:ALDimensionHeight toSize:30.0f relation:NSLayoutRelationEqual];
            [self.userNameLabel autoSetDimension:ALDimensionWidth toSize:160.0f relation:NSLayoutRelationEqual];
            [self.userNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImage withOffset:25.0f];
            [self.userNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImage withOffset:30.0f];
            
    //        [self.paidMemberLabel autoSetDimension:ALDimensionHeight toSize:30.0f relation:NSLayoutRelationEqual];
    //        [self.paidMemberLabel autoSetDimension:ALDimensionWidth toSize:80.0f relation:NSLayoutRelationEqual];
    //        [self.paidMemberLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.userImage withOffset:0.0f];
    //        [self.paidMemberLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImage withOffset:10.0f];
        }
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)updateFonts
{
  //  self.weekCastLabel.font = [UIFont systemFontOfSize:13.0f];
  //  self.newsLabel.font = [UIFont systemFontOfSize:13.0f];
    
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
     //   self.paidMemberLabel.font = [UIFont systemFontOfSize:18.0f];
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
