//
//  CSFileHandle.m
//  CSKit
//
//  Created by chengshu on 2020/4/7.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSFileHandle.h"

static CSFileHandle *fileHandle = nil;

@implementation CSFileHandle

///外部单例共享方法
+ (instancetype)shareSingleCase {
    
    return [[self alloc]init];
    
}

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

/////获取沙盒根目录
//+(NSString *)getSandboxFolder:(SandBoxFolderType)SandBoxFolderType {
//
//    NSString *folderPath = @"";
//
//    switch (SandBoxFolderType) {
//        case FolderDocumentType:{
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//            folderPath = [paths objectAtIndex:0];
//        }break;
//        case FolderLibraryTye:{
//             NSArray *libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//            folderPath = [libPaths objectAtIndex:0];
//        }break;
//        case FolderCachesType:{
//            NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//            folderPath = [cacPath objectAtIndex:0];
//        }break;
//        case FolderTempType:{
//            folderPath = NSTemporaryDirectory();
//        }break;
//
//        default:
//            break;
//    }
//    return folderPath;
//}

///创建文件夹
-(BOOL)createFolder:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName {
        
    return [self checkFolderExists:[self getObjectPath:sandboxFolderType folderRelativePath:[folderRelativePath stringByAppendingPathComponent:folderName] fileName:@""]];
    
}


///创建一个文件并保存到指定的位置
-(BOOL)createFile:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    NSString *folderPath = [self getObjectPath:sandboxFolderType folderRelativePath:folderRelativePath fileName:@""];
    
    BOOL status = [self checkFolderExists:folderPath];
    
    if (status) {
        
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        
        status = [self createFile:filePath];
        
    }
    
    return status;
}

///创建一个文件并保存到指定的位置
-(BOOL)createFile:(NSString *)filePath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
           
    return [manager createFileAtPath:filePath contents:nil attributes:nil];
    
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

///检查文件是否存在
-(BOOL)checkFileExists:(NSString *)filePath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
       
    return [manager fileExistsAtPath:filePath];
}

///通过路径创建文件夹
-(BOOL)createFolder:(NSString *)folderPath {

    return [self checkFolderExists:folderPath];
    
}

///保存文件到沙盒中
-(void)saveFileToSandbox:(NSData *)fileData sandBoxFolderType:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    NSString *rootFolderPath = [self getSandboxFolder:sandBoxFolderType];
    
    BOOL status = [self checkFolderExists:[self getObjectPath:sandBoxFolderType folderRelativePath:folderRelativePath fileName:@""]];
    
    if(status){
        
        dispatch_async([self queue], ^{
            
            NSFileManager *manager = [NSFileManager defaultManager];
            
            NSString *filePath = [[rootFolderPath stringByAppendingPathComponent:folderRelativePath] stringByAppendingPathComponent:fileName];
            
            BOOL saveFileStatus = NO;
            
            if (![manager fileExistsAtPath:filePath]) {
                
                saveFileStatus = [manager createFileAtPath:filePath contents:fileData attributes:nil];
                
            }
            
            if (saveFileStatus) {
                NSError *error = nil;
                saveFileStatus = [fileData writeToFile:filePath options:NSDataWritingAtomic error:&error];
                
                if (error == nil) {
                    saveFileStatus = YES;
                }
            }
            
            if (saveFileStatus) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    if ([self.delegate respondsToSelector:@selector(saveFileComplete:saveFileStatus:message:)]) {
                        [self.delegate saveFileComplete:fileName saveFileStatus:SaveFileSucess message:[NSString stringWithFormat:@"保存文件 %@ 成功",fileName]];
                    }
                    
                });
                
            }else {
               dispatch_async(dispatch_get_main_queue(), ^{
                              
                    if ([self.delegate respondsToSelector:@selector(saveFileComplete:saveFileStatus:message:)]) {
                        [self.delegate saveFileComplete:fileName saveFileStatus:SaveFileFailed message:[NSString stringWithFormat:@"保存文件 %@ 失败",fileName]];
                    }
                                  
                });
            }
            
