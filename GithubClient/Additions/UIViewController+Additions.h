//
//  UIViewController+Additions.h
//  GithubClient
//
//  Created by Alex Zbirnik on 27.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

- (void) openNoConnectionAlert;
- (void) openBadDataAlert;
- (void) openNoAuthorizedAlert;
- (void) openAlertWithTitle: (NSString *) title andMessage: (NSString *) message;

@end
