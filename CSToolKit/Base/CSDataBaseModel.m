//
//  CSDataBaseModel.m
//  CSKit
//
//  Created by fengzhong-ios-chengshu on 2020/4/14.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSDataBaseModel.h"
#import <sqlite3.h>
#import "CSFileHandle.h"

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
    
    NSString *path = [[CSFileHandle shareSingleCase] getObjectPath:FolderCachesType folderRelativePath:CSToolKitFolder fileName:DataBaseFolder];
    
    if ([self openDataBase:path dbName:@"test.sqlite"]) {
        
        NSArray *propertys = [self getPropertys];
        
        NSLog(@"---------");
        

        
    
        
        
    }else {
        NSLog(@"+++++++++++++");
    }
    
//    if ([self openDataBase:[CSFileHandle shareSingleCase]] dbName:<#(NSString *)#>]) {
//        <#statements#>
//    }
    
    
}

@end
