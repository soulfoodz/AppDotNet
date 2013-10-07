//
//  ProfileViewController.m
//  AppDotNet
//
//  Created by MacBook Pro on 10/5/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import "ProfileViewController.h"
#import "FollowTableViewController.h"
#import "SignInViewController.h"
#import "TweetCell.h"
#import "PostStore.h"

@interface ProfileViewController ()
{
    BOOL tableViewIsUp;
    BOOL isFirstRun;
    UIImage *blurredImage;
}

@end

@implementation ProfileViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        {
            [self fetchUserID];
        }
    return self;
}


- (void)viewDidLoad
{
    if (!self.userID) [self fetchUserID];
    else
    {
        //PostStore *postStore;
        
        [super viewDidLoad];
        
        //postStore = [PostStore sharedAvatarStore];
        
        tableViewIsUp = NO;
        self.urlString = [NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/users/%@/posts",self.userID];

        self.userInfoDict    = [self.postStore fetchUserInfo:self.userID];
        self.userTweetsArray = [self.postStore fetchTweetsByUser:self.urlString];
        
        [self initializeCustomTableViewCell];
        [self setTableViewAnimation];
        [self setLabels];
        [self setImages];
    }
}

   // [self performSelectorInBackground:@selector(captureBlur) withObject:nil];

# pragma mark - Initial setup

- (void)fetchUserID
{
    [self performSegueWithIdentifier:@"SegueToSignIn" sender:self];
}


- (void)setLabels
{
    // Buttons
    [self.followersButton setTitle:[self.userInfoDict objectForKey:@"followers"] forState:UIControlStateNormal];
    [self.followingButton setTitle:[self.userInfoDict objectForKey:@"following"] forState:UIControlStateNormal];
    [self.starsButton     setTitle:[self.userInfoDict objectForKey:@"stars"]     forState:UIControlStateNormal];
    
    // Labels
    self.nameLabel.text       = [self.userInfoDict objectForKey:@"name"];
    self.userDescription.text = [self.userInfoDict objectForKey:@"userDescription"];
    self.navigationItem.title = [self.userInfoDict objectForKey:@"userName"];
}


- (void)setImages
{
    
    self.userImage = [UIImage imageWithData:[self.userInfoDict objectForKey:@"userAvatar"]];
    self.avaterImageView.image = self.userImage;
    self.backgroundImage.image = [UIImage imageWithData:[self.userInfoDict objectForKey:@"userCoverImage"]];
}


#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userTweetsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell;
    NSString  *userNameString;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    
    //[self findTheTweetsTime:indexPath];
    
    userNameString = [NSString stringWithFormat:@"@%@", [self.userInfoDict objectForKey:@"userName"]];
    
    cell.nameLabel.text        = [self.userInfoDict objectForKey:@"name"];
    cell.userNameLabel.text    = [self.userInfoDict objectForKey:@"userName"];
    cell.tweetLabel.text       = [self.userTweetsArray[indexPath.row] objectForKey:@"tweetText"];
    cell.avatarImageView.image = self.userImage;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Recent Posts";
}


- (void)initializeCustomTableViewCell
{
    UINib *nib;

    nib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"customCell"];
}


#pragma mark - TableView Animation



- (void)setTableViewAnimation
{
    self.tapUp   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.tableView addGestureRecognizer:self.tapUp];
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
             CGRect scrollFrame = CGRectMake(0.0f, 258.0f, 320.0f, 310.0f);
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
             CGRect scrollFrame = CGRectMake(0.0f, 468.0f, 320.0f, 100.0f);
             self.tableView.frame = scrollFrame;
             self.tableView.scrollEnabled = NO;
             self.tableView.userInteractionEnabled = YES;
             tableViewIsUp = NO;
             
         }
                         completion:nil];
        
    }
}


# pragma mark - Cover image blur effect

- (void)captureBlur
{
    // Get a UIImage From the uiview
    
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
    [self.blurContainerView insertSubview:newView belowSubview:self.semiTransparentView];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToSignIn"])
    {
        SignInViewController *svc;
        
        svc = segue.destinationViewController;
        svc.delegate = self;
    }
}


#pragma mark - UserSignIn delegate

- (void)setUserIdFromString:(NSString *)id withPostStore:(PostStore *)store
{
    self.postStore = store;
    self.userID = id;
    [self viewDidLoad];
}



