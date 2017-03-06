//
//  CoreDataManager.h
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>

#import "RssChannel+CoreDataClass.h"
#import "RssNews+CoreDataClass.h"

@interface CoreDataManager : NSObject

+ (instancetype) sharedManager;

- (void) addDefaultRssChannelsWithsuccessHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure;
- (void) addChannelWithTitle: (NSString *) title andUrl: (NSString *) url successHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure;
- (NSArray *) getAllRssChannels;
- (void) deleteChannel: (RssChannel *) channel successHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure;

- (void) saveRssFeedToChannel: (NSString *) urlChannel fromRssItems: (NSArray *) rssItems;
- (NSArray *) getRssFeedChannel: (NSString *) urlChannel;

@end
