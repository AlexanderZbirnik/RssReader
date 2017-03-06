//
//  RoundedButton.m
//  RssReader
//
//  Created by Alex Zbirnik on 06.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "RoundedButton.h"

@implementation RoundedButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
