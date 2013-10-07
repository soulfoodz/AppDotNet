//
//  GlobalTableViewController.h
//  AppDotNet
//
//  Created by MacBook Pro on 10/7/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostStore;


@interface GlobalTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *userInfoDict;
@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) PostStore *postStore;
@property (strong, nonatomic) NSString *urlString;

@end
