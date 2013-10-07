//
//  ViewController.m
//  AppDotNet
//
//  Created by MacBook Pro on 10/4/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import "ViewController.h"
#import "TweetCell.h"
#import "PostStore.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.allPostsArray = [NSMutableArray new];
    self.postsArray    = [NSMutableArray new];
    self.userArray     = [NSMutableArray new];
    
   // [self refreshFeed:self];
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userArray.count;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
//    
//    cell.textLabel.text = [self.userArray[indexPath.row] objectForKey:@"username"];
//   
//    //cell.detailTextLabel.text          = self.postsArray[indexPath.row];
//    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
//    cell.detailTextLabel.numberOfLines = 3;
//    [cell.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
//
//    cell.imageView.image    = [self fetchUsersAvatarImage:indexPath];
//    
//    NSLog(@"cell text : %@", cell.textLabel.text);
//    return cell;
//}



//- (UIImage *)fetchUsersAvatarImage:(NSString *)userID
//{
//    NSString *imageURLString;
//    UIImage *avatarImage;
//    NSURL *url;
//    
//    imageURLString  = [[self.userArray[indexPath.row] objectForKey:@"avatar_image"] objectForKey:@"url"];
//    url             = [NSURL URLWithString:imageURLString];
//    avatarImage     = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
//    
//    return avatarImage;
//}












@end
