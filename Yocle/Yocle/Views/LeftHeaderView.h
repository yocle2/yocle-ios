
#import <UIKit/UIKit.h>
#import "NZCircularImageView.h"

@interface LeftHeaderView : UIView

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *weekCastButton;
@property (nonatomic, strong) UILabel *weekCastLabel;

@property (nonatomic, strong) UIButton *newsButton;
@property (nonatomic, strong) UILabel *newsLabel;

@property (nonatomic, strong) UILabel *memberAreaLabel;
@property (nonatomic, strong) UIButton *memberRegisterButton;
@property (nonatomic, strong) UILabel *memberRegisterContent;

//@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) NZCircularImageView *userImage;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *paidMemberLabel;

- (void)updateFonts;

@end
