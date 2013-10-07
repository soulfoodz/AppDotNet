//
//  SignInViewController.h
//  AppDotNet
//
//  Created by MacBook Pro on 10/6/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSignInDelegate.h"

@interface SignInViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *userID;

- (IBAction)signInButtonPressed:(id)sender;

@property (strong, nonatomic) id <UserSignInDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *boxView;

@end
