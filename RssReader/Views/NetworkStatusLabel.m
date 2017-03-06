//
//  NetworkStatusLabel.m
//  RssReader
//
//  Created by Alex Zbirnik on 05.03.17.
//  Copyright © 2017 com.alexzbirnik. All rights reserved.
//

#import "NetworkStatusLabel.h"

@implementation NetworkStatusLabel

- (void) isOnline: (BOOL) onLine {
    
    if (onLine) {
        
        self.text = @"OnLine";
        self.textColor = [UIColor colorWithRed:0.00 green:0.85 blue:0.27 alpha:1.00];
        
    } else {
        
        self.text = @"OffLine";
        self.textColor = [UIColor colorWithRed:0.96 green:0.02 blue:0.08 alpha:1.00];
    }
}

@end
