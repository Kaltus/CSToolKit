//
//  CSFileHandle.m
//  CSKit
//
//  Created by chengshu on 2020/4/7.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSFileHandle.h"



@implementation CSFileHandle

///获取沙盒根目录
-(NSString *)getSandboxFolder:(SandBoxFolderType)SandBoxFolderType {
    
    NSString *folderPath = @"";
    
    switch (SandBoxFolderType) {
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

///获取沙盒根目录
+(NSString *)getSandboxFolder:(SandBoxFolderType)SandBoxFolderType {
    
    NSString *folderPath = @"";
    
    switch (SandBoxFolderType) {
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

///创建文件夹
-(BOOL)createFolder:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName {
        
    return [self checkFolderExists:[self getObjectPath:sandboxFolderType folderRelativePath:[folderRelativePath stringByAppendingPathComponent:folderName] fileName:@""]];
    
}

///检查路径，并创建文件夹
-(BOOL)checkFolderExists:(NSString *)folderPath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL status = YES;
    
    if(![manager isExecutableFileAtPath:folderPath]) {
        
        NSError *error = nil;

        status = [manager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return status;
    
}

///通过路径创建文件夹
-(BOOL)createFolderByPath:(NSString *)folderPath {

    return [self checkFolderExists:folderPath];
    
}

///保存文件到沙盒中
-(BOOL)saveFileToSandbox:(NSData *)fileData sandBoxFolderType:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    NSString *rootFolderPath = [self getSandboxFolder:sandBoxFolderType];
    
    BOOL status = [self checkFolderExists:[self getObjectPath:sandBoxFolderType folderRelativePath:folderRelativePath fileName:@""]];
    
    if(status){
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
         NSString *filePath = [[rootFolderPath stringByAppendingPathComponent:folderRelativePath] stringByAppendingPathComponent:fileName];
        
        if(![manager fileExistsAtPath:filePath]){
            
            status = [manager createFileAtPath:filePath contents:fileData attributes:nil];
        }
        
        if(status) {
            NSError *error = nil;
            status = [fileData writeToFile:filePath options:NSDataWritingAtomic error:&error];
        }
    }
    
    return status;
}

///读取文件数据
-(NSData *)readFileDataFromSandBox:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    NSString *filePath = [self getObjectPath:sandBoxFolderType folderRelativePath:folderRelativePath fileName:fileName];
    
    NSData *data = [self readFileData:filePath];
    
    return data;
    
}

///读取文件数据
-(NSData *)readFileData:(NSString *)filePath {
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    return data;
    
}

///获取目标路径
-(NSString *)getObjectPath:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    NSString *rootPath = [self getSandboxFolder:sandBoxFolderType];
    
    NSString *folderPath = [rootPath stringByAppendingPathComponent:folderRelativePath];
    
    NSString *filePath = @"";
    
    if(fileName == nil || [fileName isEqualToString:@""]) {
        
        filePath = folderPath;
        
    }else {
        filePath = [folderPath stringByAppendingPathComponent:fileName];
    }
    return filePath;
}

///获取目标路径
+(NSString *)getObjectPath:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    NSString *rootPath = [self getSandboxFolder:sandBoxFolderType];
    
    NSString *folderPath = [rootPath stringByAppendingPathComponent:folderRelativePath];
    
    NSString *filePath = @"";
    
    if(fileName == nil || [fileName isEqualToString:@""]) {
        
        filePath = folderPath;
        
    }else {
        filePath = [folderPath stringByAppendingPathComponent:fileName];
    }
    return filePath;
}

///删除文件
-(BOOL)removeFile:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    NSString *filePath = [self getObjectPath:sandBoxFolderType folderRelativePath:folderRelativePath fileName:fileName];
    
    return [self removeFile:filePath];
}

///删除文件
-(BOOL)removeFile:(NSString *)filePath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
       
    NSError *error = nil;
       
    BOOL status = nil;
       
    status = [manager removeItemAtPath:filePath error:&error];
       
    return status;
}

@end
