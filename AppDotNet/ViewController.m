//
//  ViewController.m
//  AppDotNet
//
//  Created by MacBook Pro on 10/4/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import "ViewController.h"
#import "TweetCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.allPostsArray = [NSMutableArray new];
    self.postsArray    = [NSMutableArray new];
    self.userArray     = [NSMutableArray new];
    
    [self refreshFeed:self];
}


- (IBAction)refreshFeed:(id)sender
{
    NSURL        *url;
    NSURLRequest *request;
    NSString     *urlString;
    
    // Begin call to url
    urlString = @"https://alpha-api.app.net/stream/0/posts/stream/global";
    url       = [NSURL URLWithString:urlString];
    request   = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSMutableDictionary *allDataDict = [NSMutableDictionary new];
         
         allDataDict = [NSJSONSerialization JSONObjectWithData:data
                                                       options:0
                                                         error:&connectionError];
         
         // Gather all posts from retrieved data for "data" and put it in our posts array
         self.allPostsArray = [allDataDict objectForKey:@"data"];
         
         // Fetch the "user" and "post" dictionary keys and put them in the userArray property
         for (int i = 0; i < self.allPostsArray.count; i++)
         {
             [self.userArray addObject:[[self.allPostsArray objectAtIndex:i] objectForKey:@"user"]];
             [self.postsArray addObject:[[self.allPostsArray objectAtIndex:i] objectForKey:@"text"]];
         }
         
         [self.tableView reloadData];
         [self.activityIndicator stopAnimating];
     }];
    
    [self.activityIndicator startAnimating];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    cell.usernameLabel.text = [self.userArray[indexPath.row] objectForKey:@"username"];
    cell.tweetLabel.text    = self.postsArray[indexPath.row];
    cell.imageView.image    = [self fetchUsersAvatarImage:indexPath];
    
    NSLog(@"cell text : %@", cell.tweetLabel.text);
    return cell;
}



- (UIImage *)fetchUsersAvatarImage:(NSIndexPath *)indexPath
{
    NSString *imageURLString;
    UIImage *avatarImage;
    NSURL *url;
    
    imageURLString  = [[self.userArray[indexPath.row] objectForKey:@"avatar_image"] objectForKey:@"url"];
    url             = [NSURL URLWithString:imageURLString];
    avatarImage     = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    
    return avatarImage;
}












@end
