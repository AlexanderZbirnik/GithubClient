//
//  UserModel.m
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithDictionary: (NSDictionary *) dictionary
{
    self = [super init];
    if (self) {
        
        self.ID = [[dictionary objectForKey:@"id"] integerValue];
        self.login = [dictionary objectForKey:@"login"];
        self.avatarURLString = [dictionary objectForKey:@"avatar_url"];
        
    }
    return self;
}

@end
