//
//  UIViewController+Additions.m
//  2Bible
//
//  Created by Alex Zbirnik on 31.01.17.
//  Copyright © 2017 Alex Zbirnik. All rights reserved.
//

#import "UIViewController+Additions.h"

@interface UIViewController() <UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate>

@end

@implementation UIViewController (Additions)

#pragma mark - Alert method

- (void) openAlertWithTitle: (NSString *) title andMessage: (NSString *) message {
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle: title
                                        message: message
                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle: @"Ok"
                             style: UIAlertActionStyleDefault
                           handler: nil];
    
    [alertController addAction: okAction];
    
    [self presentViewController: alertController animated: YES completion: nil];
}


#pragma mark - Netwok activity methods

- (void) startNetworkActivity {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void) stopNetworkActivity {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Popover methods

- (void) openController: (UIViewController *) controller howPopoverWithSize: (CGSize) size withSourceRect: (CGRect) rect navigationBarHidden: (BOOL) hidden andBackgroundColor: (UIColor *) color {
    
    UINavigationController *navigationCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationCtrl.modalPresentationStyle = UIModalPresentationPopover;
    navigationCtrl.navigationBarHidden = hidden;
    
    controller.preferredContentSize = size;
    
    UIPopoverPresentationController *popoverCtrl = navigationCtrl.popoverPresentationController;
    popoverCtrl.delegate = self;
    popoverCtrl.sourceView = self.view;
    popoverCtrl.sourceRect = rect;
    popoverCtrl.backgroundColor = color;
    
    [self presentViewController:navigationCtrl animated:YES completion:nil];
}

#pragma mark - UIAdaptivePresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

@end
