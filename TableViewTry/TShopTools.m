//
//  TShopTools.m
//  TTShop
//
//  Created by 扶摇先生 on 16/7/21.
//  Copyright © 2016年 扶摇先生. All rights reserved.
//

#import "TShopTools.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonCryptor.h>
#import "TShopExpressModel.h"
#import <AddressBook/AddressBook.h>
#import "TShopFloatWindow.h"
#import "UIImageView+WebCaches.h"
NSString *const MRAlipayPartner = @"2088711358428476";//合作id

NSString *const MRAlipaySeller = @"zhaiyaogang@itzl.org";//商户账户
NSString *const MRAlipayKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAMDgPQYC+oJDU+o5CsPzjTnrx5pEYzX3xh+sP+mHkyVJtRPAAmDL75V6jWnMtlf0Mm43szQ/3nG/niPGWKIxAUkt2Sv76DT7BFyReIgcujmaOvNM7VKI2MqcVvGHWrsxf0ck4HnaJ7TQyGyLOdZOfojDp0UrLFZXszovlTf+6D2TAgMBAAECgYBNFVFOJcKYbPAMm9+BkMTQcTrEnLBJ0UyNO/oPCu/z5xFHY2WP6fFGfEQoFHiLjjzZb8lfCGeOblZ1Vb/2kj9Anj7U0/zIsvlfLF2l78F6Ed3Qj5a1vUexSA9yu+/5udSrmpBexa7yDzC5a7O7WQDqW7vp96bi0dl+RUhnndSpAQJBAOHl28i+LMJQ9VBSvcWKQJb+96rKR2DOYN3dAoC8/mVJ0s+iI/E7EbWkfTCTEPjPgnSdUvPH9ZJN8Bu4kMuJvMkCQQDak+OkXsQKZBiJlZUKBI7zrN5CM+GE9Siw3SG9PunljwJWOJ1RaTL/RuF4jG3yurh2Yt9qXWUQfu9jFUtXr8F7AkBDEb35kg0z/Fl5abeSaQPYUQcznC8pHN1Bwha2JmbZp9uBbkCBpOoTJi1NOLz3QpUXDobMfnf44k8BzAChjdmRAkAg7nszvptmvWH9CK5lzf4DtJ3f95UYxR8WVprIunve/Ebr2qfJJkJqt7EsymueUIeOPqNOkTey3o0OrpylX3OVAkAfeUqtxO0sdJsmnSTen2VeChWHkmQteVVb/aXPTRu/rVfaxvyVrw76jRvh2bIJlSJdWS4wSI5poL+CM9CGJXsS";
#define BUNDLE_NAME @"TShopimage"
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

#import "TShopRequestManager.h"
@implementation TShopTools

