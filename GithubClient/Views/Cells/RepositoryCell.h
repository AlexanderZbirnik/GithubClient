//
//  RepositoryCell.h
//  GithubClient
//
//  Created by Alex Zbirnik on 27.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepositoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