/*

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
    
    UINib *nib;
    
    nib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"customCell"];
    
    [self performSelectorInBackground:@selector(captureBlur) withObject:nil];
    
    self.tapUp   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.tableView addGestureRecognizer:self.tapUp];
    
    NSURL        *url;
    NSURLRequest *request;
    NSString     *urlString;
    
    if (!self.userID) self.userID = @"@mashable";
    
    // Begin call to url
    urlString = [NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/users/%@", self.userID];
    url       = [NSURL URLWithString:urlString];
    request   = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSString       *description;
         NSString       *usernameString;
         NSDictionary   *tempDict;
         
         
         tempDict = [NSJSONSerialization JSONObjectWithData:data
                                                       options:0
                                                         error:&connectionError];
         
         self.userInfoDict = [tempDict objectForKey:@"data"];
         
         
         // Fetch and set the username and real name
         usernameString          = [NSString stringWithFormat:@"@%@", [self.userInfoDict objectForKey:@"username"]];
         self.userNameLabel.text = usernameString;
         self.nameLabel.text     = [self.userInfoDict objectForKey:@"name"];
         
         self.navigationItem.title = self.userNameLabel.text;
         
         NSNumber *num = [[self.userInfoDict objectForKey:@"counts"] objectForKey:@"followers"];
         
         NSLog(@"%@", num);
         
         // Followers and Following labels
         id followers = [[self.userInfoDict objectForKey:@"counts"] objectForKey:@"followers"];
         self.followersLabel.text = [NSString stringWithFormat:@"%@", followers];
         
         id following = [[self.userInfoDict objectForKey:@"counts"] objectForKey:@"following"];
         self.followingLabel.text = [NSString stringWithFormat:@"%@", following];


         // Fetch and set the user image
         self.userImage = [self fetchUsersAvatarImage];
         self.avaterImageView.image = self.userImage;
         
         // Fetch and set the user image
         self.backgroundImage.image = [self fetchUsersAvatarImage];
         
         // Fetch and set the user description
         description               = [[self.userInfoDict objectForKey:@"description"] objectForKey:@"text"];
         self.userDescription.text = description;
         self.userDescription.textAlignment = NSTextAlignmentLeft;
         
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
    backgroundImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    
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
         
         [self.tableView reloadData];
         
         NSLog(@"GOT tweets");
      }];
    
    NSLog(@"Getting tweets");
}



#pragma mark - Date Formatting

- (void)findTheTweetsTime:(NSIndexPath *)indexPath
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter;
    
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    
    NSString *createdAt = [self.userTweetsArray[indexPath.row] objectForKey:@"created_at"];
    NSString *newCreatedAt = [createdAt stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *thirdCreatedAt = [newCreatedAt stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    
    NSLog(@"%@", thirdCreatedAt);
    
    NSDate *date = [dateFormatter dateFromString:thirdCreatedAt];
    
    
    NSLog(@"new date : %@", date);
    
    
}


#pragma mark - TableView DataSource
     
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userTweetsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell;
    NSString  *userNameString;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    
    [self findTheTweetsTime:indexPath];
    
    userNameString = [NSString stringWithFormat:@"@%@", [self.userInfoDict objectForKey:@"username"]];
    
    cell.userNameLabel.text     = userNameString;
    cell.nameLabel.text         = [self.userInfoDict objectForKey:@"name"];
    cell.tweetLabel.text        = [self.userTweetsArray[indexPath.row] objectForKey:@"text"];
    cell.avatarImageView.image  = self.userImage;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Recent Posts";
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
            CGRect scrollFrame = CGRectMake(0.0f, 258.0f, 320.0f, 310.0f);
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
             CGRect scrollFrame = CGRectMake(0.0f, 468.0f, 320.0f, 100.0f);
             self.tableView.frame = scrollFrame;
             self.tableView.scrollEnabled = NO;
             self.tableView.userInteractionEnabled = YES;
             tableViewIsUp = NO;
             
         }
                         completion:nil];

    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FollowTableViewController *dvc;
    dvc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"SegueToFollowing"])
    {
        
    }
    
    
    if ([segue.identifier isEqualToString:@"SegueToFollowers"])
    {
        
    }
}

 
*/

@end
