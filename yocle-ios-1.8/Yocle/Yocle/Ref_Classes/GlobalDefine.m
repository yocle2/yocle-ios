//
//  GlobalDefine.m
//  Emome
//
//  Created by Admin on 11/3/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "GlobalDefine.h"

@implementation GlobalDefine

+ (void)setRounded:(UIView *)view color:(UIColor *)color rate:(CGFloat)rate
{
    view.layer.cornerRadius = view.frame.size.height / rate;
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = color.CGColor;
    view.clipsToBounds = YES;
}

+ (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString *)imagesDocumentsDirectory
{
    NSString *basePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"ImageResources"];
    return basePath;
}

+ (NSString *)voicesDocumentsDirectory
{
    NSString *basePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"VoiceResources"];
    return basePath;
}

// Get image from app documenets that already saved there
+ (UIImage *)getImageWithName:(NSString *)imageName
{
    NSString *basePath = [[self imagesDocumentsDirectory] stringByAppendingFormat:@"/%@", imageName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:basePath])
    {
        UIImage *receivedImage = [UIImage imageWithContentsOfFile:basePath];
        return receivedImage;
    }
    return nil;
}

+ (NSString *)getImageUrl:(NSString *)imageName
{
    NSString *basePath = [[self imagesDocumentsDirectory] stringByAppendingFormat:@"/%@", imageName];
    
    return basePath;
}

+ (NSString *)getVoiceUrl:(NSString *)voiceName
{
    NSString *basePath = [[self voicesDocumentsDirectory] stringByAppendingFormat:@"/%@", voiceName];
    
    return basePath;
}

+ (BOOL)checkImageExist:(NSString *)imageName
{
    BOOL result = NO;
    NSString *basePath = [[self imagesDocumentsDirectory] stringByAppendingFormat:@"/%@", imageName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:basePath])
        result = YES;
    
    return result;
}

// Save image to application document
+ (BOOL)saveImageToAppDocument:(UIImage *)image name:(NSString *)name
{
    BOOL result = YES;
    NSString *basePath = [[self imagesDocumentsDirectory] stringByAppendingFormat:@"/%@", name];
    
    if (![UIImageJPEGRepresentation(image, 1.0) writeToFile:basePath atomically:NO])
    {
        NSLog(@"Write Error %@", basePath);
        result = NO;
    }
    
    return result;
}

// Delete image to application document
+ (BOOL)deleteImageInAppDocument:(NSString *)name
{
    BOOL result = YES;
    NSString *basePath = [[self imagesDocumentsDirectory] stringByAppendingFormat:@"/%@", name];
    
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    if (![fileMgr removeItemAtPath:basePath error:&error])
    {
        NSLog(@"Remove Image File Error %@", basePath);
        result = NO;
    }
    
    return result;
}

+ (BOOL)deleteVoiceInAppDocument:(NSString *)name
{
    BOOL result = YES;
    NSString *basePath = [[self voicesDocumentsDirectory] stringByAppendingFormat:@"/%@", name];
    
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    if (![fileMgr removeItemAtPath:basePath error:&error])
    {
        NSLog(@"Remove Image File Error %@", basePath);
        result = NO;
    }
    
    return result;
}

// Create image resource directory in application document
+ (void)createImagesResourceDirectory
{
    NSString *basePath = [self imagesDocumentsDirectory];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:basePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:NO attributes:nil error:&error];
}

// Create image resource directory in application document
+ (void)createVoicesResourceDirectory
{
    NSString *basePath = [self voicesDocumentsDirectory];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:basePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:NO attributes:nil error:&error];
}

+ (NSString *)toStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy-hh-mm-ss-a"];
    
    //Optionally for time zone conversions
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)toDayStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE d MMM yyyy"];
    
    //Optionally for time zone conversions
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)toTimeStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm a"];
    
    //Optionally for time zone conversions
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSDate *)toDateFromString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy-hh-mm-ss-a"];
    
    //Optionally for time zone conversions
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (NSString *)toDatabaseDateStringFromDate:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

+ (NSDate *)toDateFromDatabaseDateString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (NSInteger)getDurationAsNumber:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSTimeInterval secs = [endDate timeIntervalSinceDate:startDate] * 1000;
    
    return secs;
}