+ (NSString *)MD5Encryption:(id)target {
    const char *cStr;
    if ([target isKindOfClass:[NSString class]]) {
        cStr = [target UTF8String];
    } else if ([target isKindOfClass:[NSData class]]) {
        cStr = [target bytes];
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:@""]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return @"";
    }
}
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}
+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:@""]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return @"";
    }
}

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
+ (NSBundle *)getBundle{
    return [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: BUNDLE_NAME ofType: @"bundle"]];
}
+ (NSString *)getBundlePath: (NSString *) assetName{
    
    NSBundle *myBundle = [TShopTools getBundle];
    //NSLog(@"%@wode路径1",[myBundle resourcePath]);
    
    if (myBundle && assetName) {
       // NSLog(@"%@wode路径",[myBundle resourcePath]);
        
        NSString *path = [[myBundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", assetName]];
        //NSLog(@"%@wode路径3",path);
        
        return path;
    }
    
    return nil;
}

+ (BOOL)isValidPhoneNumber:(NSString *)string
{
    BOOL flag;
    if (string.length <= 0||string.length >11) {
        flag = NO;
        return flag;
    }
    NSString *regex = IS_PhoneNum;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}
//+ (BOOL)isPureNumandCharacters:(NSString *)string

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

+ (void)clearTmpPics {
    [[SDImageCaches sharedImageCache] clearDisk];
    [[SDImageCaches sharedImageCache] clearMemory];
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
+ (BOOL)checkStringLimitWithContent:(NSString *)content length:(NSInteger)length {
    if (CHECK_String(content)&&content.length <= length) {
        return YES;
    }else{
        return NO;
    }
    
}
+ (NSString *)changeToJasonWithArray:(id)array {
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jasonData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jasonData;
}
+ (void)getSellerCondition:(void (^)(NSArray<TShopSellerInfoModel *>* condition))conditionBlock WithUserId:(NSString *)userId {
    TShopSellerInfo *sellerInfo = [TShopSellerInfo shareSeller];
    sellerInfo.useId = userId;
    NSArray *kuaidi = @[@"顺丰快递",@"邮政EMS",@"圆通快递",@"申通快递",@"韵达快递",@"中通快递",@"天天快递"];
    NSArray *kuai = @[@"SF",@"EMS",@"YTO",@"STO",@"YD",@"ZTO",@"HHTT"];
    for (NSInteger i = 1; i < kuaidi.count + 1; i ++) {
        TShopExpressModel *model = [[TShopExpressModel alloc] init];
        if (![TShopExpressModel findByExpressid:[NSString stringWithFormat:@"%ld",(long)i]]) {
            model.expressId = [NSString stringWithFormat:@"%ld",(long)i];
            model.expName = kuaidi[i - 1];
            model.expCode = kuai[i - 1];
            [model save];
        }
    }

    TShopRequestManager *manager = [[TShopRequestManager alloc] init];
   __block NSArray *arr;
    [manager postWithDomain:TShopBaseUrl path:@"seller/selectSellerStatus.do" parameters:nil form:@{@"userId":userId} succeeded:^(NSInteger status, id response) {
        if (CHECK_Value(response)) {
            
            arr = [[NSArray alloc] initWithArray:response];
            NSMutableArray <TShopSellerInfoModel *>*sliderTitles = [NSMutableArray array];
            TShopSellerInfoModel *slider = [[TShopSellerInfoModel alloc] init];
            slider.title = @"TT商城";
            [sliderTitles addObject:slider];
            TShopSellerInfoModel *slider1 = [[TShopSellerInfoModel alloc] init];
            TShopSellerInfoModel *slider2 = [[TShopSellerInfoModel alloc] init];;
            for (NSInteger i = 0; i < arr.count; i ++) {
                NSDictionary *first = [[NSDictionary alloc] initWithDictionary:arr[i]];
                NSString *isAnchor = [NSString stringWithFormat:@"%@",first[@"isAnchor"]];
                NSString *status = [NSString stringWithFormat:@"%@",first[@"status"]];
                if ([isAnchor isEqualToString:@"0"]) {
                    if ([status isEqualToString:@"0"]) {
                        if (CHECK_Value(first[@"sellerId"])) {
                        sellerInfo.anchorSellerId = [NSString stringWithFormat:@"%@",first[@"sellerId"]];
                            slider1.anchorSellerId = [NSString stringWithFormat:@"%@",first[@"sellerId"]];
                            [manager postWithDomain:TShopBaseUrl path:@"seller/selectSeller.do" parameters:nil form:@{@"sellerId":sellerInfo.anchorSellerId} succeeded:^(NSInteger status, id response) {
                                if (response) {
                                    sellerInfo.anchorSellerName = [NSString stringWithFormat:@"%@",[response objectForKey:@"sellerName"]];
                                    sellerInfo.anchorSellerLogo = [NSString stringWithFormat:@"%@",[response objectForKey:@"logoUrl"]];
                                }
                                
                            } fail:^(NSInteger failStatus, NSString *error) {
                                
                            }];
                        }
                        slider1.title = @"主播店铺";
                    }else if ([status isEqualToString:@"1"]) {
                        slider1.title = @"我要开通主播店铺（已驳回）" ;
                    }else if ([status isEqualToString:@"2"]) {
                        slider1.title = @"我要开通主播店铺（审核中）" ;
                    }else if ([status isEqualToString:@"3"]) {
                        slider1.title =@"我要开通主播店铺" ;
                    }
                }
                if ([isAnchor isEqualToString:@"1"]) {
                    if ([status isEqualToString:@"0"]) {
                        slider2.title = @"我是商家";
                        if (CHECK_Value(first[@"sellerId"])) {
                            sellerInfo.sellId = [NSString stringWithFormat:@"%@",first[@"sellerId"]];
                            slider2.sellId = [NSString stringWithFormat:@"%@",first[@"sellerId"]];
                            [manager postWithDomain:TShopBaseUrl path:@"seller/selectSeller.do" parameters:nil form:@{@"sellerId":sellerInfo.sellId} succeeded:^(NSInteger status, id response) {
                                if (response) {
                                    sellerInfo.sellerName = [NSString stringWithFormat:@"%@",[response objectForKey:@"sellerName"]];
                                    sellerInfo.sellerLogo = [NSString stringWithFormat:@"%@",[response objectForKey:@"logoUrl"]];
                                }
                                
                            } fail:^(NSInteger failStatus, NSString *error) {

                            }];
                        }
                    }else if ([status isEqualToString:@"1"]) {
                        slider2.title =@"我要成为商家（已驳回）";
                    }else if ([status isEqualToString:@"2"]) {
                        slider2.title = @"我要成为商家（审核中）";
                    }else if ([status isEqualToString:@"3"]) {
                        slider2.title = @"我要成为商家";
                    }
                }
            }
            slider.resultcode = @"200";
            slider1.resultcode = @"200";
            slider2.resultcode = @"200";
            [sliderTitles addObject:slider2];
            [sliderTitles addObject:slider1];
            conditionBlock(sliderTitles);
        }
    } fail:^(NSInteger failStatus, NSString *error) {
        TShopSellerInfoModel *slider = [[TShopSellerInfoModel alloc] init];
        TShopSellerInfoModel *slider1 = [[TShopSellerInfoModel alloc] init];
        TShopSellerInfoModel *slider2 = [[TShopSellerInfoModel alloc] init];
        slider.title = @"TT商城";
        slider.resultcode = @"500";
        slider1.title = @"我要成为商家";
        slider2.title = @"我要开通主播店铺";
        slider1.resultcode = @"500";
        slider2.resultcode = @"500";
        NSArray<TShopSellerInfoModel *>* arr = @[slider,slider1,slider2];
        NSLog(@"获取状态失败，error %@",error);
        conditionBlock(arr);
    }];
}
+ (void)getAnchorSellerId:(void (^)(NSString *anchorSellerId))anchorSellerIdBlock WithUserId:(NSString *)userId {
    __block NSArray *arr;
    TShopRequestManager *manager = [[TShopRequestManager alloc] init];
    [manager postWithDomain:TShopBaseUrl path:@"seller/selectSellerStatus.do" parameters:nil form:@{@"userId":userId} succeeded:^(NSInteger status, id response) {
        if (CHECK_Value(response)) {
            arr = [[NSArray alloc] initWithArray:response];
            for (NSInteger i = 0; i < arr.count; i ++) {
                NSDictionary *first = [[NSDictionary alloc] initWithDictionary:arr[i]];
                NSString *isAnchor = [NSString stringWithFormat:@"%@",first[@"isAnchor"]];
                NSString *status = [NSString stringWithFormat:@"%@",first[@"status"]];
                if ([isAnchor isEqualToString:@"0"]) {
                    if ([status isEqualToString:@"0"]) {
                        if (CHECK_Value(first[@"sellerId"])) {
                        anchorSellerIdBlock([NSString stringWithFormat:@"%@",first[@"sellerId"]]);
                        }else {
                            anchorSellerIdBlock(nil);
                        }
                    }
                }
            }
        }
    } fail:^(NSInteger failStatus, NSString *error) {
        anchorSellerIdBlock(nil);
    }];
}
+ (CGSize)changeMainScreenSizeWithImage:(UIImage *)image {
    CGSize size = CGSizeMake(mainWidth, mainWidth/image.size.width * image.size.height);
    return size;
}
+ (UIWindow *)getValidWindow {
    
    for (NSInteger i = 0; i < [UIApplication sharedApplication].windows.count; i ++) {
        if (![[UIApplication sharedApplication].windows[i] isKindOfClass:[TShopFloatWindow class]]) {
            return [UIApplication sharedApplication].windows[i];
                    break;
        }
    }
    return nil;
}

@end
