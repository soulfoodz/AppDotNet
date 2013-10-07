//
//  UserSignInDelegate.h
//  AppDotNet
//
//  Created by MacBook Pro on 10/7/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostStore.h"

@protocol UserSignInDelegate <NSObject>

- (void)setUserIdFromString:(NSString *)id withPostStore:(PostStore *)store;


@end
