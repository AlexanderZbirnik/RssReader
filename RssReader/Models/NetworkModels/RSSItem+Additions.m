//
//  RSSItem+Additions.m
//  com-sergeyshtlv-TVBeta
//
//  Created by Администратор on 31.10.16.
//  Copyright © 2016 Iurii Oliiar Inc. All rights reserved.
//

#import "RSSItem+Additions.h"

@implementation RSSItem (Additions)
- (NSString *)description
{
    return [NSString stringWithFormat:@"title: %@, newsDesription: %@, link: %@, date: %@, imageUrl: %@", self.title, self.newsDesription, self.link, self.date, self.imageUrl];
}

@end
