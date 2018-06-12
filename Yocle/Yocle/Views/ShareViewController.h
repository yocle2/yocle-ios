//
//  ShareViewController.h
//  
//
//  Created by Charles Moon on 1/7/16.
//
//

#import <UIKit/UIKit.h>

@protocol ShareViewControllerDelegate;

@interface ShareViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UITextView *shareContent;

@property (nonatomic, strong) NSDictionary *shareData;
@property (nonatomic, strong) id<ShareViewControllerDelegate> delegate;
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;

@end

@protocol ShareViewControllerDelegate <NSObject>
@optional
- (void)backedWithCancelButton:(ShareViewController *)viewController;

@end