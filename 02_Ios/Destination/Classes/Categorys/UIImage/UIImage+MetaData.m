//
//  UIImage+MetaData.m
//  ImageMeteDataTest
//
//  Created by TouchWorld on 2018/11/23.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "UIImage+MetaData.h"
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>

@implementation UIImage (MetaData)
+ (NSDictionary *)imageMetaDataWithFileURL:(NSURL *)fileURL
{
    //CGImageSourceCreateWithData(<#CFDataRef  _Nonnull data#>, <#CFDictionaryRef  _Nullable options#>)
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)fileURL, NULL);
    if(imageSource)
    {
        NSDictionary * imageInfoDic = (__bridge NSDictionary * _Nonnull)CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);

        return imageInfoDic;
    }
    else
    {
        return nil;
    }
    
}

+ (NSDictionary *)imageEXIFDataWithFileURL:(NSURL *)fileURL
{
    NSDictionary * metaDataDic = [self imageMetaDataWithFileURL:fileURL];
    if(metaDataDic == nil)
    {
        return nil;
    }
    
    CFDictionaryRef metaDataDicRef = (__bridge CFDictionaryRef)(metaDataDic);
    NSDictionary * exifDic = (__bridge NSDictionary *)CFDictionaryGetValue(metaDataDicRef, kCGImagePropertyExifDictionary);
    return exifDic;
}

+ (NSDictionary *)imageTIFFDataWithFileURL:(NSURL *)fileURL
{
    NSDictionary * metaDataDic = [self imageMetaDataWithFileURL:fileURL];
    if(metaDataDic == nil)
    {
        return nil;
    }
    
    CFDictionaryRef metaDataDicRef = (__bridge CFDictionaryRef)(metaDataDic);
    NSDictionary * tiffDic = (__bridge NSDictionary *)CFDictionaryGetValue(metaDataDicRef, kCGImagePropertyTIFFDictionary);
    return tiffDic;
}

+ (NSDictionary *)imageGPSDataWithFileURL:(NSURL *)fileURL
{
    NSDictionary * metaDataDic = [self imageMetaDataWithFileURL:fileURL];
    if(metaDataDic == nil)
    {
        return nil;
    }
    
    CFDictionaryRef metaDataDicRef = (__bridge CFDictionaryRef)(metaDataDic);
    NSDictionary * gpsDic = (__bridge NSDictionary *)CFDictionaryGetValue(metaDataDicRef, kCGImagePropertyGPSDictionary);
    
    return gpsDic;
}

+ (void)changeImageGPSInfo
{
    //获取图片中的EXIF文件和GPS文件
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"test1"], 1);
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    
    NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    
    NSMutableDictionary *metaDataDic = [imageInfo mutableCopy];
    NSMutableDictionary *exifDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyExifDictionary]mutableCopy];
    NSMutableDictionary *GPSDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyGPSDictionary]mutableCopy];
    
    if(GPSDic == nil)
    {
        GPSDic = [NSMutableDictionary dictionary];
    }
    
    //修改EXIF文件和GPS文件中的部分信息
    [exifDic setObject:[NSNumber numberWithFloat:1234.3] forKey:(NSString *)kCGImagePropertyExifExposureTime];
    [exifDic setObject:@"cxz" forKey:(NSString *)kCGImagePropertyExifLensModel];
    
    [GPSDic setObject:@"N" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    [GPSDic setObject:[NSNumber numberWithFloat:116.29353] forKey:(NSString*)kCGImagePropertyGPSLatitude];
    
    [metaDataDic setObject:exifDic forKey:(NSString*)kCGImagePropertyExifDictionary];
    [metaDataDic setObject:GPSDic forKey:(NSString*)kCGImagePropertyGPSDictionary];
    
    //将修改后的文件写入至图片中
    CFStringRef UTI = CGImageSourceGetType(source);
    NSMutableData *newImageData = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)newImageData, UTI, 1,NULL);
    
    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metaDataDic);
    CGImageDestinationFinalize(destination);
    
    //保存图片
    NSString *directoryDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString * savePath = [directoryDocuments stringByAppendingPathComponent:@"test1.jpg"];
    [newImageData writeToFile: savePath atomically:YES];
    
    CIImage *testImage = [CIImage imageWithData:newImageData];
    //[UIImage imageWithCIImage:<#(nonnull CIImage *)#>]
    NSDictionary *propDict = [testImage properties];
    NSLog(@"Properties %@", propDict);
    
}

- (NSString *)changeImageMetaData:(NSDictionary *)metaDataDic
{
    if(metaDataDic == nil)
    {
        metaDataDic = [NSDictionary dictionary];
    }
    //获取图片中的EXIF文件和GPS文件
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    
    //将修改后的文件写入至图片中
    CFStringRef UTI = CGImageSourceGetType(source);
    NSMutableData *newImageData = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)newImageData, UTI, 1,NULL);
    
    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metaDataDic);
    CGImageDestinationFinalize(destination);
    
    //保存图片
    NSString *directoryDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString * savePath = [directoryDocuments stringByAppendingPathComponent:@"test1.jpg"];
    BOOL flag = [newImageData writeToFile: savePath atomically:YES];
    if(!flag)
    {
        return nil;
    }
    
    return savePath;
}


@end
