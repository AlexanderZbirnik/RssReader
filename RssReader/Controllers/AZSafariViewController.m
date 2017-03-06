//
//  AZSafariViewController.m
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "AZSafariViewController.h"
#import "UIViewController+Additions.h"

@interface AZSafariViewController () <SFSafariViewControllerDelegate>


@end

@implementation AZSafariViewController

#pragma mark - UIViewController life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.view.tintColor = [UIColor orangeColor];
    
    UIBarButtonItem *backBarButton =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backBarButtonAction:)];
    
    backBarButton.tintColor = [UIColor orangeColor];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self startNetworkActivity];
}

- (void)dealloc {
    
    [self stopNetworkActivity];
}

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    
    [self stopNetworkActivity];
}

#pragma mark - Actions

- (void) backBarButtonAction: (id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
