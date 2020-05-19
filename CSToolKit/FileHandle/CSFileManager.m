//
//  CSFileManager.m
//  CSToolKit
//
//  Created by chengshu on 2020/5/13.
//  Copyright © 2020 cs. All rights reserved.
//

#import "CSFileManager.h"

static CSFileManager *fileManager = nil;

@implementation CSFileManager

///获取沙盒根目录
-(NSString *)getSandboxFolder:(SandBoxFolderType)sandBoxFolderType {
    
    NSString *folderPath = @"";
    
    switch (sandBoxFolderType) {
        case FolderDocumentType:{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            folderPath = [paths objectAtIndex:0];
        }break;
        case FolderLibraryTye:{
             NSArray *libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            folderPath = [libPaths objectAtIndex:0];
        }break;
        case FolderCachesType:{
            NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            folderPath = [cacPath objectAtIndex:0];
        }break;
        case FolderTempType:{
            folderPath = NSTemporaryDirectory();
        }break;
        
        default:
            break;
    }
    
    return folderPath;
}

///获取文件夹的路径
-(NSString *)getFolderPath:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName {
    
    NSString *rootFolderPath = [self getSandboxFolder:sandBoxFolderType];
    
    NSString *relativePath = [rootFolderPath stringByAppendingPathComponent:folderRelativePath];
    
    NSString *folderPath = [relativePath stringByAppendingPathComponent:folderName];
    
    return folderPath;
}

///获取文件的路径
-(NSString *)getFilePath:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
     NSString *rootFolderPath = [self getSandboxFolder:sandBoxFolderType];
    
    NSString *relativePath = [rootFolderPath stringByAppendingPathComponent:folderRelativePath];
    
    NSString *filePath = [relativePath stringByAppendingPathComponent:fileName];
    
    return filePath;
}


///检查文件是否存在
-(BOOL)checkFolderExist:(NSString *)folderPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    
    BOOL complete = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if (complete && isDir) {
        return YES;
    }else {
        return NO;
    }
    
}

-(BOOL)checkFileExist:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:filePath];
//    return [fileManager isExecutableFileAtPath:filePath];
 
}

-(BOOL)createFolder:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName {

    BOOL complete = NO;
    
    NSString *folderPath = [self getFolderPath:sandBoxFolderType folderRelativePath:folderRelativePath folderName:folderName];
    
    complete = [self createFolder:folderPath];
    
    return complete;
    
}

///创建文件夹
-(BOOL)createFolder:(NSString *)folderPath {
    
    BOOL complete = NO;
    
    if ([self checkFolderExist:folderPath]) {
        
        complete = YES;
        
    }else {
        
        NSError *error = nil;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
       BOOL status = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (status && error == nil) {
            complete = YES;
        }else {
            complete = NO;
        }
    }

    return complete;
}

///删除文件夹
-(BOOL)removeFolder:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName {
    
    BOOL complete = NO;
    
    NSString *folderPath = [self getFolderPath:sandBoxFolderType folderRelativePath:folderRelativePath folderName:folderName];
    
    complete = [self removeFolder:folderPath];
    
    return complete;
}

///删除文件夹
-(BOOL)removeFolder:(NSString *)folderPath {
    
    BOOL complete = NO;
    
    if ([self checkFolderExist:folderPath]) {
        
        NSFileManager *manager = [NSFileManager defaultManager];
           
        NSError *error = nil;
              
        BOOL status = NO;
              
        status = [manager removeItemAtPath:folderPath error:&error];
              
        if (status && error==nil) {
            complete = YES;
        }else {
            complete = NO;
        }
        
    }else {
        complete = YES;
    }

    return complete;
    
}

///移除文件
-(BOOL)removeFile:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    BOOL complete = NO;
    
    NSString *filePath = [self getFilePath:sandBoxFolderType folderRelativePath:folderRelativePath fileName:fileName];
    
    complete = [self removeFile:filePath];
    
    return complete;
    
}

///移除文件
-(BOOL)removeFile:(NSString *)filePath {
    
    BOOL complete = NO;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    BOOL status = [manager removeItemAtPath:filePath error:&error];
    
    if (status && error == nil) {
        
        complete = YES;
        
    }

    return complete;
}

