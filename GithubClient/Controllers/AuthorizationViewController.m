//
//  AuthorizationViewController.m
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "AuthorizationViewController.h"

static NSInteger const AuthorizationViewControllerCodeLengthZero = 0;

@interface AuthorizationViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AuthorizationViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NetworkManager sharedManager] startMonitoringExistConnection:^{
        
        [self startAuthorization];
        
    } notExistConnection:^{
        
        [self openNoConnectionAlert];
    }];
}

#pragma mark - Authorization

-(void) startAuthorization {
    
    NSURLRequest *request = [[NetworkManager sharedManager] accessRequest];

    [self.webView loadRequest: request];
}
- (void) wrongAuthorization {
    
    [self stopNetworkActivity];
    [self openBadDataAlert];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [self startNetworkActivity];
    
    NSString *code = [[NetworkManager sharedManager] codeFromRequest:request];
    
    if (code.length > AuthorizationViewControllerCodeLengthZero) {
        
        [[NetworkManager sharedManager] getUserTokenWithCode:code completionHandler:^(NSString *token) {
            
            [self stopNetworkActivity];
            [[NetworkManager sharedManager] stopMonitoringConnection];
            
            [self.delegate authorizationViewController:self
                                             userToken:token];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        } failureHandler:^(NSError *error) {
            
            [self wrongAuthorization];
        }];
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self stopNetworkActivity];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self wrongAuthorization];
}


@end
