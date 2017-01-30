//
//  RepositoryModel.m
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "RepositoryModel.h"

@implementation RepositoryModel

- (instancetype)initWithDictionary: (NSDictionary *) dictionary
{
    self = [super init];
    if (self) {
        
        self.ID = [[dictionary objectForKey:@"id"] integerValue];
        self.name = [dictionary objectForKey:@"name"];
        self.textDescription = [dictionary objectForKey:@"description"];
        
        if (![self.textDescription isKindOfClass:[NSString class]]) {
            
            self.textDescription = @"Description don't exist :-[";
        }
        
        self.privateRepository = [[dictionary objectForKey:@"private"] boolValue];
        
        NSDictionary *ownerDictionary = [dictionary objectForKey:@"owner"];
        
        self.owner = [[UserModel alloc] initWithDictionary:ownerDictionary];
    }
    return self;
}

@end
