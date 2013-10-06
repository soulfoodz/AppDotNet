//
//  ProfileViewController.h
//  AppDotNet
//
//  Created by MacBook Pro on 10/5/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>


@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *blurContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *userDescription;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *blurView;

@property (strong, nonatomic) UITapGestureRecognizer *tapUp;
@property (strong, nonatomic) NSDictionary *userInfoDict;
@property (strong, nonatomic) NSMutableArray *userTweetsArray;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) UIImage *userImage;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;


- (void)fetchUsersRecentTweets;
- (UIImage *)fetchUsersAvatarImage;

@end
