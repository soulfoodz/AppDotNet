//
//  ViewController.h
//  AppDotNet
//
//  Created by MacBook Pro on 10/4/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) NSMutableArray *allPostsArray;
@property (strong, nonatomic) NSMutableArray *postsArray;

- (IBAction)refreshFeed:(id)sender;


@end