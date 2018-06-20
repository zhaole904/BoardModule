//
//  CMImageUtil.h
//  CMCore
//
//  Created by PengTao on 2017/12/15.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#if __has_include(<UIKit/UIImage.h>) && __has_include(<UIKit/UIView.h>)

#import <UIKit/UIKit.h>

@interface UIImage (CMCore)

#pragma mark -

/// 生成一张高斯模糊的图片, level: 模糊程度(0~1)
+ (UIImage *)cm_imageWithBlurLevel:(CGFloat)level fromImage:(UIImage *)originalImage;
/// 将 CIImage 转化成图片
+ (UIImage *)cm_imageFormCIImage:(CIImage *)ciImg withSize:(CGFloat)size;
/// 二维码图片
+ (UIImage *)cm_QRImageFormString:(NSString *)qrString withSize:(CGFloat)size;

#pragma mark -

/// 由颜色值生成图片
+ (UIImage *)cm_imageWithColor:(UIColor *)color size:(CGSize)size;

/// 重新渲染图片背景色
- (UIImage *)cm_imageMaskedWithColor:(UIColor *)maskColor;

/// 在图片上添加另一张图片
- (UIImage *)cm_addAttachImage:(UIImage *)image atFrame:(CGRect)frame;
/// 在图片上添加水印文字
- (UIImage *)cm_addAttachText:(NSString *)text withTextAttributes:(NSDictionary *)attributes;

#pragma mark -

/// 截屏 ( keyWindow )
+ (UIImage *)cm_imageCapturedKeyWindow;
/// 从视图截取图片
+ (UIImage *)cm_imageCapturedInView:(UIView *)view;
/// 裁剪图片指定区域
- (UIImage *)cm_imageCroppedInRect:(CGRect)rect;
/// 裁剪图片成圆形，并设置边框
- (UIImage *)cm_imageCroppedToRoundWithBoardWidth:(CGFloat)boardWidth boardColor:(UIColor *)boardColor;
/// 裁剪成圆角矩形图片
- (UIImage *)cm_imageCroppedRoundRectWithRadius:(CGFloat)radius;
/// 按比例拉伸/压缩图片
- (UIImage *)cm_imageStretchedWithScale:(CGFloat)scale __TVOS_PROHIBITED;


/**
 重置图片分辨率

 @param size 目标尺寸
 @return 处理后的图片
 */
- (UIImage *)cm_imageResizedToSize:(CGSize)size;

/**
 压缩图片至多少字节大小

 @param bytes 目标字节大小
 @return 处理后的图片
 */
- (UIImage *)cm_imageResizedToBytes:(NSUInteger)bytes;

/**
 压缩图片至多少字节大小
 
 @param size 目标尺寸
 @param bytes 目标字节大小
 @return 处理后的图片
 */
- (UIImage *)cm_imageResizedToSize:(CGSize)size andBytes:(NSUInteger)bytes;

@end

#pragma mark - Gif

#if __has_include(<ImageIO/ImageIO.h>)

@interface UIImage (CMCoreGIF)

/// 是否是 GIF 图片
- (BOOL)cm_isGIFImage;
/// 已图片名创建 GIF
+ (UIImage *)cm_GIFImageWithName:(NSString *)imageName;
/// 从 Data 创建 GIF
+ (UIImage *)cm_GIFImageWithData:(NSData *)data;

@end

#endif /* ImageIO */

#endif /* UIKit */
