//
//  CSVideoHandle.m
//  CSToolKit
//
//  Created by chengshu on 2020/6/19.
//  Copyright © 2020 cs. All rights reserved.
//

#import "CSVideoHandle.h"
#import "CSFileManager.h"

#import <AVFoundation/AVFoundation.h>

@interface CSVideoHandle ()


@end

@implementation CSVideoHandle

-(void)imagesConvertVideo:(NSArray *)images videoOutputPath:(NSString *)videoOutputPath videoSize:(CGSize)videoSize {
    
    NSString *movieOutputPath = [[CSFileManager shareSingleCase] pathNormCheck:videoOutputPath];
    
    NSError *error;
    
    unlink([movieOutputPath UTF8String]);
    
    AVAssetWriter *avAssetWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:movieOutputPath] fileType:AVFileTypeQuickTimeMovie error:&error];
    NSParameterAssert(avAssetWriter);
    if (error==nil) {
        
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecTypeH264,AVVideoCodecKey,
        [NSNumber numberWithInt:videoSize.width],AVVideoWidthKey,
        [NSNumber numberWithInt:videoSize.height],AVVideoHeightKey,nil];
        
        AVAssetWriterInput *writerInput =[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
        
        NSDictionary*sourcePixelBufferAttributesDictionary =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];
        //    AVAssetWriterInputPixelBufferAdaptor提供CVPixelBufferPool实例,
        //    可以使用分配像素缓冲区写入输出文件。使用提供的像素为缓冲池分配通常
        //    是更有效的比添加像素缓冲区分配使用一个单独的池
            AVAssetWriterInputPixelBufferAdaptor *adaptor =[AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
        
        NSParameterAssert(writerInput);
        NSParameterAssert([avAssetWriter canAddInput:writerInput]);
        
        [avAssetWriter addInput:writerInput];
        
        [avAssetWriter startWriting];
        [avAssetWriter startSessionAtSourceTime:kCMTimeZero];
        
        dispatch_queue_t dispatchQueue =dispatch_queue_create("mediaInputQueue",NULL);
        
        int __block frame =0;
        [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
            //写入时的逻辑：将数组中的每一张图片多次写入到buffer中，
            while([writerInput isReadyForMoreMediaData])
            {//数组中图片此时写入总次数
                if(++frame >= [images count]*self.fps)
                {
                    [writerInput markAsFinished];
                    [avAssetWriter finishWriting];
                    break;
                }
                CVPixelBufferRef buffer =NULL;
                //每张图片写入多少次换下一张
                int idx =frame/(images.count*self.fps);
                NSLog(@"idx==%d",idx);
                //将图片转成buffer
                buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[[images objectAtIndex:idx] CGImage] size:videoSize];
                
                if (buffer)
                {
                    if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,(int32_t)(self.fps*(images.count/self.duration)))])//设置每秒钟播放图片的个数

                    CFRelease(buffer);
                }
            }
        }];
    }else {
        
    }
    
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    NSDictionary *options =[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    CVPixelBufferRef pxbuffer =NULL;
    CVReturn status =CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    
    NSParameterAssert(status ==kCVReturnSuccess && pxbuffer !=NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    
    void *pxdata =CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata !=NULL);
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
//    当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项
    CGContextRef context =CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
//使用CGContextDrawImage绘制图片  这里设置不正确的话 会导致视频颠倒
//    当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是UIImage的CGImageRef，因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
// 释放色彩空间
    CGColorSpaceRelease(rgbColorSpace);
// 释放context
    CGContextRelease(context);
// 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    
    return pxbuffer;
}

@end