-(void)saveFileToSandbox:(NSData *)fileData sandBoxFolderType:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName isCover:(BOOL)isCover {
    
    dispatch_async(self.queue, ^{
        
        BOOL complete = NO;
            
            NSString *folderPath = [self getFolderPath:sandBoxFolderType folderRelativePath:folderRelativePath folderName:@""];
            NSString *filePath = [self getFilePath:sandBoxFolderType folderRelativePath:folderRelativePath fileName:fileName];
            
            BOOL folderStatus = [self checkFolderExist:folderPath];
            
            if (!folderStatus) {
                folderStatus = [self createFolder:folderPath];
            }
            
            if (!folderStatus) {
                complete = folderStatus;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(saveFileComplete:filePath:fileName:message:)]) {
                        [self.delegate saveFileComplete:SaveFileFailed filePath:filePath fileName:fileName message:[NSString stringWithFormat:@"保存文件%@失败",fileName]];
                    }
                });
                return;
                
            }
            
            ///文件检查，是否存在该文件
            BOOL fileStatus = [self checkFileExist:filePath];
            
            if (fileStatus) {
                
                if (isCover) {
                    [self removeFile:filePath];
                }else {
                    complete = fileStatus;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.delegate respondsToSelector:@selector(saveFileComplete:filePath:fileName:message:)]) {
                            [self.delegate saveFileComplete:SaveFileExist filePath:filePath fileName:fileName message:[NSString stringWithFormat:@"文件%@已经存在",fileName]];
                        }
                    });
                    return;
                }
            }
            
            BOOL createFileStatus = NO;
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            createFileStatus = [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
            
            if (!createFileStatus) {
                complete = createFileStatus;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(saveFileComplete:filePath:fileName:message:)]) {
                        [self.delegate saveFileComplete:SaveFileFailed filePath:filePath fileName:fileName message:[NSString stringWithFormat:@"无法创建文件%@",fileName]];
                    }
                });
                return;
            }
            
            BOOL writeDataToFileStatus = NO;
            NSError *error = nil;
            writeDataToFileStatus = [fileData writeToFile:filePath options:NSDataWritingAtomic error:&error];
                           
            if (writeDataToFileStatus && error == nil) {
                complete = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(saveFileComplete:filePath:fileName:message:)]) {
                    [self.delegate saveFileComplete:SaveFileSucess filePath:filePath fileName:fileName message:[NSString stringWithFormat:@"保存文件%@成功",fileName]];
                }
            });
            return;
    });
}

///移动文件到指定的目录下
-(BOOL)moveSrcFilePath:(NSString *)srcFilePath toSandBoxFolderType:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName isCover:(BOOL)isCover {
    
    BOOL complete = NO;
    
    NSString *dstFolderPath = [self getFolderPath:sandboxFolderType folderRelativePath:folderRelativePath folderName:@""];
    
    NSString *dstFilePath = [self getFilePath:sandboxFolderType folderRelativePath:folderRelativePath fileName:fileName];
    
    BOOL dstFolderStatus = [self checkFolderExist:dstFolderPath];
    
    if (!dstFolderStatus) {
        BOOL createDstFolderStatus = NO;
        
        createDstFolderStatus = [self createFolder:dstFolderPath];
        
        if (!createDstFolderStatus) {
            return NO;
        }
    }

    complete = [self moveSrcFilePath:srcFilePath dstFilePath:dstFilePath isCover:isCover];
    
    return complete;
    
}

///移动文件到指定的目录下
-(BOOL)moveSrcFilePath:(NSString *)srcFilePath dstFilePath:(NSString *)dstFilePath isCover:(BOOL)isCover {
    
    srcFilePath = [srcFilePath stringByReplacingOccurrencesOfString:@"file:///" withString:@""];
    dstFilePath = [dstFilePath stringByReplacingOccurrencesOfString:@"file:///" withString:@""];
    
    BOOL dstFileStatus = [self checkFileExist:dstFilePath];
    
    if (dstFileStatus) {
        
        if (isCover) {
            [self removeFile:dstFilePath];
        }else {
            return YES;
        }
    }
    
    BOOL complete = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error = nil;

    BOOL status = [fileManager moveItemAtURL:[NSURL fileURLWithPath:srcFilePath] toURL:[NSURL fileURLWithPath:dstFilePath] error:&error];

    if (status && error ==nil) {
        complete = YES;
    }
    
    return complete;
    
}

