//
//  ViewController.h
//  SQLiteDemo
//
//  Created by panda zheng on 13-4-14.
//  Copyright (c) 2013年 panda zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController
{
    sqlite3 *contactDB;
    
    UITextField *name;
    UITextField *address;
    UITextField *phone;
    
    UILabel *status;
    NSString *databasePath;
}

@property (retain,nonatomic) IBOutlet UITextField *name;
@property (retain,nonatomic) IBOutlet UITextField *address;
@property (retain,nonatomic) IBOutlet UITextField *phone;
@property (retain,nonatomic) IBOutlet UILabel *status;

- (IBAction) SaveToDataBase :(id)sender;
- (IBAction) SearchFromDataBase :(id)sender;
- (IBAction) backgroundTap:(id)sender;

@end
