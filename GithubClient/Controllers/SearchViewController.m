//
//  SearchViewController.m
//  GithubClient
//
//  Created by Alex Zbirnik on 26.01.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "SearchViewController.h"
#import "RapositoryTableView.h"


@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet RapositoryTableView *tableView;

@property (strong, nonatomic) NSArray *findedRepositories;
@property (strong, nonatomic) NSString *token;

@end

@implementation SearchViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.token = [[KeyChainManager sharedManager] getToken];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NetworkManager sharedManager] stopMonitoringConnection];
}

- (void) findRepositoriesWithText: (NSString *) text {
    
    if (self.token) {
        
        [self startNetworkActivity];
        
        [[NetworkManager sharedManager] findRepositoriesWithText: text andToken: self.token completionHandler:^(NSDictionary *responseDictionary) {
            
            [self stopNetworkActivity];
            [self parseAndDisplayRepositories:responseDictionary];
            
            
        } failureHandler:^(NSError *error) {
            
            [self stopNetworkActivity];
            [self openBadDataAlert];
        }];
        
    } else {
        
        [self openNoAuthorizedAlert];
    }
}

- (void) parseAndDisplayRepositories: (NSDictionary *) repositoriesDictionary {
    
    NSArray *responseItemsArray = [repositoriesDictionary objectForKey:@"items"];
    NSMutableArray *repositories = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in responseItemsArray) {
        
        RepositoryModel *repository =
        [[RepositoryModel alloc] initWithDictionary:dictionary];
        
        [repositories addObject:repository];
    }
    
    self.findedRepositories = repositories;
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.view endEditing:YES];
    
    [[NetworkManager sharedManager] startMonitoringExistConnection:^{
        
        [self findRepositoriesWithText:searchBar.text];
        
    } notExistConnection:^{
        
        [self openNoConnectionAlert];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.findedRepositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"repositoryCell";
    
    RepositoryCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell = [[RepositoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    RepositoryModel *repository = [self.findedRepositories objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = repository.name;
    cell.descriptionLabel.text = repository.textDescription;
    
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:repository.owner.avatarURLString]
                            placeholderImage:nil];
    
    return cell;
}

@end
