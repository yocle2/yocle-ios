//
//  ShareViewController.m
//  
//
//  Created by Charles Moon on 1/7/16.
//
//


#import <CommonCrypto/CommonDigest.h>
#import "ShareViewController.h"

@interface ShareViewController () <FBSDKSharingDelegate, UIAlertViewDelegate, UIDocumentInteractionControllerDelegate>
{
    UIImage *toShareImage;
}

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScreenObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSInteger shareIndex = [MediaKind indexOfObject:self.shareData[@"utm_medium"]];
    if (shareIndex > 0 && ![NSUserDefaults FBShareAlertShowed])
    {
        [NSUserDefaults saveFBShareAlertShowed:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Share Content will be copied to clipboard when you click share button", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)initScreenObjects
{
    NSLog(@"%@", self.shareData);
    
    [self.shareImage setImageWithURL:[NSURL URLWithString:self.shareData[@"imageurl"]] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        toShareImage = image;
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.shareContent.editable = YES;
    self.shareContent.text = [self.shareData[@"share_message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissSelf];
}

- (IBAction)shareButtonClicked:(id)sender
{
    NSInteger shareIndex = [MediaKind indexOfObject:self.shareData[@"utm_medium"]];
    
    if (shareIndex > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm Alert", nil) message:NSLocalizedString(@"Are you sure to share?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Share", nil), nil];
        alert.tag = shareIndex;
        [alert show];
    }
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (FBSDKShareLinkContent *)getShareLinkContentWithContentURL:(NSURL *)objectURL linkURL:(NSURL *)link
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = link;
    content.imageURL = objectURL;
    return content;
}

- (void)sendShareResult
{
/*
    NSDictionary *parameters = @{@"id":self.shareData[@"id"], @"source":self.shareData[@"utm_source"], @"medium":self.shareData[@"utm_medium"], @"campaign":self.shareData[@"utm_campaign"]};

    [[ApiClient sharedInstance] getDataWithPost:@shareresult parameters:parameters success:^(id responseObject) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"Share result: %@", json);
    } failure:^(AFHTTPRequestOperation *operation, NSString *errorString) {
        NSLog(@"%@ error: %@", @G_mapuserurl, errorString);
    }];
*/
}

- (void)directShare:(ShareType)shareType
{
    //1、构造分享内容
    //1.1、要分享的图片（以下分别是网络图片和本地图片的生成方式的示例）
    id<ISSCAttachment> remoteAttachment = [ShareSDKCoreService attachmentWithUrl:self.shareData[@"imageurl"]];
    
    //1.2、以下参数分别对应：内容、默认内容、图片、标题、链接、描述、分享类型
    id<ISSContent> publishContent = [ShareSDK content:self.shareContent.text
                                       defaultContent:nil
                                                image:remoteAttachment
                                                title:@"test title"
                                                  url:@"http://www.mob.com"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    //直接分享接口
    [ShareSDK shareContent:publishContent
                      type:shareType
               authOptions:nil
              shareOptions:nil
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        NSLog(@"=== response state :%zi ",state);
                        
                        //可以根据回调提示用户。
                        if (state == SSResponseStateSuccess)
                        {
                            [self sendShareResult];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                                            message:nil
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        else if (state == SSResponseStateFail)
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed", nil)
                                                                            message:[NSString stringWithFormat:NSLocalizedString(@"Error Description：%@", nil),[error errorDescription]]
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }];
}

#pragma FBSDKShareKit delegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    [self sendShareResult];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    
}

- (void)dismissSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backedWithCancelButton:)])
    {
        [self.delegate backedWithCancelButton:self];
    }
}

#pragma alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSInteger shareIndex = alertView.tag;
        
        switch (shareIndex) {
            case 1: // facebook
            {
                NSString *sid=[NSString stringWithFormat:@"%@", self.shareData[@"id"]];
                NSString *str2=[self md5:sid];
                NSString *str = [NSString stringWithFormat:@"%@/%@%@", @G_serverurl,str2, self.shareData[@"share_uri"]];
                
                
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.shareContent.text;
                [self dismissSelf];
                [FBSDKShareDialog showFromViewController:kAppDelegate.window.rootViewController
                                             withContent:[self getShareLinkContentWithContentURL:[NSURL URLWithString:self.shareData[@"imageurl"]] linkURL:[NSURL URLWithString:str]]
                                                delegate:self];
            }
                break;
                
            case 2: // whatsapp
            {
/*
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.shareContent.text;
                if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){
                    
                    UIImage     *iconImage = self.shareImage.image;
                    NSString    *savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.jpg"];
                    
                    [UIImageJPEGRepresentation(iconImage, 1.0) writeToFile:savePath atomically:YES];
                    
                    self.documentationInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
                    self.documentationInteractionController.UTI = @"public.image";
                    self.documentationInteractionController.delegate = self;
                    
                    [self.documentationInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
                } else {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WhatsApp not installed.", nil) message:NSLocalizedString(@"Your device has no WhatsApp installed.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles:nil];
                    [alert show];
                }
*/
                
                NSString *str1=@"whatsapp://send?text=";
                NSString *sid=[NSString stringWithFormat:@"%@", self.shareData[@"id"]];
                NSString *str2=[self md5:sid];
                NSString *str = [NSString stringWithFormat:@"%@%@ %@/%@%@", str1, self.shareContent.text, @G_serverurl,str2, self.shareData[@"share_uri"]];
                
                str=[NSString stringWithFormat:@"%@",[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSURL * url = [NSURL URLWithString:str];
                if ([[UIApplication sharedApplication] canOpenURL: url]) {
                    [[UIApplication sharedApplication] openURL: url];
                } else {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WhatsApp not installed.", nil) message:NSLocalizedString(@"Your device has no WhatsApp installed.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)  otherButtonTitles:nil];
                    [alert show];                }
                
            }
                break;
                
            case 3: // wechat
            {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.shareContent.text;
                [self dismissSelf];
                [self directShare:ShareTypeWeixiSession];
            }
                break;
                
            default:
            {
                
            }
                break;
        }
    }
}

- (void) documentInteractionController: (UIDocumentInteractionController *) controller willBeginSendingToApplication: (NSString *) application {
    [self dismissSelf];
}

@end
