//
//  RssChannelViewController.m
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "RssChannelViewController.h"
#import "UIViewController+Additions.h"
#import "NewsViewController.h"
#import "NetworkStatusLabel.h"
#import "NewsCell.h"

#import "NetworkManager.h"
#import "RSSParser.h"
#import "RSSItem.h"

#import "NewsViewModel.h"

@interface RssChannelViewController ()  < RSSParserDelegate >

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet NetworkStatusLabel *networkStatusLabel;

@property (strong, nonatomic) NSArray *rssFeed;

@end

@implementation RssChannelViewController

#pragma mark - UIViewController life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.rssChannel.title;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NetworkManager sharedManager] startMonitoringExistConnection:^{
        
        [self.networkStatusLabel isOnline:YES];
        [self getRssFeedFromNetwork];
        
    } notExistConnection:^{
        
        [self.networkStatusLabel isOnline:NO];
        [self getRssFeedFromCoreData];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NetworkManager sharedManager] stopMonitoringConnection];
}

- (void)dealloc {
    
    [self stopNetworkActivity];
}

#pragma mark - Get and save feed methods

- (void) getRssFeedFromNetwork {
    
    [self startNetworkActivity];
    [self.activityIndicator startAnimating];
    
    [[NetworkManager sharedManager] getRssFeedWithUrl:self.rssChannel.url
                                       successHandler:^(NSData *rssData) {
                                           
                                           [self stopNetworkActivity];
                                           [self.activityIndicator stopAnimating];
                                           
                                           RSSParser *rssParser = [[RSSParser alloc] init];
                                           
                                           rssParser.delegate = self;
                                           [rssParser parseRssFeed:rssData];
                                       }
                                    andFailureHandler:^(NSError *error) {
                                        
                                        [self openAlertWithTitle:@"Attention!"
                                                      andMessage:@"Loading error. Check  url."];
                                        
                                        [self stopNetworkActivity];
                                        [self.activityIndicator stopAnimating];
                                    }];
}

- (void) getRssFeedFromCoreData {
    
    NSArray *rssNews = [[CoreDataManager sharedManager] getRssFeedChannel:self.rssChannel.url];
    
    self.rssFeed = [NewsViewModel newsModelsFromRssNews:rssNews];
    
    [self.tableView reloadData];
}

- (void) saveRssFeedToCoreDataFromRssItems: (NSArray *) rssItems {
    
    [[CoreDataManager sharedManager] saveRssFeedToChannel:self.rssChannel.url fromRssItems:rssItems];
}

#pragma mark - RSSParserDelegate

- (void) rssParser: (RSSParser *) rssParser finishRssFeed: (NSArray *) rssFeed {
  
    self.rssFeed = [NewsViewModel newsModelsFromRssItems:rssFeed];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
    
    [self saveRssFeedToCoreDataFromRssItems:rssFeed];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rssFeed.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *identifier = @"newsCell";
    
    NewsCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NewsViewModel *news = [self.rssFeed objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = news.title;
    cell.detailLabel.text = news.detailText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsViewModel *news = [self.rssFeed objectAtIndex:indexPath.row];
    
    NewsViewController *newsViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"NewsViewController"];
    
    newsViewController.title = self.title;
    newsViewController.newsViewModel = news;
    
    [self.navigationController pushViewController:newsViewController animated:YES];
}

#pragma mark - Actions

- (IBAction)backBarButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
