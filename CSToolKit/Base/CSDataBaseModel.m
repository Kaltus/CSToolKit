//
//  CSDataBaseModel.m
//  CSKit
//
//  Created by fengzhong-ios-chengshu on 2020/4/14.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSDataBaseModel.h"
#import <sqlite3.h>
#import "CSFileManager.h"

@interface CSDataBaseModel ()

@end

static sqlite3 *db = nil;

@implementation CSDataBaseModel

///打开数据库
-(BOOL)openDataBase:(NSString *)folderRelativePath dbName:(NSString *)dbName {
    
    NSString *dbPath = [folderRelativePath stringByAppendingPathComponent:dbName];
    
    if (sqlite3_open([dbPath UTF8String],&db) == SQLITE_OK) {
        return YES;
    }else {
        return NO;
    }
}

///创建表
-(void)createDatabaseTable {
    
//    NSString *path = [[CSFileManager shareSingleCase] getObjectPath:FolderCachesType folderRelativePath:CSToolKitFolder fileName:DataBaseFolder];
    
//    NSString *path = [[CSFileManager shareSingleCase] get]
    
//    if ([self openDataBase:path dbName:@"test.sqlite"]) {
//        
//        NSArray *propertys = [self getPropertys];
//        
//        NSLog(@"---------");
//        
//
//        
//    
//        
//        
//    }else {
//        NSLog(@"+++++++++++++");
//    }
    

    
    
}

@end
