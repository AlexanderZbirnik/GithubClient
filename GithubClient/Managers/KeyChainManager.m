//
//  KeyChainManager.m
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "KeyChainManager.h"
#import "SAMKeychain.h"

static NSString * const KeyChainManagerService = @"https://github.com";
static NSString * const KeyChainManagerAccount = @"User";

static NSString * const KeyChainManagerSecondOpen = @"KeyChainManagerSecondOpen";

@implementation KeyChainManager

+ (instancetype) sharedManager {
    
    static KeyChainManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[KeyChainManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        BOOL secondOpen = [[NSUserDefaults standardUserDefaults] boolForKey:KeyChainManagerSecondOpen];
        
        if (!secondOpen) {
            
            [SAMKeychain deletePasswordForService:KeyChainManagerService
                                          account:KeyChainManagerAccount];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KeyChainManagerSecondOpen];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}

- (BOOL) saveToken: (NSString *) token {
    
    return [SAMKeychain setPassword: token
                         forService: KeyChainManagerService
                            account: KeyChainManagerAccount];

}

- (NSString *) getToken {
    
    return [SAMKeychain passwordForService:KeyChainManagerService
                                   account:KeyChainManagerAccount];
}

- (BOOL) deleteToken {
    
    return [SAMKeychain deletePasswordForService:KeyChainManagerService
                                         account:KeyChainManagerAccount];
}


@end
