//
//  RSSParser.h
//  com-sergeyshtlv-TVBeta
//
//  Created by Администратор on 27.10.16.
//  Copyright © 2016 Iurii Oliiar Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSItem.h"

@protocol RSSParserDelegate;

@interface RSSParser : NSObject

@property (weak, nonatomic) id < RSSParserDelegate > delegate;

- (void) parseRssChannelInfo: (NSData *) rssData;
- (void) parseRssFeed: (NSData *) rssData;

@end

@protocol RSSParserDelegate

- (void) rssParser: (RSSParser *) rssParser finishRssFeed: (NSArray *) rssFeed;

@end
