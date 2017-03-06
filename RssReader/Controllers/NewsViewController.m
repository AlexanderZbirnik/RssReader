//
//  NewsViewController.m
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "NewsViewController.h"
#import "AZSafariViewController.h"
#import "NetworkStatusLabel.h"

#import "NetworkManager.h"

@interface NewsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *openSafariBarBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet NetworkStatusLabel *networkStatusLabel;


@end

@implementation NewsViewController

#pragma mark - UIViewController life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.newsViewModel.title;
    self.detailLabel.text = self.newsViewModel.detailText;
    self.dateLabel.text = self.newsViewModel.date;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NetworkManager sharedManager] startMonitoringExistConnection:^{
        
        [self.openSafariBarBtn setEnabled:YES];
        [self.networkStatusLabel isOnline:YES];
        
    } notExistConnection:^{
        
        [self.openSafariBarBtn setEnabled:NO];
        [self.networkStatusLabel isOnline:NO];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NetworkManager sharedManager] stopMonitoringConnection];
}

#pragma mark - Actions

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openSafariBarBtnAction:(id)sender {
    
    NSURL *URL = [NSURL URLWithString:self.newsViewModel.url];
    
    AZSafariViewController *safariViewController =
    [[AZSafariViewController alloc] initWithURL:URL];
    
    safariViewController.title = self.title;
    
    [self.navigationController pushViewController:safariViewController animated:YES];
}



@end
