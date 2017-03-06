//
//  RssListViewController.m
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//
#import "RssListViewController.h"
#import "RssChannelViewController.h"
#import "AddRssChannelViewController.h"
#import "UIViewController+Additions.h"

#import "CoreDataManager.h"

NSString * const SecondOpenAppKey = @"SecondOpenAppKey";

@interface RssListViewController () < AddRssChannelViewControllerDelegate >

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addRssChannelBarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *rssChannels;

@end

@implementation RssListViewController

#pragma mark - UIViewController life cycle methods

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [MagicalRecord setupAutoMigratingCoreDataStack];
        [self checkOpenApp];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    [self getAndViewAllRssChannels];
}

- (void) checkOpenApp {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:SecondOpenAppKey]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SecondOpenAppKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[CoreDataManager sharedManager] addDefaultRssChannelsWithsuccessHandler:nil
                                                               andFailureHandler:nil];
    }
}

- (void) getAndViewAllRssChannels {
    
    self.rssChannels =
    [[CoreDataManager sharedManager] getAllRssChannels];
    
    [self.tableView reloadData];
}

#pragma mark - AddRssChannelViewControllerDelegate

- (void) addRssChannelViewController: (AddRssChannelViewController *) addRssChannelViewController newRssChannelAdded: (NSString *) rssChannelTitle {
        
    [self getAndViewAllRssChannels];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rssChannels.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    RssChannel *channel = [self.rssChannels objectAtIndex:indexPath.row];
    
    [[CoreDataManager sharedManager] deleteChannel:channel
                                    successHandler:^{
                                        
                                        NSMutableArray *channels =
                                        [[NSMutableArray alloc] initWithArray:self.rssChannels];
                                        
                                        [channels removeObjectAtIndex:indexPath.row];
                                        
                                        self.rssChannels = channels;
                                        
                                        [self.tableView reloadData];
                                        
                                    } andFailureHandler:^(NSError *error) {
                                        
                                        NSLog(@"error: %@", error);
                                    }];
}


#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NSLocalizedString(@"Delete", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"defaultCell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    RssChannel *channel = [self.rssChannels objectAtIndex:indexPath.row];
    
    cell.textLabel.text = channel.title;
    cell.detailTextLabel.text = channel.url;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RssChannel *channel = [self.rssChannels objectAtIndex:indexPath.row];
        
    RssChannelViewController *rssChannekViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"RssChannelViewController"];
    
    rssChannekViewController.rssChannel = channel;
    
    [self.navigationController pushViewController:rssChannekViewController animated:YES];
}

#pragma mark - Actions

- (IBAction)recoveryChannelsBarButtonAction:(id)sender {
    
    [[CoreDataManager sharedManager] addDefaultRssChannelsWithsuccessHandler:^{
        
        self.rssChannels =
        [[CoreDataManager sharedManager] getAllRssChannels];
        
        [self.tableView reloadData];
        
    } andFailureHandler:^(NSError *error) {
        
        NSLog(@"error: %@", error);
    }];
}

- (IBAction)addRssChannelBarButtonAction:(id)sender {
    
    AddRssChannelViewController *addRssChannelViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"AddRssChannelViewController"];
    
    addRssChannelViewController.delegate = self;
    
    CGFloat screenWidth  = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat contentHeight = 168.f;
    
    CGSize  contentSize = CGSizeMake(screenWidth, contentHeight);
    CGRect  sourceRect  = CGRectMake(screenWidth - 40.f, 0, 40, 44);
    
    [self openController:addRssChannelViewController
      howPopoverWithSize:contentSize
          withSourceRect:sourceRect
     navigationBarHidden:NO
      andBackgroundColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00]];
}

@end
