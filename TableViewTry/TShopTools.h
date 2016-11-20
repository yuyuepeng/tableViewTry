//
//  TShopTools.h
//  TTShop
//
//  Created by 扶摇先生 on 16/7/21.
//  Copyright © 2016年 扶摇先生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TShopHeader.h"
#import "TShopSellerInfoModel.h"

UIKIT_EXTERN NSString *const MRAlipayPartner;//合作id

UIKIT_EXTERN NSString *const MRAlipaySeller;//商户账户
UIKIT_EXTERN NSString *const MRAlipaySeller1;//商户账户
UIKIT_EXTERN NSString *const MRAlipayKey;
@interface TShopTools : NSObject
/**
 *  MD5加密
 *
 *  @param target 被加密
 *
 *  @return 加密后
 */
+ (NSString *)MD5Encryption:(id)target;
/**
 *  base64加密
 *
 *  @param text <#text description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)base64StringFromText:(NSString *)text;

+ (NSString *)textFromBase64String:(NSString *)base64;

/*!
 @brief 将字符串日期穿换成App标准日期
 */
+ (NSString *)converDateToDate:(NSString *)date;
/*!
 @brief 将字符串秒数穿换成App标准日期
 */

+ (NSString *)converTimeToDate:(NSTimeInterval )time;

//获得图片路径
+ (NSString *)getBundlePath: (NSString *) assetName;
+ (NSBundle *)getBundle;
//根据Data得到type值
+ (NSString *)mineTypeWithData:(NSData *)data;

+ (NSString *)uniqueString;
//清空sdwebimage缓存
+ (void)clearTmpPics;
//得到相应尺寸的图片
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
//是否为数字
+ (BOOL)isAllNum:(NSString *)string;
+ (BOOL)isPureInt:(NSString *)string;
+ (BOOL)isPureFloat:(NSString*)string;
+ (BOOL)isPureNumandCharacters:(NSString *)string;
//是否身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;
//是否护照号
+ (BOOL)validatePassPortIdentityCard: (NSString *)identityCard;
//是否手机号
+ (BOOL)isValidPhoneNumber:(NSString *)string;
+ (CGFloat)getMaxHeightWithFont:(UIFont *)font width:(CGFloat)width content:(NSString *)content;
//是否合法邮箱
+ (BOOL)isValidateEmail:(NSString *)email;
//是否包含非法字符
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;
//判断字数限制
+ (BOOL)checkStringLimitWithContent:(NSString *)content length:(NSInteger)length;
+ (NSString *)changeToJasonWithArray:(id)array;
//获取用户店铺详状态
+ (void)getSellerCondition:(void (^)(NSArray<TShopSellerInfoModel *>* condition))conditionBlock WithUserId:(NSString *)userId ;
//根据用户userId获取主播店铺的sellerId
+ (void)getAnchorSellerId:(void (^)(NSString *anchorSellerId))anchorSellerIdBlock WithUserId:(NSString *)userId;
//使图片满屏size
+ (CGSize)changeMainScreenSizeWithImage:(UIImage *)image;
+ (UIWindow *)getValidWindow;
@end
