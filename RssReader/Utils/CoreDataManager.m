//
//  CoreDataManager.m
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "CoreDataManager.h"
#import "RSSItem.h"

@implementation CoreDataManager

+ (instancetype) sharedManager {
    
    static CoreDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[CoreDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark - RssChannel methods

- (void) addDefaultRssChannelsWithsuccessHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        NSDictionary *defaultChannels =
        @{@"Футбол.уа": @"http://football.ua/rss2.ashx", @"ЛІГА.Бізнес": @"http://biz.liga.net/all/rss.xml", @"BBC": @"http://feeds.bbci.co.uk/news/world/rss.xml"};
        
        NSArray *keys = [defaultChannels allKeys];
        
        for (NSString *key in keys) {
            
            NSString *url = [defaultChannels objectForKey:key];
            
            RssChannel *channel = [RssChannel MR_findFirstByAttribute:@"url"
                                                            withValue:url
                                                            inContext:localContext];
            
            if (!channel) {
                
                [self createChannelWithTitle:key
                                      andUrl:url
                              inLocalContext:localContext];
            }
        }
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (error) {
            
            if (failure) {
                
                failure(error);
            }
            
        } else {
            
            if (success) {
                
                success();
            }
        }
    }];
}

- (void) addChannelWithTitle: (NSString *) title andUrl: (NSString *) url successHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        [self createChannelWithTitle:title
                              andUrl:url
                      inLocalContext:localContext];
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (error) {
            
            if (failure) {
                
                failure(error);
            }
            
        } else {
            
            if (success) {
                
                success();
            }
        }
    }];
}

- (void) createChannelWithTitle: (NSString *) title andUrl: (NSString *) url inLocalContext: (NSManagedObjectContext *) localContext {
    
    RssChannel *channel = [RssChannel MR_createEntityInContext:localContext];
    
    channel.title = title;
    channel.url = url;
}

- (NSArray *) getAllRssChannels {
    
    return [RssChannel MR_findAllSortedBy:@"title" ascending:YES];
}

- (void) deleteChannel: (RssChannel *) channel successHandler: (void(^) ()) success andFailureHandler: (void(^) (NSError *error)) failure {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        [channel MR_deleteEntityInContext:localContext];
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (error) {
            
            if (failure) {
                
                failure(error);
            }
            
        } else {
            
            if (success) {
                
                success();
            }
        }
    }];
}

#pragma mark - RssFeed methods

- (void) saveRssFeedToChannel: (NSString *) urlChannel fromRssItems: (NSArray *) rssItems {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        RssChannel *channel = [RssChannel MR_findFirstByAttribute:@"url"
                                                        withValue:urlChannel
                                                        inContext:localContext];
        
        NSArray *rssFeedArray = [channel.rssFeed allObjects];
        
        for (RssNews *rssNews in rssFeedArray) {
            
            [rssNews MR_deleteEntityInContext:localContext];
        }
        
        for (RSSItem *anyRssItem in rssItems) {
            
            RssNews *rssNews = [RssNews MR_createEntityInContext:localContext];
            
            rssNews.title = anyRssItem.title;
            rssNews.detail = anyRssItem.newsDesription;
            rssNews.url = anyRssItem.link;
            rssNews.date = anyRssItem.date;
            
            [channel addRssFeedObject:rssNews];
        }
    }];
}

- (NSArray *) getRssFeedChannel: (NSString *) urlChannel {

    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"rssChannel.url == %@", urlChannel];

    return [RssNews MR_findAllWithPredicate:predicate];
}

@end
