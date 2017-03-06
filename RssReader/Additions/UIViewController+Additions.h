//
//  UIViewController+Additions.h
//  2Bible
//
//  Created by Alex Zbirnik on 31.01.17.
//  Copyright © 2017 Alex Zbirnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

- (void) openAlertWithTitle: (NSString *) title andMessage: (NSString *) message;

- (void) startNetworkActivity;
- (void) stopNetworkActivity;

- (void) openController: (UIViewController *) controller howPopoverWithSize: (CGSize) size withSourceRect: (CGRect) rect navigationBarHidden: (BOOL) hidden andBackgroundColor: (UIColor *) color;

@end
