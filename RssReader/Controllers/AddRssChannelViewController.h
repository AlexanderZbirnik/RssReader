//
//  AddRssChannelViewController.h
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddRssChannelViewControllerDelegate;

@interface AddRssChannelViewController : UIViewController

@property (weak, nonatomic) id < AddRssChannelViewControllerDelegate > delegate;

@end

@protocol AddRssChannelViewControllerDelegate

@required

- (void) addRssChannelViewController: (AddRssChannelViewController *) addRssChannelViewController newRssChannelAdded: (NSString *) rssChannelTitle;

@end
