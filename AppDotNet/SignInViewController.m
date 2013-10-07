//
//  SignInViewController.m
//  AppDotNet
//
//  Created by MacBook Pro on 10/6/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import "SignInViewController.h"
#import "ProfileViewController.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation SignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.boxView.layer.cornerRadius = 8.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonPressed:(id)sender
{
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    ProfileViewController *pvc;
//    pvc = segue.destinationViewController;
//    pvc.userID = self.textField.text;
//}









@end
