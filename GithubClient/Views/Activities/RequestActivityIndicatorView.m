//
//  RequestActivityIndicatorView.m
//  GithubClient
//
//  Created by Alex Zbirnik on 28.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "RequestActivityIndicatorView.h"

static CGFloat const RequestActivityIndicatorViewSideLength = 36.f;

@implementation RequestActivityIndicatorView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self defaultActivityIndicatorViewStyle];
    }
    return self;
}

- (void) defaultActivityIndicatorViewStyle {
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.hidesWhenStopped = YES;
    self.color = [UIColor colorWithRed:0.24 green:0.40 blue:0.53 alpha:1.00];
}

- (void) addActivityIndicatorViewToCenter {
    
    [self.superview addConstraint: [NSLayoutConstraint constraintWithItem: self
                                                                attribute: NSLayoutAttributeWidth
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.superview
                                                                attribute: NSLayoutAttributeWidth
                                                               multiplier: CGFLOAT_MIN
                                                                 constant: RequestActivityIndicatorViewSideLength]];
    

    [self.superview addConstraint: [NSLayoutConstraint constraintWithItem: self
                                                                attribute: NSLayoutAttributeHeight
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.superview
                                                                attribute: NSLayoutAttributeHeight
                                                               multiplier: CGFLOAT_MIN
                                                                 constant: RequestActivityIndicatorViewSideLength]];
    

    [self.superview addConstraint: [NSLayoutConstraint constraintWithItem: self
                                                                attribute: NSLayoutAttributeCenterX
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.superview
                                                                attribute: NSLayoutAttributeCenterX
                                                               multiplier: 1.0
                                                                 constant: CGFLOAT_MIN]];
    
 
    [self.superview addConstraint: [NSLayoutConstraint constraintWithItem: self
                                                                attribute: NSLayoutAttributeCenterY
                                                                relatedBy: NSLayoutRelationEqual
                                                                   toItem: self.superview
                                                                attribute: NSLayoutAttributeCenterY
                                                               multiplier: 1.0
                                                                 constant: CGFLOAT_MIN]];
}

@end
