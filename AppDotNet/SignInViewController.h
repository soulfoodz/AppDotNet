//
//  SignInViewController.h
//  AppDotNet
//
//  Created by MacBook Pro on 10/6/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController

@property (strong, nonatomic) NSString *userID;

- (IBAction)signInButtonPressed:(id)sender;

@end
