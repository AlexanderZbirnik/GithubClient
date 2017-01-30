//
//  NetworkManager.h
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkManager : NSObject

+ (instancetype) sharedManager;

- (void) startMonitoringExistConnection: (void (^)()) existConnection notExistConnection: (void (^)()) notExistConnection;
- (void) stopMonitoringConnection;

- (NSURLRequest *) accessRequest;
- (NSString *) codeFromRequest: (NSURLRequest *) request;

- (void) getUserTokenWithCode: (NSString *) code completionHandler: (void (^)(NSString *token)) completionHandler failureHandler: (void (^)(NSError *error)) failureHandler;

- (void) getUserInfoWithToken: (NSString *) token completionHandler: (void (^)(NSDictionary *responseDictionary)) completionHandler  failureHandler: (void (^)(NSError *error)) failureHandler;

- (void) getUserRepositoriesWithToken: (NSString *) token completionHandler: (void (^)(NSArray *responseArray)) completionHandler  failureHandler: (void (^)(NSError *error)) failureHandler;

- (void) findRepositoriesWithText: (NSString *) text andToken: (NSString *) token completionHandler: (void (^)(NSDictionary *responseDictionary)) completionHandler  failureHandler: (void (^)(NSError *error)) failureHandler;

@end