//            NSFileManager *manager = [NSFileManager defaultManager];
//
//            NSString *filePath = [[rootFolderPath stringByAppendingPathComponent:folderRelativePath] stringByAppendingPathComponent:fileName];
//
//            if(![manager fileExistsAtPath:filePath]){
//
//                status = [manager createFileAtPath:filePath contents:fileData attributes:nil];
//            }
//
//            if(status) {
//                NSError *error = nil;
//                status =  [fileData writeToFile:filePath options:NSDataWritingAtomic error:&error];
//            }
            
            
        });
        
//        NSFileManager *manager = [NSFileManager defaultManager];
//
//        NSString *filePath = [[rootFolderPath stringByAppendingPathComponent:folderRelativePath] stringByAppendingPathComponent:fileName];
//
//        if(![manager fileExistsAtPath:filePath]){
//
//            status = [manager createFileAtPath:filePath contents:fileData attributes:nil];
//        }
//
//        if(status) {
//            NSError *error = nil;
//            status = [fileData writeToFile:filePath options:NSDataWritingAtomic error:&error];
//        }
        
    }
//      return status;
}

///读取文件数据
-(void)readFileDataFromSandBox:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    NSString *filePath = [self getObjectPath:sandBoxFolderType folderRelativePath:folderRelativePath fileName:fileName];
    
    [self readFileData:filePath];
    
//
//    NSData *data = [self readFileData:filePath];
//
//    return data;
    
}

///读取文件数据
-(void)readFileData:(NSString *)filePath {
    
    dispatch_async(self.queue, ^{
        
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
        
        NSString *fileName = [[filePath componentsSeparatedByString:@"/"] lastObject];
        
        if (error == nil) {
            
            if ([self.delegate respondsToSelector:@selector(readFileComplete:fileName:readFileStatus:message:)]) {
                [self.delegate readFileComplete:data fileName:fileName readFileStatus:ReadFileSucess message:[NSString stringWithFormat:@"读取 %@ 成功",fileName]];
            }
            
        }else {
            
            if ([self.delegate respondsToSelector:@selector(readFileComplete:fileName:readFileStatus:message:)]) {
                [self.delegate readFileComplete:[NSData data] fileName:fileName readFileStatus:ReadFileFailed message:[NSString stringWithFormat:@"读取 %@ 失败 %@",fileName,error.description]];
            }
            
        }
    });
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

/////获取目标路径
//+(NSString *)getObjectPath:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
//
//    NSString *rootPath = [self getSandboxFolder:sandBoxFolderType];
//
//    NSString *folderPath = [rootPath stringByAppendingPathComponent:folderRelativePath];
//
//    NSString *filePath = @"";
//
//    if(fileName == nil || [fileName isEqualToString:@""]) {
//
//        filePath = folderPath;
//
//    }else {
//        filePath = [folderPath stringByAppendingPathComponent:fileName];
//    }
//    return filePath;
//}

///删除文件
-(BOOL)removeFile:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    NSString *filePath = [self getObjectPath:sandBoxFolderType folderRelativePath:folderRelativePath fileName:fileName];
    
    return [self removeFile:filePath];
}

///删除文件夹
-(BOOL)removeFolder:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName {
    
    NSString *folderPath = [self getObjectPath:sandBoxFolderType folderRelativePath:folderRelativePath fileName:folderName];
    
    return [self removeFolder:folderPath];
    
}

///删除文件夹
-(BOOL)removeFolder:(NSString *)folderPath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error = nil;
       
    BOOL status = NO;
       
    status = [manager removeItemAtPath:folderPath error:&error];
       
    return status;
}



///删除文件
-(BOOL)removeFile:(NSString *)filePath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
       
    NSError *error = nil;
       
    BOOL status = NO;
       
    status = [manager removeItemAtPath:filePath error:&error];
       
    return status;
}

#pragma mark -

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        
        if (fileHandle == nil) {
            fileHandle = [super allocWithZone:zone];
        }
        return fileHandle;
    }
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return fileHandle;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return fileHandle;
}

@end
