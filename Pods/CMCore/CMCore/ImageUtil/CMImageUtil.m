//
//  CMImageUtil.m
//  CMCore
//
//  Created by PengTao on 2017/12/15.
//  Copyright © 2017年 CMFT Co.,Ltd. All rights reserved.
//

#import "CMImageUtil.h"

#if __has_include(<UIKit/UIImage.h>) && __has_include(<UIKit/UIView.h>)

#import <Accelerate/Accelerate.h>

@implementation UIImage (CMCoreImage)

+ (UIImage *)cm_imageWithBlurLevel:(CGFloat)level fromImage:(UIImage *)originalImage {
    // 模糊度越界
    level = MIN(MAX(0.f, level), 1.f);

    int boxSize = (int)(level * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = originalImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);

    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);

    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));

    if(pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
        CFRelease(inBitmapData);
        return nil;
    }

    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);

    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }

    UIImage *newImage = nil;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    {
        CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                                 outBuffer.width,
                                                 outBuffer.height,
                                                 8,
                                                 outBuffer.rowBytes,
                                                 colorSpace,
                                                 kCGImageAlphaNoneSkipLast);
        {
            CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
            newImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
        }
        CGContextRelease(ctx);
    }
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);

    return newImage;
}

+ (UIImage *)cm_imageFormCIImage:(CIImage *)ciImg withSize:(CGFloat)size {
    // 创建bitmap
    CGRect extent = CGRectIntegral(ciImg.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(cs);
    // 渲染
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImg fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 获取新图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);

    return newImage;
}

+ (UIImage *)cm_QRImageFormString:(NSString *)qrString withSize:(CGFloat)size {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];

    return [self cm_imageFormCIImage:qrFilter.outputImage withSize:size];
}

#pragma mark -

+ (UIImage *)cm_imageWithColor:(UIColor *)color size:(CGSize)size {
    UIImage *newImage = nil;
    UIGraphicsBeginImageContext(size);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)cm_imageMaskedWithColor:(UIColor *)maskColor {
    NSParameterAssert(maskColor);

    UIImage *newImage = nil;

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);

        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));

        CGContextClipToMask(context, imageRect, self.CGImage); //选中选区 获取不透明区域路径
        CGContextSetFillColorWithColor(context, maskColor.CGColor); //设置颜色
        CGContextFillRect(context, imageRect); //绘制

        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)cm_addAttachImage:(UIImage *)image atFrame:(CGRect)frame {
    UIImage *newImage = self.copy;
    UIGraphicsBeginImageContextWithOptions(newImage.size, NO, newImage.scale);
    {
        [newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
        UIImage *waterImage = image.copy;
        [waterImage drawInRect:frame];    // 画Logo
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)cm_addAttachText:(NSString *)text withTextAttributes:(NSDictionary *)attributes {
    UIImage *bgImage = self.copy;
    UIImage *newImage = nil;

    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, bgImage.scale);
    {
        [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)]; // 画背景大图

        CGFloat margin = 5;
        // size是允许的最大宽度高度
        CGSize maxSize = CGSizeMake(bgImage.size.width - (2 * margin), bgImage.size.height - (2 * margin));
        // attrs是字体属性
        NSDictionary *attrs = attributes;
        // 计算字符串宽度高度的函数
        CGSize textSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        CGFloat textX = bgImage.size.width - textSize.width - margin;
        CGFloat textY = bgImage.size.height - textSize.height - margin;
        CGFloat textW = textSize.width;
        CGFloat textH = textSize.height;
        CGRect textRect = CGRectMake(textX, textY, textW, textH);
        [text drawInRect:textRect withAttributes:attrs];    // 画text

        newImage = UIGraphicsGetImageFromCurrentImageContext();    // 从上下文中取出图片
    }
    UIGraphicsEndImageContext();    // 关闭上下文

    return newImage;
}

#pragma mark -

+ (UIImage *)cm_imageCapturedKeyWindow {
    return [self cm_imageCapturedInView:UIApplication.sharedApplication.keyWindow];
}
+ (UIImage *)cm_imageCapturedInView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);   // 开启上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];         // 将view.layer渲染到上下文中
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();       // 取出上下文中的图片
    UIGraphicsEndImageContext();                                        // 结束上下文
    return image;
}

