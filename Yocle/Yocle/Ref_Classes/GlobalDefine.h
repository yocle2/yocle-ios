//
//  GlobalDefine.h
//  Emome
//
//  Created by Admin on 11/3/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalDefine : NSObject

+ (void)setRounded:(UIView *)view color:(UIColor *)color rate:(CGFloat)rate;
+ (UIImage *)getImageWithName:(NSString *)imageName;
+ (NSString *)getImageUrl:(NSString *)imageName;
+ (NSString *)getVoiceUrl:(NSString *)voiceName;
+ (BOOL)checkImageExist:(NSString *)imageName;
+ (BOOL)saveImageToAppDocument:(UIImage *)image name:(NSString *)name;
+ (BOOL)deleteImageInAppDocument:(NSString *)name;
+ (BOOL)deleteVoiceInAppDocument:(NSString *)name;
+ (void)createImagesResourceDirectory;
+ (void)createVoicesResourceDirectory;
+ (NSString *)toStringFromDate:(NSDate *)date;
+ (NSString *)toDayStringFromDate:(NSDate *)date;
+ (NSString *)toTimeStringFromDate:(NSDate *)date;
+ (NSDate *)toDateFromString:(NSString *)dateString;
+ (NSString *)toDatabaseDateStringFromDate:(NSDate *)date;
+ (NSDate *)toDateFromDatabaseDateString:(NSString *)dateString;
+ (NSInteger)getDurationAsNumber:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSString *)getDurationAsString:(NSTimeInterval)secs;
+ (NSString *)getDurationAsString:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (void)showAnimationFromBottom:(UIView *)view;
+ (void)removeAnimationToBottom:(UIView *)view;
+ (void)showAnimationFromTop:(UIView *)view;
+ (void)removeAnimationToTop:(UIView *)view;
+ (void)showAnimationFromTop1:(UIView *)view;
+ (void)removeAnimationToTop1:(UIView *)view;
+ (void)showAnimationFromRight:(UIView *)view;
+ (void)removeAnimationToRight:(UIView *)view;
+ (void)showAnimationWithAlpha:(UIView *)view;
+ (void)removeAnimationWithAlpha:(UIView *)view;
+ (NSString *)hexStringFromColor:(UIColor *)color;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (void)getCookies;
+ (void)checkCookies;
+ (void)deleteCookies;
+ (void)injectJavascript:(NSString *)resource webView:(UIWebView *)webView;

@end
