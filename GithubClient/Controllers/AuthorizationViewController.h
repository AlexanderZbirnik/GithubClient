//
//  AuthorizationViewController.h
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@protocol AuthorizationViewControllerDelegate;

@interface AuthorizationViewController : ParentViewController

@property (weak, nonatomic) id < AuthorizationViewControllerDelegate > delegate;

@end

@protocol AuthorizationViewControllerDelegate

@required

- (void) authorizationViewController: (AuthorizationViewController *) authorizationViewController userToken: (NSString *) token;

@end
