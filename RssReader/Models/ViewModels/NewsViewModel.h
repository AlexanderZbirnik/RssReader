//
//  NewsViewModel.h
//  RssReader
//
//  Created by Alex Zbirnik on 04.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RSSItem.h"
#import "RssNews+CoreDataClass.h"

@interface NewsViewModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *detailText;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *date;

- (instancetype)initWithRssItem: (RSSItem *) item;
- (instancetype)initWithRssNews: (RssNews *) news;

+ (NSArray *) newsModelsFromRssItems: (NSArray *) items;
+ (NSArray *) newsModelsFromRssNews: (NSArray *) rssNews;

@end
