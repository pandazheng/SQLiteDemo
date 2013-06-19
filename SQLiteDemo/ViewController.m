//
//  ViewController.m
//  SQLiteDemo
//
//  Created by panda zheng on 13-4-14.
//  Copyright (c) 2013年 panda zheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize name;
@synthesize address;
@synthesize phone;
@synthesize status;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex: 0];
    
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"contacts.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:databasePath] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT,PHONE TEXT)";
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                status.text = @"创建表失败\n";
            }
        }
        else
        {
            status.text = @"创建/打开数据库失败";
        }
    }
}

- (IBAction)SaveToDataBase:(id)sender
{
    sqlite3_stmt *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO CONTACTS (name,address,phone) VALUES(\"%@\",\"%@\",\"%@\")",name.text,address.text,phone.text];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement)==SQLITE_DONE) {
            status.text = @"已存储到数据库";
            name.text = @"";
            address.text = @"";
            phone.text = @"";
        }
        else
        {
            status.text = @"保存失败";
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
}
- (IBAction)SearchFromDataBase:(id)sender
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT address,phone from contacts where name=\"%@\"",name.text];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *addressField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                address.text = addressField;
                
                NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                phone.text = phoneField;
                
                status.text = @"已查到结果";
            }
            else {
                status.text = @"未查到结果";
                address.text = @"";
                phone.text = @"";
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}

//关闭键盘
- (IBAction) backgroundTap:(id)sender
{
    [name resignFirstResponder];
    [phone resignFirstResponder];
    [address resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
