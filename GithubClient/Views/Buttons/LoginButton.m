//
//  LoginButton.m
//  GithubClient
//
//  Created by Alex Zbirnik on 27.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "LoginButton.h"

@implementation LoginButton

- (void) setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (enabled) {
        
        self.backgroundColor = [UIColor orangeColor];
        
    } else {
        
        self.backgroundColor = [UIColor lightGrayColor];
    }
}

@end
