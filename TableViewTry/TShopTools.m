//
//  TShopTools.m
//  TTShop
//
//  Created by 扶摇先生 on 16/7/21.
//  Copyright © 2016年 扶摇先生. All rights reserved.
//

#define mainWidth [UIScreen mainScreen].bounds.size.width
#import "TShopTools.h"

@implementation TShopTools


+ (NSString *)converDateToDate:(NSString *)date {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currenttime = [inputFormatter stringFromDate:[NSDate date]];
    NSString *timeFromDate = [inputFormatter stringFromDate:[inputFormatter dateFromString:[[date componentsSeparatedByString:@"."] firstObject]]];
    currenttime = [currenttime substringWithRange:NSMakeRange(0, 8)];
    timeFromDate = [timeFromDate substringWithRange:NSMakeRange(0, 8)];
    
    if ([timeFromDate isEqualToString:currenttime]) {
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
        return [timeFormatter stringFromDate:[inputFormatter dateFromString:[[date componentsSeparatedByString:@"."] firstObject]]];
    } else if([[timeFromDate substringWithRange:NSMakeRange(0, 6)] isEqualToString:[currenttime substringWithRange:NSMakeRange(0, 6)]])
    {
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:@"MM-dd"];
        NSString *firstStr = [date componentsSeparatedByString:@"."].firstObject;
        NSString *str = [monthFormatter stringFromDate:[inputFormatter dateFromString:firstStr]];
        return str;
    }else {
        NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *firstStr = [date componentsSeparatedByString:@"."].firstObject;
        NSString *str = [yearFormatter stringFromDate:[inputFormatter dateFromString:firstStr]];
        return str;
    }
}
+ (NSString *)converTimeToDate:(NSTimeInterval )time {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *date = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    return date;
}


+ (NSString *)mineTypeWithData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
        case 0x25:
            return @"application/pdf";
            break;
        case 0xD0:
            return @"application/vnd";
            break;
        case 0x46:
            return @"text/plain";
            break;
        default:
            return @"application/octet-stream";
    }
    return nil;
}
+ (NSString *)uniqueString {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef= CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *retStr = [NSString stringWithString:(__bridge NSString *)uuidStrRef];
    CFRelease(uuidStrRef);
    return retStr;
}

+ (BOOL)isAllNum:(NSString *)string {
    unichar c;
    for (int i = 0; i < string.length; i++) {
        c = [string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}
+ (BOOL)isPureInt:(NSString *)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }else {
        return YES;
    }
}
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
+ (BOOL)validatePassPortIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
//    NSString *regex2 = @"^[a-zA-Z]{5,17}$";
//    NSString *regex3 = @"^[a-zA-Z0-9]{5,17}$";
    NSString *regex3 = @"^1[45][0-9]{7}|G[0-9]{8}|P[0-9]{7}|S[0-9]{7,8}|D[0-9]+$";
//    NSPredicate *passPortPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    NSPredicate *passPortPredicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex3];
    return [passPortPredicate1 evaluateWithObject:identityCard];
}
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (CGFloat)getMaxHeightWithFont:(UIFont *)font width:(CGFloat)width content:(NSString *)content {
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size =CGSizeMake(width, CGFLOAT_MAX);
    // 获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize.height;
    //        NSLog(@"我家的自适应高度%f",actualsize.height);
}
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content {
    //提示 标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)changeToJasonWithArray:(id)array {
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jasonData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jasonData;
}
+ (CGSize)changeMainScreenSizeWithImage:(UIImage *)image {
    CGSize size = CGSizeMake(mainWidth, mainWidth/image.size.width * image.size.height);
    return size;
}


@end
