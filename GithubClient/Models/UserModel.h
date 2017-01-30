//
//  UserModel.h
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (assign, nonatomic) NSUInteger ID;
@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSString *avatarURLString;

- (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end
