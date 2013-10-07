//
//  GlobalTableViewController.m
//  AppDotNet
//
//  Created by MacBook Pro on 10/7/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import "GlobalTableViewController.h"
#import "TweetCell.h"
#import "PostStore.h"
#import "ProfileViewController.h"

@interface GlobalTableViewController ()

@end

@implementation GlobalTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"GETTING CALLED");
    
    self.postStore = [PostStore sharedAvatarStore];

    self.urlString = @"https://alpha-api.app.net/stream/0/posts/stream/global";
    self.tweetsArray = [self.postStore fetchTweetsByUser:self.urlString];
    
    [self initializeCustomTableViewCell];
}


- (void)initializeCustomTableViewCell
{
    UINib *nib;
    
    nib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"customCell"];
}


#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell;
    // NSString  *userNameString;
    UIImage   *avatarImage;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    
    //[self findTheTweetsTime:indexPath];
    
    //userNameString = [NSString stringWithFormat:@"@%@", [self.userInfoDict objectForKey:@"userName"]];
    avatarImage = [UIImage imageWithData:[self.tweetsArray[indexPath.row] objectForKey:@"avatarData"]];
        
    cell.nameLabel.text        = [self.tweetsArray[indexPath.row] objectForKey:@"name"];
    cell.userNameLabel.text    = [self.tweetsArray[indexPath.row] objectForKey:@"userName"];
    cell.tweetLabel.text       = [self.tweetsArray[indexPath.row] objectForKey:@"tweetText"];
    cell.avatarImageView.image = avatarImage;
    
    return cell;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileViewController *newPVC;
    
    newPVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    
    //synonymsArray = self.word.synonyms;
    newPVC.userID = [self.tweetsArray[indexPath.row] objectForKey:@"userName"];
    
    [self.navigationController pushViewController:newPVC animated:YES];
}



#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
