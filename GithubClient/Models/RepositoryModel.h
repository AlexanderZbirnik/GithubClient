//
//  RepositoryModel.h
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface RepositoryModel : NSObject

@property (assign, nonatomic) NSUInteger ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *textDescription;
@property (assign, nonatomic) BOOL privateRepository;

@property (strong, nonatomic) UserModel *owner;

- (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end
