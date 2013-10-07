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

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.avatarDataForUsers = [[NSMutableDictionary alloc]  init];
    }
    
    return self;
}


- (NSDictionary *)fetchUserInfo:(NSString *)userID
{
    NSURL          *url;
    NSURLRequest   *request;
    NSURLResponse  *response;
    NSError        *error;
    NSError        *connectionError;
    NSData         *data;
    NSString       *urlString;
    NSDictionary   *userInfoDict;
    NSString       *descriptionString;
    NSString       *usernameString;
    NSString       *nameString;
    NSDictionary   *tempDict;
    NSDictionary   *userDataDict;
    NSData         *userImageData;
    NSData         *userCoverImageData;
    
    
   // if (!self.userID) self.userID = @"@mashable";
    
    // Begin call to url
    urlString = [NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/users/%@", userID];
    url       = [NSURL URLWithString:urlString];
    request   = [NSURLRequest requestWithURL:url];
    data      = [NSURLConnection sendSynchronousRequest:request
                                      returningResponse:&response
                                                  error:&error];
    
    tempDict  = [NSJSONSerialization JSONObjectWithData:data
                                                options:0
                                                  error:&connectionError];
    
    userInfoDict = [tempDict objectForKey:@"data"];

    // Fetch and set the username and real name
    usernameString = [NSString stringWithFormat:@"@%@", [userInfoDict objectForKey:@"username"]];
    nameString     = [userInfoDict objectForKey:@"name"];

    // Set Followers and Following to string
    id followers = [[userInfoDict objectForKey:@"counts"] objectForKey:@"followers"];
    id following = [[userInfoDict objectForKey:@"counts"] objectForKey:@"following"];
    NSString *followersString = [NSString stringWithFormat:@"%@", followers];
    NSString *followingString = [NSString stringWithFormat:@"%@", following];

    descriptionString = [[userInfoDict objectForKey:@"description"] objectForKey:@"text"];

    // Fetch the user image data
    userImageData = [self fetchAvatarImageForUser:userID fromDictionary:userInfoDict];

    // Fetch the users background image data
    userCoverImageData = [self fetchCoverImageForUser:userID fromDictionary:userInfoDict];

    userDataDict = @{@"userName": usernameString,
                         @"name": nameString,
                    @"followers": followersString,
                    @"following": followingString,
              @"userDescription": descriptionString,
                   @"userAvatar": userImageData,
               @"userCoverImage": userCoverImageData,
                     };
    
    return userDataDict;
}


- (NSMutableArray *)fetchTweetsByUser:(NSString *)userID
{
    NSLog(@"Fetch Tweets got called");
    
    NSString       *urlString;
    NSURL          *url;
    NSURLRequest   *request;
    NSURLResponse  *response;
    NSData         *data;
    NSDictionary   *tempDict;
    NSMutableArray *tweetsArray;
    NSMutableArray *tempArray;
    NSError        *connectionError;
    NSError        *error;
    
    tweetsArray = [NSMutableArray new];
    
    urlString = [NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/users/%@/posts", userID];
    url       = [NSURL URLWithString:urlString];
    request   = [NSURLRequest requestWithURL:url];
    data      = [NSURLConnection sendSynchronousRequest:request
                                      returningResponse:&response
                                                  error:&error];
    
    tempDict = [NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:&connectionError];
    
    tempArray = [tempDict objectForKey:@"data"];
    
    NSLog(@"Data array: %@", tempArray);


    // Enumerate through the array of tweets, setting the usable values.
    for (id tweet in tempArray)
    {
        NSString *tweetString;
        NSString *tweetIDString;
        NSString *userNameString;
        NSString *nameString;
        NSString *imageDataString;

        // NSData   *avatarImageData;

        tweetString     = [tweet objectForKey:@"text"];
        tweetIDString   = [tweet objectForKey:@"id"];
        userNameString  = [NSString stringWithFormat:@"%@", [[tweet objectForKey:@"user"] objectForKey:@"username"]];
        nameString      = [[tweet objectForKey:@"user"] objectForKey:@"name"];
        
        // Handle the avatarImage
        imageDataString = [[[tweet objectForKey:@"user"] objectForKey:@"avatar_image"] objectForKey:@"url"];
       
        [self saveAvatarImageDataForUserID:userNameString fromURL:imageDataString];
        
        NSLog(@"ImageData for userID ");
        
        // Create Dictionary out of tweet info
        
        NSDictionary *tweetDict = @{@"tweetText": tweetString,
                              @"tweetID": tweetIDString,
                             @"userName": userNameString,
                                 @"name": nameString,
                           @"avatarData": [self.avatarDataForUsers objectForKey:userNameString],};
        
        // Add each tweet dictionary to the array
        [tweetsArray addObject:tweetDict];
    }
    
    NSLog(@"TweetsArray : %@", tweetsArray);
    return tweetsArray;
}


- (NSData *)saveAvatarImageDataForUserID:(NSString *)userID fromURL:(NSString *)urlString
{
    __block NSData *imageData;
    
    [self.avatarDataForUsers enumerateKeysAndObjectsUsingBlock:^(NSString *key, id image, BOOL *stop)
     {
         if ([key isEqualToString:userID] && [self.avatarDataForUsers objectForKey:key] != nil)
         {
             imageData = [self.avatarDataForUsers objectForKey:key];
             YES;
         }
         else
         {
             [self.avatarDataForUsers setObject:urlString forKey:userID];
             imageData = [self.avatarDataForUsers objectForKey:key];
             YES;
         }
     }];
    
    return imageData;
}


- (NSData *)fetchAvatarImageForUser:(NSString *)userID fromDictionary:(NSDictionary *)dict
{
    NSString *imageURLString;
    NSData *avatarImageData;
    NSURL *url;
    
    imageURLString  = [[dict objectForKey:@"avatar_image"] objectForKey:@"url"];
    url             = [NSURL URLWithString:imageURLString];
    avatarImageData = [NSData dataWithContentsOfURL:url];
    
    // Add the image data to our dictionary to save time when reloading
    [self.avatarDataForUsers setObject:avatarImageData forKey:userID];
    
    return avatarImageData;
}


- (NSData *)fetchCoverImageForUser:(NSString *)userID fromDictionary:(NSDictionary *)dict
{
    NSString *imageURLString;
    NSData *coverImageData;
    NSURL *url;
    
    imageURLString      = [[dict objectForKey:@"cover_image"] objectForKey:@"url"];
    url                 = [NSURL URLWithString:imageURLString];
    coverImageData = [NSData dataWithContentsOfURL:url];
    
    return coverImageData;
}



/*


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
 
*/







@end
