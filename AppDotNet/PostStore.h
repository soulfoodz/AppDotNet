//
//  PostStore.h
//  AppDotNet
//
//  Created by MacBook Pro on 10/5/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostStore : NSObject

@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) NSMutableArray *allPostsArray;
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (strong, nonatomic) NSString *username;

- (void)refreshFeed:(id)sender;
- (NSDictionary *)pullUserInfo:(NSString *)string;
- (NSMutableArray *)pullRecentPostsByUser:(NSString *)user;



@end
