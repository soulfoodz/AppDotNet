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
#import "UserSignInDelegate.h"

@class PostStore;

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, UserSignInDelegate>

// Outlets

@property (weak, nonatomic) IBOutlet UIView                  *semiTransparentView;
@property (weak, nonatomic) IBOutlet UIView                  *blurContainerView;
@property (weak, nonatomic) IBOutlet UILabel                 *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel                 *userDescription;
@property (weak, nonatomic) IBOutlet UIButton                *followersButton;
@property (weak, nonatomic) IBOutlet UIButton                *followingButton;
@property (weak, nonatomic) IBOutlet UIButton                *starsButton;
@property (weak, nonatomic) IBOutlet UIImageView             *avaterImageView;
@property (weak, nonatomic) IBOutlet UIImageView             *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView             *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


// Properties

@property (strong, nonatomic) UITapGestureRecognizer *tapUp;
@property (strong, nonatomic) NSDictionary           *userInfoDict;
@property (strong, nonatomic) NSMutableArray         *userTweetsArray;
@property (strong, nonatomic) NSString               *userID;
@property (strong, nonatomic) UIImage                *userImage;
@property (strong, nonatomic) PostStore              *postStore;
@property (strong, nonatomic) NSString               *urlString;




@end