+ (NSString *)getDurationAsString:(NSTimeInterval)secs
{
    NSString *sb = [[NSString alloc] init];
    int dur = (int)(secs / 1000);
    if (dur == 0)
        return @"0";
    
    int hrs = 0;
    int min = 0;
    if (dur > 3600)
    {
        hrs = dur / 3600;
        dur -= hrs * 3600;
    }
    if (dur > 60)
    {
        min = dur / 60;
        dur -= min * 60;
    }
    if (hrs > 0)
    {
        sb = [sb stringByAppendingFormat:@"%d", hrs];
    }
    if (min > 0)
    {
        sb = [sb stringByAppendingFormat:@".%1ld", (long)(min * 10 / 60.0f)];
    }
    //    if (dur > 0)
    //    {
    //        sb = [sb stringByAppendingFormat:@"%ds", dur];
    //    }
    
    if (sb.length == 0)
        sb = @"0";
    
    return sb;
}

+ (NSString *)getDurationAsString:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSTimeInterval secs = [endDate timeIntervalSinceDate:startDate] * 1000;
    return [self getDurationAsString:secs];
}

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a bitmap context.
    UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

+ (void)showAnimationFromBottom:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.y = frame.size.height;
    view.frame = frame;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = view.frame;
        frame.origin.y = 0;
        view.frame = frame;
    } completion:^(BOOL finished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONVIEWSHOWCOMPLETE object:nil];
    }];
}

+ (void)removeAnimationToBottom:(UIView *)view
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = view.frame;
        frame.origin.y += frame.size.height;
        view.frame = frame;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

+ (void)showAnimationFromTop:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.y -= frame.size.height / 2.0;
    view.frame = frame;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = view.frame;
        frame.origin.y += frame.size.height / 2.0;
        view.frame = frame;
    } completion:^(BOOL finished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONVIEWSHOWCOMPLETE object:nil];
    }];
}

+ (void)removeAnimationToTop:(UIView *)view
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = view.frame;
        frame.origin.y -= frame.size.height / 2.0;
        view.frame = frame;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONVIEWREMOVECOMPLETE object:nil];
    }];
}

+ (void)showAnimationFromTop1:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.y -= frame.size.height;
    view.frame = frame;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = view.frame;
        frame.origin.y += frame.size.height;
        view.frame = frame;
    } completion:^(BOOL finished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONVIEWSHOWCOMPLETE object:nil];
    }];
}

+ (void)removeAnimationToTop1:(UIView *)view
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = view.frame;
        frame.origin.y -= frame.size.height;
        view.frame = frame;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONVIEWREMOVECOMPLETE object:nil];
    }];
}

+ (void)showAnimationFromRight:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.x += frame.size.width;
    view.frame = frame;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = view.frame;
        frame.origin.x = 0;
        view.frame = frame;
    } completion:^(BOOL finished) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONVIEWSHOWCOMPLETE object:nil];
    }];
}

+ (void)removeAnimationToRight:(UIView *)view
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = view.frame;
        frame.origin.x += frame.size.width;
        view.frame = frame;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONVIEWREMOVECOMPLETE object:nil];
    }];
}

+ (void)showAnimationWithAlpha:(UIView *)view
{
    view.alpha = 0;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        view.alpha = 0.6;
    } completion:^(BOOL finished) {
    }];
}

+ (void)removeAnimationWithAlpha:(UIView *)view
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

+ (NSString *)hexStringFromColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    // #RGB
    alpha = 1.0f;
    red   = [self colorComponentFrom: colorString start: 0 length: 2];
    green = [self colorComponentFrom: colorString start: 2 length: 2];
    blue  = [self colorComponentFrom: colorString start: 4 length: 2];
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (void)getCookies
{
    BOOL success = NO;
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:@"adiainvli"])
        {
            success = YES;
            [NSUserDefaults saveLoginedCookie:cookie];
            break;
        }
    }
    
    if (!success)
        [NSUserDefaults saveLoginedCookie:nil];
}

+ (void)checkCookies
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        NSLog(@"%@", cookie);
    }
}

+ (void)deleteCookies
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:@"adiainvli"])
            [cookieJar deleteCookie:cookie];
    }
}
/*
+ (void)injectJavascript:(NSString *)resource webView:(UIWebView *)webView
{
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:resource ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:NULL];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
}
*/
@end