///move 文件到指定的目录
-(BOOL)moveSrcFilePathUrl:(NSURL *)srcFilePathUrl dstFilePathUrl:(NSURL *)dstFilePathUrl isCover:(BOOL)isCover {
 
    BOOL dstFileStatus = [self checkFileExist:dstFilePathUrl.absoluteString];
    
    if (dstFileStatus) {
        
        if (isCover) {
            [self removeFile:dstFilePathUrl.absoluteString];
        }else {
            return YES;
        }
    }
    
    BOOL complete = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error = nil;

    BOOL status = [fileManager moveItemAtURL:srcFilePathUrl toURL:dstFilePathUrl error:&error];

    if (status && error ==nil) {
        complete = YES;
    }
    
    return complete;
    
}

///copy文件到指定的文件目录下
-(BOOL)copySrcFilePath:(NSString *)srcFilePath toSandBoxFolderType:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName isCover:(BOOL)isCover{
    
    BOOL complete = NO;
    
    NSString *dstFolderPath = [self getFolderPath:sandboxFolderType folderRelativePath:folderRelativePath folderName:@""];
    
    NSString *dstFilePath = [self getFilePath:sandboxFolderType folderRelativePath:folderRelativePath fileName:fileName];
    
    BOOL dstFolderStatus = [self checkFolderExist:dstFolderPath];
    
    if (!dstFolderStatus) {
        
        BOOL createDstFolderStatus = [self createFolder:dstFolderPath];
        
        if (!createDstFolderStatus) {
            return NO;
        }
    }
    complete = [self copySrcFilePath:srcFilePath toDstFilePath:dstFilePath isCover:isCover];

    return complete;
}

///copy 文件到指定的文件目录下
-(BOOL)copySrcFilePath:(NSString *)srcFilePath toDstFilePath:(NSString *)dstFilePath isCover:(BOOL)isCover {
    
    srcFilePath = [srcFilePath stringByReplacingOccurrencesOfString:@"file:///" withString:@""];
    dstFilePath = [dstFilePath stringByReplacingOccurrencesOfString:@"file:///" withString:@""];
    
    BOOL dstFileStatus = [self checkFileExist:dstFilePath];
    
    if (dstFileStatus) {
        
        if (isCover) {
            [self removeFile:dstFilePath];
        }else {
            return YES;
        }
    }
    
    BOOL complete = NO;

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error = nil;

    BOOL status = [fileManager copyItemAtURL:[NSURL fileURLWithPath:srcFilePath] toURL:[NSURL fileURLWithPath:dstFilePath] error:&error];

    if (status && error ==nil) {
        complete = YES;
    }
    
    return complete;
}

///copy 文件到指定的目录
-(BOOL)copySrcFileUrl:(NSURL *)srcFileUrl toDstFileUrl:(NSURL *)dstFileUrl isCover:(BOOL)isCover {
    
    NSString *dstFilePath = [dstFileUrl.absoluteString stringByReplacingOccurrencesOfString:@"file:///" withString:@""];
    
    BOOL dstFileStatus = [self checkFileExist:dstFilePath];
    
    if (dstFileStatus) {
        
        if (isCover) {
            [self removeFile:dstFilePath];
        }else {
            return YES;
        }
    }

    BOOL complete = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error = nil;

    BOOL status = [fileManager copyItemAtURL:srcFileUrl toURL:dstFileUrl error:&error];

    if (status && error ==nil) {
        complete = YES;
    }
    
    return complete;
}


#pragma mark - singlecase
+ (instancetype)shareSingleCase {
    
    return [[self alloc]init];
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        
        if (fileManager == nil) {
            fileManager = [super allocWithZone:zone];
        }
        return fileManager;
    }
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return fileManager;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return fileManager;
}


@end
