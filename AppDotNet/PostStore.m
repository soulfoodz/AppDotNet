//
//  PostStore.m
//  AppDotNet
//
//  Created by MacBook Pro on 10/5/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import "PostStore.h"
#import "ProfileViewController.h"

@implementation PostStore


- (void)refreshFeed:(id)sender
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
         
     }];
}


@end
