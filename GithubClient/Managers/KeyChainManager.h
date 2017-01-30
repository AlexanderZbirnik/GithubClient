//
//  KeyChainManager.h
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainManager : NSObject

+ (instancetype) sharedManager;

- (BOOL) saveToken: (NSString *) token;

- (NSString *) getToken;

- (BOOL) deleteToken;

@end
