//
//  UserViewController.m
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "UserViewController.h"
#import "AuthorizationViewController.h"
#import "LoginButton.h"

@interface UserViewController () < AuthorizationViewControllerDelegate >

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLoginLabel;
@property (weak, nonatomic) IBOutlet LoginButton *loginButton;

@property (strong, nonatomic) UserModel *user;

@end

@implementation UserViewController

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.user) {
        
        [[NetworkManager sharedManager] startMonitoringExistConnection:^{
            
            self.loginButton.enabled = YES;
            [self userTokenVerification];
            
        } notExistConnection:^{
            
            self.loginButton.enabled = NO;
            [self openNoConnectionAlert];
        }];
    } else {
        
        [self displayUser:self.user];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NetworkManager sharedManager] stopMonitoringConnection];
}

- (void) userTokenVerification {
    
    NSString *token = [[KeyChainManager sharedManager] getToken];
    
    if (token) {
        
        self.avatarImageView.hidden = NO;
        self.userIDLabel.hidden = NO;
        self.userLoginLabel.hidden = NO;
        
        self.loginButton.hidden = YES;
        
        [self getUserInformationWithToken:token];
    }
}

- (void) getUserInformationWithToken: (NSString *) token {
    
    [self startNetworkActivity];
    
    [[NetworkManager sharedManager] getUserInfoWithToken:token completionHandler:^(NSDictionary *responseDictionary) {
        
        [self stopNetworkActivity];
        
        self.user =
        [[UserModel alloc] initWithDictionary:responseDictionary];
        
        [self displayUser:self.user];
        
    } failureHandler:^(NSError *error) {
        
        [self stopNetworkActivity];
        [self openBadDataAlert];
    }];
}

- (void) displayUser: (UserModel *) user {
    
    self.userIDLabel.text = [NSString stringWithFormat:@"id: %zd", user.ID];
    self.userLoginLabel.text = user.login;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarURLString]
                            placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
}

#pragma mark - AuthorizationViewControllerDelegate

- (void) authorizationViewController: (AuthorizationViewController *) authorizationViewController userToken: (NSString *) token {
    
    [[KeyChainManager sharedManager] saveToken:token];
    [self userTokenVerification];
}

#pragma mark - Actions

- (IBAction)loginButtonAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    
    AuthorizationViewController *authorizationController =
    [storyboard instantiateViewControllerWithIdentifier:@"AuthorizationViewController"];
    
    authorizationController.delegate = self;
    
    [self.navigationController presentViewController:authorizationController
                                            animated:YES
                                          completion:nil];
    
}

@end
