//
//  NewsViewModel.m
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "NewsViewModel.h"

@implementation NewsViewModel

- (instancetype)initWithRssItem: (RSSItem *) item
{
    self = [super init];
    if (self) {
        
        self.title = item.title;
        self.detailText = [self convertUnicodeString:item.newsDesription];
        self.url = item.link;
        self.date = [self convertDateString:item.date];
    }
    return self;
}

- (instancetype)initWithRssNews: (RssNews *) rssNews
{
    self = [super init];
    if (self) {
        
        self.title = rssNews.title;
        self.detailText = rssNews.detail;
        self.url = rssNews.url;
        self.date = [self convertDateString:rssNews.date];
    }
    return self;
}

+ (NSArray *) newsModelsFromRssItems: (NSArray *) items {
    
    NSMutableArray *news = [[NSMutableArray alloc] init];
    
    for (RSSItem *anyItem in items) {
        
        NewsViewModel *newsViewModel = [[NewsViewModel alloc] initWithRssItem:anyItem];
        
        [news addObject:newsViewModel];
    }
    
    return news;
}

+ (NSArray *) newsModelsFromRssNews: (NSArray *) rssNews {
    
    NSMutableArray *news = [[NSMutableArray alloc] init];
    
    for (RssNews *anyNews in rssNews) {
        
        NewsViewModel *newsViewModel = [[NewsViewModel alloc] initWithRssNews:anyNews];
        
        [news addObject:newsViewModel];
    }
    
    return news;
}

- (NSString *) convertDateString: (NSString *) dateString {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE, dd MMM yyyy HH:mm:ss ZZZ"];
    
    NSDate *date = [dateFormat dateFromString:dateString];
    
    [dateFormat setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    return [dateFormat stringFromDate:date];
}

- (NSString *) convertUnicodeString: (NSString *) unicodeString {
    
    NSError *error = nil;
    
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"\\[?&#[0-9]{1,8};\\]?"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    
    if (error) {
        
        return unicodeString;
        
    } else {
        
        NSString *modifiedString =
        [regex stringByReplacingMatchesInString:unicodeString
                                        options:0
                                          range:NSMakeRange(0, [unicodeString length]) withTemplate:@""];
        
        return [modifiedString stringByAppendingString:@" ..."];
    }
}

@end
