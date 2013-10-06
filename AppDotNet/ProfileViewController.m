//
//  ProfileViewController.m
//  AppDotNet
//
//  Created by MacBook Pro on 10/5/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
{
    BOOL tableViewIsUp;
    UIImage *blurredImage;
}

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated
{
    self.blurView.alpha = 1.0f;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableViewIsUp = NO;
    
    [self performSelectorInBackground:@selector(captureBlur) withObject:nil];
    
    self.tapUp   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.tableView addGestureRecognizer:self.tapUp];


    
    NSURL        *url;
    NSURLRequest *request;
    NSString     *urlString;
    
    if (!self.userID) self.userID = @"59872";
    
    // Begin call to url
    urlString = [NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/users/%@", self.userID];
       
    url       = [NSURL URLWithString:urlString];
    request   = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSString *description;
         NSString *usernameString;
         NSDictionary *tempDict;
         
         
         tempDict = [NSJSONSerialization JSONObjectWithData:data
                                                       options:0
                                                         error:&connectionError];
         
         self.userInfoDict = [tempDict objectForKey:@"data"];
         
         
         // Fetch and set the username and real name
         usernameString          = [NSString stringWithFormat:@"@%@", [self.userInfoDict objectForKey:@"username"]];
         self.userNameLabel.text = usernameString;
         self.nameLabel.text     = [self.userInfoDict objectForKey:@"name"];

         // Fetch and set the user image
         self.userImage = [self fetchUsersAvatarImage];
         self.avaterImageView.image = self.userImage;
         
         // Fetch and set the user image
         self.backgroundImage.image = [self fetchUsersAvatarImage];
         
         // Fetch and set the user description
         description               = [[self.userInfoDict objectForKey:@"description"] objectForKey:@"text"];
         self.userDescription.text = description;
         self.userDescription.textAlignment = NSTextAlignmentCenter;
         
         // Fetch recent tweets
         [self fetchUsersRecentTweets];
         
         
//         // Gather all posts from retrieved data for "data" and put it in our posts array
//         dataArray = [allDataDict objectForKey:@"data"];
//         
//         // Fetch the "user" and "post" dictionary keys and put them in the userArray property
//         for (int i = 0; i < dataArray.count; i++)
//         {
//             [self.userDict = [[self.dataArray objectAtIndex:i] objectForKey:@"user"]];
//             [self.postsArray addObject:[[self.allPostsArray objectAtIndex:i] objectForKey:@"text"]];
//         }
         
         [self.activityIndicator stopAnimating];

     }];
    
    [self.activityIndicator startAnimating];
}


- (void)captureBlur
{
    // Get a UIImage From the uiview
    
    NSLog(@"blur capture");
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.blurContainerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Blur the UIImage
    CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur forKey:@"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:0.0f] forKey:@"inputRadius"];
    CIImage *resultImage = [gaussianBlurFilter valueForKey:@"outputImage"];
    
    //Create UIImage from filtered image
    blurredImage = [[UIImage alloc] initWithCIImage:resultImage];
    
    //Place the UIImage in a UIImageView
    UIImageView *newView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    newView.image = blurredImage;
    
    // Insert blur UIImageView below transparent view inside the blur image container
    [self.blurContainerView insertSubview:newView belowSubview:self.blurView];
}



- (UIImage *)fetchUsersAvatarImage
{
    NSString *imageURLString;
    UIImage *avatarImage;
    NSURL *url;
    
    imageURLString  = [[self.userInfoDict objectForKey:@"avatar_image"] objectForKey:@"url"];
    url             = [NSURL URLWithString:imageURLString];
    avatarImage     = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    
    return avatarImage;
}


- (UIImage *)fetchUsersBackgroundImage
{
    NSString *imageURLString;
    UIImage *backgroundImage;
    NSURL *url;
    
    imageURLString  = [[self.userInfoDict objectForKey:@"cover_image"] objectForKey:@"url"];
    url             = [NSURL URLWithString:imageURLString];
    backgroundImage     = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    
    return backgroundImage;
}



- (void)fetchUsersRecentTweets
{
    NSString     *urlString;
    NSURL        *url;
    NSURLRequest *request;
    
    urlString = [NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/users/%@/posts", self.userID];
    url       = [NSURL URLWithString:urlString];
    request   = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *tempDict;
         
         tempDict = [NSJSONSerialization JSONObjectWithData:data
                                                    options:0
                                                      error:&connectionError];
         
         self.userTweetsArray = [tempDict objectForKey:@"data"];
         
        // NSLog(@"Tweets: %@", self.userTweetsArray);
         
         [self.tableView reloadData];
         
         NSLog(@"GOT tweets");
      }];
    
    NSLog(@"Getting tweets");
}


#pragma mark - TableView DataSource
     
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userTweetsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                             reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [self.userInfoDict objectForKey:@"username"];
    
    cell.detailTextLabel.text          = [self.userTweetsArray[indexPath.row] objectForKey:@"text"];
    cell.detailTextLabel.font          = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.LineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect imageFrame = CGRectMake(10, 10, 36, 36);
    cell.imageView.frame = imageFrame;
    cell.imageView.image = self.userImage;
    
    NSLog(@"cell text : %@", cell.detailTextLabel.text);
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}


- (void)handleTap
{
    if (!tableViewIsUp)
    {
    NSLog(@"You tapped!!");
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^()
        {
            CGRect scrollFrame = CGRectMake(0.0f, 232.0f, 320.0f, 348.0f);
            self.tableView.frame = scrollFrame;
            self.tableView.scrollEnabled = YES;
            self.tableView.userInteractionEnabled = YES;
            tableViewIsUp = YES;
        }
                     completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^()
         {
             CGRect scrollFrame = CGRectMake(0.0f, 468.0f, 320.0f, 348.0f);
             self.tableView.frame = scrollFrame;
             self.tableView.scrollEnabled = NO;
             self.tableView.userInteractionEnabled = YES;
             tableViewIsUp = NO;
             
         }
                         completion:nil];

    }
}


 


@end
