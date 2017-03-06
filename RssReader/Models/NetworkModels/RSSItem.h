//
//  RSSItem.h
//  com-sergeyshtlv-TVBeta
//
//  Created by Администратор on 27.10.16.
//  Copyright © 2016 Iurii Oliiar Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *newsDesription;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *imageUrl;

@end