- (UIImage *)cm_imageCroppedInRect:(CGRect)rect {
    UIImage *newImage = self.copy;
    UIGraphicsBeginImageContextWithOptions(newImage.size, NO, newImage.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
        [newImage drawInRect:CGRectMake(-rect.origin.x , -rect.origin.y, newImage.size.width, newImage.size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)cm_imageCroppedToRoundWithBoardWidth:(CGFloat)boardWidth boardColor:(UIColor *)boardColor {
    UIImage *newImage = self.copy;

    CGFloat insideDiameter = MIN(newImage.size.width, newImage.size.height); // 内径
    CGFloat outsideDiameter = insideDiameter + boardWidth*2; // 外径

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(outsideDiameter, outsideDiameter), NO, self.scale);
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();   // 获取当前上下文
        [boardColor set];

        // 外圈
        CGRect outsideCircle = CGRectMake(0, 0, outsideDiameter, outsideDiameter);
        CGContextAddEllipseInRect(ctx, outsideCircle);
        CGContextFillPath(ctx);

        // 内圈
        CGRect insideCircle = CGRectMake(boardWidth, boardWidth, insideDiameter, insideDiameter);
        CGContextAddEllipseInRect(ctx, insideCircle);
        CGContextClip(ctx); // 裁剪
        [newImage drawInRect:insideCircle]; // 将原图画上去

        newImage = UIGraphicsGetImageFromCurrentImageContext();    // 获取新图
    }
    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)cm_imageCroppedRoundRectWithRadius:(CGFloat)radius {
    UIImage *newImage = self.copy;

    UIGraphicsBeginImageContextWithOptions(newImage.size, NO, newImage.scale); // 开启上下文
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();   // 获取上下文

        // 画裁剪路径
        CGContextAddArc(ctx, radius, radius, radius, -M_PI_2, M_PI, 1);      // 左上角弧线
        CGContextAddLineToPoint(ctx, 0, newImage.size.height-radius);           // 左线
        CGContextAddArc(ctx, radius, newImage.size.height-radius, radius, M_PI, M_PI_2, 1);       // 左下角弧线
        CGContextAddLineToPoint(ctx, newImage.size.width-radius, newImage.size.height);                 // 下线
        CGContextAddArc(ctx, newImage.size.width-radius, newImage.size.height-radius, radius, M_PI_2, 0, 1);    // 右下角弧线
        CGContextAddLineToPoint(ctx, newImage.size.width, radius);              // 右线
        CGContextAddArc(ctx, newImage.size.width-radius, radius, radius, 0, -M_PI_2, 1);     // 右下角弧线
        CGContextClosePath(ctx);

        CGContextClip(ctx);

        [newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];

        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)cm_imageStretchedWithScale:(CGFloat)scale {
    return [self stretchableImageWithLeftCapWidth:self.size.width * scale topCapHeight:self.size.height * scale];
}

- (UIImage *)cm_imageResizedToSize:(CGSize)size {
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake(0, 0, size.width, size.height));
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}
- (UIImage *)cm_imageResizedToMaxBytes:(NSUInteger)maxBytes {
    UIImage *img = self.copy;
    double scale = 1;
    NSData *imgData = UIImageJPEGRepresentation(img, scale);
    while (imgData.length > maxBytes) {
        scale -= 0.05;
        imgData = UIImageJPEGRepresentation(img, scale);
    }
    return [UIImage imageWithData:imgData];
}

- (UIImage *)cm_imageResizedToSize:(CGSize)size andMaxBytes:(NSUInteger)maxBytes {
    UIImage *newImage = [self cm_imageResizedToSize:size];
    return [newImage cm_imageResizedToMaxBytes:maxBytes];
}

@end

#if __has_include(<ImageIO/ImageIO.h>)

#import <ImageIO/ImageIO.h>

@implementation UIImage (CMCoreGIF)

- (BOOL)cm_isGIFImage {
    return (self.images != nil);
}
+ (UIImage *)cm_GIFImageWithName:(NSString *)imageName {
    if (![imageName hasSuffix:@".gif"]) {
        imageName = [imageName stringByAppendingString:@".gif"];
    }

    NSString *imagePath = [NSBundle.mainBundle pathForResource:imageName ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    if (data) {
        return [self cm_GIFImageWithData:data];
    } else {
        return [UIImage imageNamed:imageName];
    }
}
+ (UIImage *)cm_GIFImageWithData:(NSData *)data {
    if (!data) return nil;

    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(imageSource);
    if (count <= 1) { //非gif
        CFRelease(imageSource);
        return [[UIImage alloc] initWithData:data];
    } else { //gif图片
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            if (!image) continue;
            duration += [UIImage _cm_durationWithSource:imageSource atIndex:i];
            [images addObject:[UIImage imageWithCGImage:image]];
            CGImageRelease(image);
        }
        if (!duration) duration = 0.1 * count;
        CFRelease(imageSource);
        return [UIImage animatedImageWithImages:images duration:duration];
    }
}

+ (float)_cm_durationWithSource:(CGImageSourceRef)source atIndex:(NSUInteger)index {
    float duration = 0.1f;
    CFDictionaryRef propertiesRef = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *properties = (__bridge NSDictionary *)propertiesRef;
    NSDictionary *gifProperties = properties[(NSString *)kCGImagePropertyGIFDictionary];

    NSNumber *delayTime = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTime) duration = delayTime.floatValue;
    else {
        delayTime = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTime) duration = delayTime.floatValue;
    }
    CFRelease(propertiesRef);
    return duration;
}

@end

#endif /* ImageIO */

#endif /* UIKit */
