//
//  NetworkManager.m
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "NetworkManager.h"

static NSString * const NetworkManagerCallBackUrl = @"https://github.com";
static NSString * const NetworkManagerClientID = @"6d240ac45f5631a1045a";
static NSString * const NetworkManagerClientSecret = @"88fbdb0f5d35ba916302d48f800112542b6f3f01";

static NSString * const NetworkManagerScopeParameters = @"user,repo";

static NSString *  const NetworkManagerGetUserTokenURLString = @"https://github.com/login/oauth/access_token";
static NSString *  const NetworkManagerGetUserInfoApiURLString = @"https://api.github.com/user";
static NSString *  const NetworkManagerGetUserRepositoriesApiURLString = @"https://api.github.com/user/repos";

static NSString *  const NetworkManagerSearchRepositoriesApiURLString = @"https://api.github.com/search/repositories";

@interface NetworkManager()

@end

@implementation NetworkManager

+ (instancetype) sharedManager {
    
    static NetworkManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[NetworkManager alloc] init];
    });
    
    return manager;
}

#pragma mark - Reachability methods

- (void) startMonitoringExistConnection: (void (^)()) existConnection notExistConnection: (void (^)()) notExistConnection {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            if (existConnection) {
                
                existConnection();
            }
            
        } else {
            
            if (notExistConnection) {
                
                notExistConnection();
            }
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void) stopMonitoringConnection {
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark - Manipulation request methods

- (NSURLRequest *) accessRequest {
    
    NSString *URLString =
    [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@",
                                NetworkManagerClientID, NetworkManagerCallBackUrl, NetworkManagerScopeParameters];
    
    NSURL *URL = [NSURL URLWithString: URLString];

    return [NSURLRequest requestWithURL:URL
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10.0];
}

- (NSString *) codeFromRequest: (NSURLRequest *) request {
    
    NSString *requestURLString = [request.URL absoluteString];
    
    NSString *codeString = [NSString stringWithFormat:@"%@/?code=", NetworkManagerCallBackUrl];
    
    if ([requestURLString hasPrefix:codeString]) {
        
        return [requestURLString substringFromIndex:codeString.length];
        
    } else {
        
        return @"";
    }
}

#pragma mark - User methods

- (void) getUserTokenWithCode: (NSString *) code completionHandler: (void (^)(NSString *token)) completionHandler failureHandler: (void (^)(NSError *error)) failureHandler {
    
    NSDictionary *parameters = @{@"code": code,
                                 @"client_id": NetworkManagerClientID,
                                 @"redirect_uri": NetworkManagerCallBackUrl,
                                 @"client_secret": NetworkManagerClientSecret};
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manager POST:NetworkManagerGetUserTokenURLString
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *responseDictionary = (NSDictionary *) responseObject;
              
              NSString *token = [responseDictionary objectForKey:@"access_token"];
              
              if (completionHandler) {
                  
                  completionHandler(token);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
              if (failureHandler) {
                  
                  failureHandler(error);
              }
          }];
}

- (void) getUserInfoWithToken: (NSString *) token completionHandler: (void (^)(NSDictionary *responseDictionary)) completionHandler  failureHandler: (void (^)(NSError *error)) failureHandler {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSString *tokenValue =
    [NSString stringWithFormat:@"token %@", token];
    
    [manager.requestSerializer setValue:tokenValue forHTTPHeaderField:@"Authorization"];
    
    [manager GET:NetworkManagerGetUserInfoApiURLString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             if (completionHandler) {
                 
                 completionHandler(responseObject);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             if (failureHandler) {
                 
                 failureHandler(error);
             }
         }];
}

- (void) getUserRepositoriesWithToken: (NSString *) token completionHandler: (void (^)(NSArray *responseArray)) completionHandler  failureHandler: (void (^)(NSError *error)) failureHandler {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *tokenValue =
    [NSString stringWithFormat:@"token %@", token];
    
    [manager.requestSerializer setValue:tokenValue forHTTPHeaderField:@"Authorization"];
    
    [manager GET:NetworkManagerGetUserRepositoriesApiURLString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             if (completionHandler) {
                 
                 completionHandler(responseObject);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             if (failureHandler) {
                 
                 failureHandler(error);
             }
         }];
}

#pragma mark - Repositories methods

- (void) findRepositoriesWithText: (NSString *) text andToken: (NSString *) token completionHandler: (void (^)(NSDictionary *responseDictionary)) completionHandler  failureHandler: (void (^)(NSError *error)) failureHandler {
    
    NSDictionary *parameters = @{@"q": text,
                                 @"order": @"asc"};
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *tokenValue =
    [NSString stringWithFormat:@"token %@", token];
    
    [manager.requestSerializer setValue:tokenValue forHTTPHeaderField:@"Authorization"];
    
    [manager GET:NetworkManagerSearchRepositoriesApiURLString
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             if (completionHandler) {
                 
                 completionHandler(responseObject);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             if (failureHandler) {
                 
                 failureHandler(error);
             }
         }];
}

@end
