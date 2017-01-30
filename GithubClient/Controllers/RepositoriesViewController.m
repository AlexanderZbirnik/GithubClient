//
//  RepositoriesViewController.m
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "RepositoriesViewController.h"
#import "RapositoryTableView.h"

@interface RepositoriesViewController ()

@property (weak, nonatomic) IBOutlet RapositoryTableView *tableView;

@property (strong, nonatomic) NSArray *userRepositories;

@end

@implementation RepositoriesViewController

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NetworkManager sharedManager] startMonitoringExistConnection:^{
        
        [self getUserRepositories];
        
    } notExistConnection:^{
        
        [self openNoConnectionAlert];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NetworkManager sharedManager] stopMonitoringConnection];
}

- (void) getUserRepositories {
    
    NSString *token = [[KeyChainManager sharedManager] getToken];
    
    if (token) {
        
        [self startNetworkActivity];
        
        [[NetworkManager sharedManager] getUserRepositoriesWithToken:token completionHandler:^(NSArray *responseArray) {
            
            [self stopNetworkActivity];
            [self parseAndDisplayUserRepositories:responseArray];
            
        } failureHandler:^(NSError *error) {
            
            [self stopNetworkActivity];
            [self openBadDataAlert];
        }];
        
    } else {
        
        [self openNoAuthorizedAlert];
    }
}

- (void) parseAndDisplayUserRepositories: (NSArray *) repositoriesArray {
    
    NSMutableArray *repositories = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in repositoriesArray) {
        
        RepositoryModel *repository =
        [[RepositoryModel alloc] initWithDictionary:dictionary];
        
        [repositories addObject:repository];
    }
    
    self.userRepositories = repositories;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.userRepositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"repositoryCell";
    
    RepositoryCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell = [[RepositoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    RepositoryModel *repository = [self.userRepositories objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = repository.name;
    cell.descriptionLabel.text = repository.textDescription;
    
    if (repository.privateRepository) {
        
        cell.avatarImageView.image = [UIImage imageNamed:@"lock"];
        
        
    } else {
        
        cell.avatarImageView.image = [UIImage imageNamed:@"unlock"];
    }
    
    return cell;
}

@end
