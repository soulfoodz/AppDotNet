//
//  PostStore.h
//  AppDotNet
//
//  Created by MacBook Pro on 10/5/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostStore : NSObject


// UserInfoDict always stores info for the current user.
// Same for userPostsArray

@property (strong, nonatomic) NSMutableDictionary *avatarDataForUsers;
@property (strong, nonatomic) NSMutableDictionary *backgroundImageDataForUsers;
@property (strong, nonatomic) NSMutableArray      *userPostsArray;
@property (strong, nonatomic) NSMutableArray      *allPostsArray;
@property (strong, nonatomic) NSMutableArray      *postsArray;


// - (void)refreshPosts;
- (NSMutableArray *)fetchTweetsByUser:(NSString *)userID;
- (NSDictionary *)fetchUserInfo:(NSString *)userID;
- (NSData *)saveAvatarImageDataForUserID:(NSString *)userID fromURL:(NSString *)urlString;
- (NSData *)fetchAvatarImageForUser:(NSString *)userID fromDictionary:(NSDictionary *)dict;


@end
